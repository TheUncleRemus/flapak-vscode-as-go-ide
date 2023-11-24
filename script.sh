# you can take the preferred archive url. In this case has been used the go1.21.4.linux-amd64 version
wget https://go.dev/dl/go1.21.4.linux-amd64.tar.gz

# create directory and change directory
mkdir -p "$HOME"/.golang && cd "$HOME"/.golang/

# unpack directory
tar -C . -xzf /home/tcatalano@LUISA.LOC/Scaricati/go1.21.4.linux-amd64.tar.gz

# export the go paths
echo "export PATH=\"$PATH:$HOME/.golang/go/bin\"" >> $HOME/.profile
echo "export GOROOT=\"$HOME/.golang/go\""

# check the go command
go env
if [ $? == 0 ] ; then
  echo 'go in installed and configured'
else
  echo 'go is not configured'
  exit;
fi

# flatpak configuration
flatpak override --filesystem=$HOME/.golang
flatpak override --env=GOROOT=$HOME/.golang/go