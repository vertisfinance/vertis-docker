# coding: utf-8

import os
import re
import sys
import subprocess
import time
import signal
from contextlib import contextmanager

import click

from runutils import (run_daemon, getvar, runbash, id, run_cmd, setuser,
                      ensure_dir)


CONFIG_FILE = getvar('CONFIG_FILE')
PGDATA = getvar('PGDATA')
PGDATA_PARENT = os.path.split(PGDATA)[0]
SOCKET_DIR = getvar('SOCKET_DIR')
BACKUP_DIR = getvar('BACKUP_DIR')


start_postgres = ['postgres', '-c', 'config_file=%s' % CONFIG_FILE]


def psqlparams(command=None, database='postgres'):
    if command is None:
        return ['psql', '-d', database, '-h', SOCKET_DIR]
    else:
        return ['psql', '-d', database, '-h', SOCKET_DIR, '-c', command]


@contextmanager
def running_db():
    # let's start the database if needed
    subproc = None
    if not os.path.isfile(os.path.join(PGDATA, 'postmaster.pid')):
        setpostgresuser = setuser('postgres')
        subproc = subprocess.Popen(
            start_postgres,
            preexec_fn=setpostgresuser,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE)

        click.echo('Waiting for database to start...')
        time.sleep(1)

    try:
        yield
    finally:
        # and stop when finished
        if subproc:
            subproc.send_signal(signal.SIGTERM)
            click.echo('Waiting for database to stop...')
            subproc.wait()


def initdirs():
    ensure_dir(PGDATA_PARENT,
               owner='root', group='root', permsission_str='777')
    ensure_dir(SOCKET_DIR,
               owner='root', group='root', permsission_str='777')
    ensure_dir(BACKUP_DIR,
               owner='postgres', group='postgres', permsission_str='700')


@click.group()
def run():
    initdirs()


@run.command()
@click.argument('user', default='postgres')
def shell(user):
    runbash(user)


@run.command()
def initdb():
    params = ['initdb']
    run_cmd(params, user='postgres', message='Initializing the database')


@run.command()
@click.option('--username', prompt=True)
@click.option('--password', prompt=True,
              hide_input=True, confirmation_prompt=True)
def createuser(username, password):
    """Creates a user with the given password."""

    sql = "CREATE USER %s WITH PASSWORD '%s'" % (username, password)

    with running_db():
        run_cmd(psqlparams(sql), 'Creating user', user='postgres')


@run.command()
@click.option('--username', prompt=True)
@click.option('--password', prompt=True,
              hide_input=True, confirmation_prompt=True)
def setpwd(username, password):
    """Sets the password for the given user."""

    sql = "ALTER USER %s WITH PASSWORD '%s'" % (username, password)

    with running_db():
        run_cmd(psqlparams(sql), 'Setting password', user='postgres')


@run.command()
@click.option('--dbname', prompt=True)
@click.option('--owner', prompt=True)
def createdb(dbname, owner):
    """Creates a database."""

    sql = "CREATE DATABASE %s WITH ENCODING 'UTF8' OWNER %s"
    sql = sql % (dbname, owner)

    with running_db():
        run_cmd(psqlparams(sql), 'Creating database', user='postgres')


def _backup(backupname, user, database):
    """
    Backs up the database. The postgres process must be running
    in some other container (on this host).
    """

    if re.match('[a-z0-9_-]+$', backupname) is None:
        click.secho('Invalid backupname.', fg='red')
        sys.exit(1)

    filename = os.path.join(BACKUP_DIR, backupname)
    if os.path.isfile(filename):
        click.secho('File %s exists.' % filename, fg='red')
        sys.exit(1)

    params = ['pg_dump', '-h', SOCKET_DIR, '-O', '-x', '-U', user, database]

    with open(filename, 'w') as f:
        ret = subprocess.call(params, stdout=f, preexec_fn=setuser('postgres'))

    uid, gid, _ = id('postgres')
    os.chown(filename, uid, gid)

    if ret == 0:
        click.secho('Successful backup: %s' % filename, fg='green')
    else:
        try:
            os.remove(filename)
        except:
            pass
        click.secho('Backup (%s) failed' % filename, fg='red')
        sys.exit(1)


@run.command()
@click.option('--backupname', prompt=True)
@click.option('--user', prompt=True)
@click.option('--database', prompt=True)
@click.option('--do_backup', is_flag=True,
              prompt='Should we make backup?', default=False)
def restore(backupname, user, database, do_backup):
    """
    Recreatest the database from a backup file. This will drop the
    original database.
    """

    filename = os.path.join(BACKUP_DIR, backupname)
    if not os.path.isfile(filename):
        click.secho('File %s does not exist.' % filename, fg='red')
        sys.exit(1)

    with running_db():
        if do_backup:
            backupname = 'pre_restore_%s' % int(time.time())
            _backup(backupname, user, database)

        sql = 'DROP DATABASE %s;' % database

        run_cmd(psqlparams(sql),
                message='Dropping database %s' % database,
                user='postgres')

        sql = ("CREATE DATABASE %s "
               "WITH OWNER %s "
               "ENCODING 'UTF8'" % (database, user))
        run_cmd(psqlparams(sql),
                message='Creating database %s' % database,
                user='postgres')

        run_cmd(psqlparams() + ['-f', filename],
                message='Restoring',
                user='postgres')


@run.command()
@click.option('--backupname', prompt=True)
@click.option('--user', prompt=True)
@click.option('--database', prompt=True)
def backup(backupname, user, database):
    with running_db():
        _backup(backupname, user, database)


@run.command()
def start():
    run_daemon(start_postgres, user='postgres')


if __name__ == '__main__':
    run()
