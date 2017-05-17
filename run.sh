#!/bin/bash



# exit with a message
# usage:
#   die "something is wrong"
die() { echo ">> ERROR: $@" 1>&2 ; exit 1; }

# print a debug message
# usage:
#   dbg "hello, something is happening..."
dbg() { echo ">> $@"; }

# print the value of a variable
# usage: showvar VAR
showvar() { echo ">> $1 = ${!1}"; }

REPO_DIR_PATH=${REPO_DIR_PATH:-'/repo'}
REPO_DOMAIN=${REPO_DOMAIN:-'github.com'}
REPO_URL=${REPO_URL}
REPO_BRANCH_NAME=${REPO_BRANCH_NAME:-'master'}
WAIT_SECONDS=${WAIT_SECONDS:-'60'}

dbg "gitpuller started"
showvar REPO_DIR_PATH
showvar REPO_DOMAIN
showvar REPO_URL
showvar REPO_BRANCH_NAME
showvar WAIT_SECONDS

dbg "setting ssh key for ${REPO_DOMAIN}"
chmod 700 /root/.ssh/id_rsa
chown root:root /root/.ssh/id_rsa
# add git server to known hosts to prevent interactive prompt
#touch /root/.ssh/known_hosts
#ssh-keyscan -t rsa ${REPO_DOMAIN} >> /root/.ssh/known_hosts


# clone or pull
dbg "entering update loop"
while true
do
  if [ -d ${REPO_DIR_PATH}/.git ]
  then
    dbg "pull updates from ${REPO_URL} branch ${REPO_BRANCH_NAME} in ${REPO_DIR_PATH}"
    cd ${REPO_DIR_PATH};
    git pull;
  else
    dbg "clone ${REPO_URL} branch ${REPO_BRANCH_NAME} into ${REPO_DIR_PATH}"
    cd /;
    git clone ${REPO_URL} ${REPO_DIR_PATH};
    cd ${REPO_DIR_PATH};
    git checkout ${REPO_BRANCH_NAME};
  fi
  dbg "sleeping for ${WAIT_SECONDS} seconds"
  sleep ${WAIT_SECONDS}
done
