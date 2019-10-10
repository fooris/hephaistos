#!/bin/bash

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                        update and install necessities                ##"
echo "##                                                                      ##"
echo "##########################################################################"

yes | sudo apt update
yes | sudo apt install git wget curl htop make cmake tree

# c/cpp
yes | sudo apt install gcc clang

# golang
version="1.13.1"
while true; do
	read -p "Installing Golang Version ${version} y/N?" yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) read -p "please enter alternate version to install x.x.x (0 to skip)\n" version; break;;
		* ) echo "Please enter y or n";;
	esac
done
wget "https://dl.google.com/go/go${version}.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go${version}.linux-amd64.tar.gz"

echo "IMPORTANT: Please check your zshrc for this line:"
echo "\"export PATH=$PATH:/usr/local/go/bin\". Add or remove it depending on whether you installed golang!"
echo "THIS HAS NOT BEEN AUTOMATED YET\n"

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                        install google-chrome                         ##"
echo "##                                                                      ##"
echo "##########################################################################"

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
yes | sudo apt install ./google-chrome*.deb
rm -f ./google-chrome*.deb

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                        set kde theme breeze-dark                     ##"
echo "##                                                                      ##"
echo "##########################################################################"

lookandfeeltool -a 'org.kde.breezedark.desktop'

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                        zsh & oh-my-zsh                               ##"
echo "##                                                                      ##"
echo "##########################################################################"

yes | sudo apt install zsh
chsh -s $(which zsh)

curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sh install.sh
rm -f ./install.sh
cp zshrc_template ~/.zshrc

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                        tlp (power management for laptops)             ##"
echo "##                                                                      ##"
echo "##########################################################################"

yes | sudo add-apt-repository ppa:linrunner/tlp
yes | sudo apt update
yes | sudo apt-get install tlp tlp-rdw tp-smapi-dkms acpi-call-dkms

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                        telegram                                      ##"
echo "##                                                                      ##"
echo "##########################################################################"

tar -xJvf tsetup*.tar.xz
rm -f tsetup*.tar.xz
sudo mv Telegram /opt/telegram
sudo ln -sf /opt/telegram/Telegram /usr/bin/telegram
/usr/bin/telegram &

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                        vimrc, vundle, YouCompleteMe                  ##"
echo "##                                                                      ##"
echo "##########################################################################"

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp vimrc_template ~/.vimrc
vim +PluginInstall +qall

yes | sudo apt install build-essential python3-dev

cd ~/.vim/bundle/YouCompleteMe

python3 install.py --clang-completer --clangd-completer --go-completer --java-completer
cd -

echo "TODO: read user-guide on YouCompleteMe and setup accordingly\n"

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                             jetbrains                                ##"
echo "##                                                                      ##"
echo "##########################################################################"

## Toolbox

function getLatestUrl() {
USER_AGENT=('User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36')

URL=$(curl 'https://data.services.jetbrains.com//products/releases?code=TBA&latest=true&type=release' -H 'Origin: https://www.jetbrains.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.8' -H "${USER_AGENT[@]}" -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.jetbrains.com/toolbox/download/' -H 'Connection: keep-alive' -H 'DNT: 1' --compressed | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
echo $URL
}
getLatestUrl

FILE=$(basename ${URL})
DEST=$PWD/$FILE

wget -cO  ${DEST} ${URL} --read-timeout=5 --tries=0
DIR="/opt/jetbrains-toolbox"
if mkdir ${DIR}; then
    tar -xzf ${DEST} -C ${DIR} --strip-components=1
fi

chmod -R +rwx ${DIR}
touch ${DIR}/jetbrains-toolbox.sh
echo "#!/bin/bash" >> $DIR/jetbrains-toolbox.sh
echo "$DIR/jetbrains-toolbox" >> $DIR/jetbrains-toolbox.sh

ln -s ${DIR}/jetbrains-toolbox.sh /usr/local/bin/jetbrains-toolbox
chmod -R +rwx /usr/local/bin/jetbrains-toolbox
echo ""
rm ${DEST}
echo  -e "\e[32mDone.\e[39m"

# IDEs

echo "Please install clion/intellij/goland/... through toolbox"

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                       keyboard shortcuts                             ##"
echo "##                                                                      ##"
echo "##########################################################################"

echo "Please configure keyboard shortcuts manually"

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                       map capslock to esc                            ##"
echo "##                                                                      ##"
echo "##########################################################################"

echo "Please configure capslock esc mapping manually"

echo "##########################################################################"
echo "##                                                                      ##"
echo "##                    lenovo X1 fix audio keys                          ##"
echo "##                                                                      ##"
echo "##########################################################################"

echo "if this is a thinkpad x1 carbon gen 7:"
echo "Add the following to /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common"
echo "above [Element PCM]:"
echo "[Element Master]\nswitch = mute\nvolume = ignore"


# echo "##########################################################################"
# echo "##                                                                      ##"
# echo "##                    lenovo X1 fix audio keys                          ##"
# echo "##                                                                      ##"
# echo "##########################################################################"
