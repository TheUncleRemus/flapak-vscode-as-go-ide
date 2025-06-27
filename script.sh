#!/bin/sh

# input args
# \
    go_version=$1
    arch=$2
# /

# set the base path fo go installation
# \
    USERNAME=$(echo $(logname))
    USER_HOME="/home/${USERNAME}"
    GOBASEPATH="${USER_HOME}/.golang"
    WGET_PATH="${GOBASEPATH}"
# /

# you can take the preferred archive url. In this case has been used the go1.21.4.linux-amd64 version
# \
    wget -O "${WGET_PATH}" "https://go.dev/dl/${go_version}.${arch}.tar.gz"
    chmod 777 "${WGET_PATH}/${go_version}.${arch}.tar.gz"
# /

# remove old go version
# \
    rm -Rf "${GOBASEPATH}/go/"
# /

# create directory and change directory
# \
    mkdir -p "${GOBASEPATH}"
# /

# unpack directory
# \
    tar -C . -xzf "${WGET_PATH}/${go_version}.${arch}.tar.gz" && mv go "${GOBASEPATH}"
# /

# export the golang paths if they doesn't exists
# \
    go_root=$(grep -rni "#go-root" ${USER_HOME}/.bashrc)
    go_path=$(grep -rni "#go-path" ${USER_HOME}/.bashrc)
# /

# goroot
# \
    if [ -z "$go_root" ]; then
        echo "export GOROOT=\"${GOBASEPATH}/go\" #go-root" >> ${USER_HOME}/.bashrc
    else
        echo "GOROOT var '${GOBASEPATH}/go' has been set before"
    fi;
    # gopath
    if [ -z "$go_path" ]; then
        echo "export GOPATH=\"${GOBASEPATH}/go/bin\" #go-path" >> ${USER_HOME}/.bashrc
    else
        echo "GOPATH var eq '${GOBASEPATH}/go/bin' has been set before"
    fi;
# /

# export new PATH env var
# \
    runuser -l "${USERNAME}" -c "export PATH=\"${PATH}:${GOBASEPATH}/go/bin\""
# /

# reload current bash profile
# \
    source ${USER_HOME}/.bashrc
# /

# symlink for /usr/bin/go
# \
    ln -s "${GOBASEPATH}"/go/bin/go /usr/bin/go
# /

# check the golang command.Useful to below guard
# \
    runuser -l "${USERNAME}" -c "go env"
# /

# go env
# \
    if [ $? == 0 ] ; then
      echo 'go is installed and configured'
      runuser -l "${USERNAME}" -c "go env -w GOCACHE=\"${USER_HOME}/.cache/go-build\""
      runuser -l "${USERNAME}" -c "go env -w GOENV=\"${USER_HOME}/.config/go/env\""
      runuser -l "${USERNAME]" -c "go env -w GOBIN=\"${GOROOT}/bin\""
      runuser -l "${USERNAME}" -c "go env -w GOPROXY=\"direct\""
      runuser -l "${USERNAME}" -c "go env -w GO111MODULE=\"on\""
      runuser -l "${USERNAME}" -c "go env -w GOTOOLCHAIN=\"${go_version}\""
      runuser -l "${USERNAME}" -c "go env -w GOSUMDB=\"sum.golang.org\""
    else
      echo 'go is not configured'
      # remove custom golang root path
      rm -Rf "${GOBASEPATH}"
      # remove the go-path and go-root env variables from ${HOME}/.bashrc
      sed '/#go-path/d' ${USER_HOME}/.bashrc
      sed '#go-root/d' ${USER_HOME}/.bashrc
      exit;
    fi
# /

# flatpak configuration. Probably you can receive an error after run this command but is not
# \
    flatpak override --filesystem="${GOBASEPATH}"
    flatpak override --env=GOROOT="${GOBASEPATH}/go"
# /

# set the to current logged user the ownership of gopath
# \
    chown -R "${USERNAME} ${GOBASEPATH}"
# /
