from pygithub3 import Github
from fabric.api import local, hide, output
from os import path, chdir

output['warnings'] = True
output['running'] = True
output['stdout'] = True
output['stderr'] = True

GITHUB_USER = "parsely-devops"
with open("/home/emmett/git/parsely/secret.txt", "r") as f:
    GITHUB_TOKEN = f.read().strip("\n")
GITHUB_ORG = "Parsely"

repos_dir = path.dirname(path.abspath(__file__))
repo_names = []
exclude = [
    'attic',
    'mediawiki-importer',
    'sfpy',
    'datejs_light',
    'Misty',
    'grahout',
    'functional-js-slides',
    'devsite',
    'tldextract',
    'parselyshare',
    'Extract-API',
    'chef-mongodb',
    'python-crawling-slides',
    'python-nlp-slides',
    'grunt-saucelabs',
    'zookeeper_dashboard',
    'datasift-python',
    'deathmatch',
    'tool',
    'www-cms',
    'libcloud',
    'api-showcase',
    'wikistats',
    'json-ld.org',
    'python-adv-slides',
    'samsa',
    'python-solr',
    'd3-tutorial',
    'flower',
    'python-bloomfilter',
    'python-goose',
    'solrcloudpy',
    'python-pds',
    'nbviewer',
    'parsely-data',
    'js-parsely',
    'custom-mlt',
    'schemato-private',
    'emailipy'
]

gh = Github(login=GITHUB_USER, token=GITHUB_TOKEN)
for repo in gh.repos.list_by_org(GITHUB_ORG).iterator():
    repo_names += [repo.name] if repo.name not in exclude else []
repo_names += ['web.wiki']

for repo_name in repo_names:
    repo_path = path.join(repos_dir, repo_name)
    if path.exists('{}/.git'.format(repo_path)):
        print("Fetching {}...".format(repo_name))
        local('. $HOME/.keychain/$(/bin/hostname)-sh ; cd {} ; git fetch'.format(repo_path))
    else:
        chdir(repos_dir)
        print("Cloning {}...".format(repo_name))
        local('. $HOME/.keychain/$(/bin/hostname)-sh ; cd {} ; git clone --recursive git@github.com:Parsely/{}.git {}'\
            .format(repos_dir, repo_name, repo_path))
