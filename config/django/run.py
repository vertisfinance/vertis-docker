import signal
# import time

import click
# import psycopg2

from runutils import run_daemon, runbash, ensure_dir


UWSGI_CONF = '/config/uwsgi.conf'


################################################
# INIT: WILL RUN BEFORE ANY COMMAND AND START  #
# Modify it according to container needs       #
# Init functions should be fast and idempotent #
################################################


def init():
    ensure_dir('/data/static',
               owner='django', group='django', permsission_str='777')


######################################################################
# COMMANDS                                                           #
# Add your own if needed, remove or comment out what is unnecessary. #
######################################################################

@click.group()
def run():
    init()


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
    start = ["uwsgi", "--ini", UWSGI_CONF]
    run_daemon(start, signal_to_send=signal.SIGQUIT, user='django')


if __name__ == '__main__':
    run()
