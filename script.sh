# you can take the preferred archive url. In this case has been used the go1.21.4.linux-amd64 version
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz

# create directory and change directory
mkdir -p "$HOME"/.golang && cd "$HOME"/.golang/

# unpack directory
tar -C . -xzf /home/tcatalano@LUISA.LOC/Scaricati/go1.21.4.linux-amd64.tar.gz

# export the go paths if it doesn't exists
go_root=$(grep -rni "#go-root" $HOME/.bashrc)
go_path=$(grep -rni "#go-path" $HOME/.bashrc)
if [ -z "$go_root" ]; then
    echo "export GOROOT=\"$HOME/.golang/go\" #go-root" >> $HOME/.bashrc
else
    echo "GOROOT var has been set before"
fi;

if [ -z "$go_path" ]; then
    echo "export PATH=\"$PATH:$HOME/.golang/go/bin\" #go-path" >> $HOME/.bashrc
else
    echo "PATH with go/bin var has been set before"
fi;

# reload current bash profile
source $HOME/.bashrc

# check the go command
go envs
if [ $? == 0 ] ; then
  echo 'go is installed and configured'
else
  echo 'go is not configured'
  # remove custom golang root path
  rm -Rf $HOME/.golang/
  # remove the go-path and go-root env variables from $HOME/.bashrc
  sed '/#go-path/d' $HOME/.bashrc
  sed '#go-root/d' $HOME/.bashrc
  exit;
fi

# flatpak configuration
flatpak override --filesystem=$HOME/.golang
flatpak override --env=GOROOT=$HOME/.golang/go