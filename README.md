# docker-gitpuller
A docker container that clones a git repository over ssh, checks out a branch and then periodically pulls updates.
by: m.demeijer@nerdalize.com

## Build the container
`docker build -t gitpuller .`

## Usage
The simplest way is to specify a github repository. This requires [setting up a Deploy Key on github](https://developer.github.com/guides/managing-deploy-keys/).
Mount the private ssh deploy key in /root/.ssh/id_rsa when starting the container.
The container will add github.com to known hosts, allowing non-interactive access to github over ssh. It will then clone the repository into /repo inside the container and checkout the master branch. Mount a volume to /repo to enable sharing the repository with other containers.
Then every miutes it will issue a git pull on the repo.

`docker run -e REPO_URL=git@github.com:USERNAME/REPO.git -v /home/someone/keys_with_pull_access/id_rsa:/root/.ssh/id_rsa nerdalize/gitpuller:latest`

Several parameters can be configured at container start-time:

**REPO_URL** the url to the git repository e.g. git@github.com:someuser/somerepo.git, there is no default
**REPO_DIR_PATH** the absolute path where to clone the repository to e.g. "/repo" or ""/foo/somename", defaults to "/repo"
**REPO_DOMAIN** the domainname of the git host, needed to add the host to /root/.ssh/known_hosts, defaults to "github.com"
**REPO_BRANCH_NAME** the name of the branch to checkout after cloning, defaults to "master"
**WAIT_SECONDS** number of seconds to sleep between pulls, defaults to 60 seconds

### Example:
```
docker run \
  -e REPO_URL=git@github.com:USERNAME/REPO.git \
  -e REPO_DIR_PATH=/repository \
  -e REPO_DOMAIN=github.com \
  -e REPO_BRANCH_NAME=version1  \
  -e WAIT_SECONDS=120 \
  -v /home/someone/keys_with_pull_access/id_rsa:/root/.ssh/id_rsa
  nerdalize/gitpuller:latest
```
