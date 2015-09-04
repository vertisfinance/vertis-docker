import click

from runutils import runbash, run_daemon, getvar


NGINIX_CONF = getvar('NGINIX_CONF')


@click.group()
def run():
    pass


@run.command()
@click.argument('user', default='nginx')
def shell(user):
    runbash(user)


@run.command()
def start():
    params = ['nginx', '-c', NGINIX_CONF]
    run_daemon(params)


if __name__ == '__main__':
    run()
