import click
import signal

from runutils import runbash, run_daemon, getvar


@click.group()
def run():
    pass


@run.command()
@click.argument('user', default='ssh')
def shell(user):
    runbash(user)


@run.command()
def start_server():
    SSHD_CONFIG = getvar('SSHD_CONFIG')
    start = ['/usr/sbin/sshd', '-D', '-f', SSHD_CONFIG, '-e']
    run_daemon(start, signal_to_send=signal.SIGTERM)


@run.command()
def start_client():
    SSH_CONFIG = getvar('SSH_CONFIG')
    SSH_HOST = getvar('SSH_HOST')
    start = ['ssh', '-N', '-F', SSH_CONFIG, SSH_HOST]
    run_daemon(start, signal_to_send=signal.SIGTERM)


if __name__ == '__main__':
    run()
