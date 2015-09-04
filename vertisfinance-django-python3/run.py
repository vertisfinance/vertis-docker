import signal
# import time

import click
# import psycopg2

from runutils import run_daemon, runbash, getvar, ensure_dir


def initdirs():
    ensure_dir('/data/static',
               owner='django', group='django', permsission_str='777')


@click.group()
def run():
    initdirs()


@run.command()
@click.argument('user', default='developer')
def shell(user):
    runbash(user)


@run.command()
def start_runserver():
    start = ['django-admin.py', 'runserver', '0.0.0.0:8000']
    run_daemon(start, signal_to_send=signal.SIGINT, user='django')


@run.command()
def start_uwsgi():
    """Starts the service."""
    start = ["uwsgi", "--ini", getvar('UWSGI_CONF')]
    run_daemon(start, signal_to_send=signal.SIGQUIT, user='django')


if __name__ == '__main__':
    run()
