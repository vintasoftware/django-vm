import os
from tempfile import mkdtemp
from contextlib import contextmanager

from fabric.operations import put
from fabric.api import env, local, sudo, run, cd, prefix, task, settings

env.id_rsa_pub_file = '~/.ssh/id_rsa.pub'
env.lcwd = 'src'

env.git_bare_dir = '/apps/example.git'
env.root_dir = '/apps/example'
env.django_dir = '%s/example' % env.root_dir
env.media_dir = '%s/media' % env.django_dir
env.static_dir = '%s/static' % env.django_dir
env.requirements_file = '%s/requirements/production.txt' % env.root_dir
env.settings_file = 'core.settings.production'
env.virtualenv = '%s/env' % env.root_dir
env.activate = 'source %s/bin/activate ' % env.virtualenv

env.branch = 'master'
env.remote = 'vagrant'


@contextmanager
def _virtualenv():
    with prefix(env.activate):
        yield


def _manage_py(command):
    run('python manage.py %s --settings=%s' % (command, env.settings_file))


def _parse_ssh_config(text):
    try:
        lines = text.split('\n')
        lists = [l.split(' ') for l in lines]
        lists = [filter(None, l) for l in lists]

        tuples = [(l[0], ''.join(l[1:]).strip().strip('\r')) for l in lists]

        return dict(tuples)

    except IndexError:
        raise Exception("Malformed input")


def _set_env_for_user():
    # set ssh key file for vagrant
    result = local('vagrant ssh-config', capture=True)
    data = _parse_ssh_config(result)

    try:
        env.user = data['User']
        env.host = data['HostName']
        env.port = data['Port']
        env.host_string = '%s@%s:%s' % (env.user, env.host, env.port)
        env.key_filename = data['IdentityFile'].strip('"')
    except KeyError:
        raise Exception("Missing data from ssh-config")


@task
def clean():
    _set_env_for_user()

    with cd(env.root_dir):
        run('find . -name "*.pyc" -delete')


@task
def deps():
    _set_env_for_user()

    with cd(env.root_dir):
        with _virtualenv():
            run('pip install -r %s' % env.requirements_file)


@task
def setup():
    _set_env_for_user()

    with cd(env.django_dir):
        with _virtualenv():
            _manage_py('syncdb --noinput')
            _manage_py('migrate')
            _manage_py('createsuperuser')

@task
def authorize_key():
    _set_env_for_user()

    id_rsa_pub = local('cat %s' % env.id_rsa_pub_file, capture=True)
    run('echo "%s" >> ~/.ssh/authorized_keys' % id_rsa_pub)


@task
def push():
    _set_env_for_user()

    with settings(warn_only=True):
        remote_result = local('git remote | grep %s' % env.remote)
        if not remote_result.succeeded:
            local('git remote add %s ssh://%s@%s:%s%s' %
                (env.remote, env.user, env.host, env.port, env.git_bare_dir))

        result = local("git push %s %s" % (env.remote, env.branch))

        if not result.succeeded:
            with cd(env.git_bare_dir):
                run("git init --bare")
                local("git push %s %s" % (env.remote, env.branch))

            with cd(env.root_dir):
                run("git init")
                run("git remote add origin %s" % env.git_bare_dir)

    with cd(env.root_dir):
        run("git pull origin master")