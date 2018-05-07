 #!/bin/bash
if [ -d "~/.dotfiles" ]
then
	# Clone dotfiles
	git clone git@github.com:bxio/dotfiles.git ~/.dotfiles
else
	echo "~/.dotfiles directory already exists! Make sure to git pull to ensure it is up to date"
fi

# Homebrew process
read -p "Do you wish to install homebrew? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then

	# Install homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	# Ensure homebrew is up to date
	brew update
	brew upgrade

fi

read -p "Do you wish to install homebrew defaults? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# Install homebrew libs & tools
	brew install binwalk exiftool fcrackzip ffmpeg gcc gdb gettext git-lfs gist gnupg hashcat imagemagick nmap nvm pinentry pipenv python3 radare2 readline sqlite sqlmap thefuck volatility wpscan
fi


read -p "Do you wish to install casks? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# Tap brew repos
	brew tap caskroom/cask
	brew tap buo/cask-upgrade

	# Install some default apps
	brew cask install 1password alfred bartender caffeine calibre cloudapp discord docker dropbox droplr fantastical filezilla firefox franz go2shell handbrake istat-menus iterm2 java jdownloader keybase mactex meld metasploit microsoft-office notion open-in-code rocket runescape skype slack speedcrunch steam teamviewer telegram telegram-desktop the-unarchiver torbrowser transmission vlc visual-studio-code vmware-fusion windscribe wireshark
fi

if [ -d "/Applications/iTerm.app/" ]
then
	read -p "Do you wish to setup iTerm configs? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		# Backup old iterm configs
		mkdir -p ~/dotfiles_old/.iterm2
		cp -r ~/.iterm2 ~/dotfiles_old/.iterm2

		if [ -d ~/.iterm2 ]
		then
			rm -r ~/.iterm2
		fi

		# Configure iTerm 2 preferences
		ln -s  ~/.dotfiles/.iterm2 ~
		defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm2"
		defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
	fi
else
	echo "Default terminal program does not appear to be iTerm!"
fi


read -p "Do you wish to install Oh-My-ZSH? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# Install some default software
	curl -L http://install.ohmyz.sh | sh
fi

read -p "Do you wish to link your dotfiles? (old ones will be backed up to ~/dotfiles_old) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	mkdir -p ~/dotfiles_old

	#backup current dotfiles
	cp -L ~/.bash_profile ~/dotfiles_old/.bash_profile
	cp -L ~/.bashrc ~/dotfiles_old/.bashrc
	cp -L ~/.gitconfig ~/dotfiles_old/.gitconfig
	cp -L ~/.gitignore_global ~/dotfiles_old/.gitignore_global
	cp -L ~/.zshrc ~/dotfiles_old/.zshrc

	rm ~/.bash_profile
	rm ~/.bashrc
	rm ~/.gitconfig
	rm ~/.gitignore_global
	rm ~/.zshrc

	#regenerate gitconfig
	if [ -f '.gitconfig' ]
	then
		rm .gitconfig
	fi

	cp .gitconfig_template .gitconfig

	read -p "What name would you like in your gitconfig: " -e -r
	sed -i '' "s/#NAME#/$REPLY/g" '.gitconfig'

	read -p "What email would you like in your gitconfig: " -e -r
	sed -i '' "s/#EMAIL#/$REPLY/g" '.gitconfig'

	read -p "What signing key would you like in your gitconfig: " -e -r
	sed -i '' "s/#SIGNINGKEY#/$REPLY/g" '.gitconfig'

	read -p "What is your github username: " -e -r
	sed -i '' "s/#USERNAME#/$REPLY/g" '.gitconfig'

	# Link dotfiles
	ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
	ln -s ~/.dotfiles/.bashrc ~/.bashrc
	ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
	ln -s ~/.dotfiles/.gitignore_global ~/.gitignore_global
	ln -s ~/.dotfiles/.zshrc ~/.zshrc

	gist --login

fi

read -p "Do you wish to setup nodejs? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	nvm install node
	nvm alias default node
	npm install npm-check-updates -g
	npm install pm2 -g
fi

read -p "Do you wish to copy iTunes AppleScripts? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
cp -R iTunesScripts ~/Library/iTunes/Scripts

fi

read -p "Do you wish to copy Wallpapers? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
cp -R ./wp ~/Pictures

fi

read -p "Do you wish to setup Apple defaults? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then

	# Ask for the administrator password upfront -- some of these commands require admin
	sudo -v

	# Require password immediately after sleep or screen saver begins
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	# Disable press-and-hold for keys in favor of key repeat
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

	# Set a blazingly fast keyboard repeat rate
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# Disable the “Are you sure you want to open this application?” dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	# Disable “natural” (Lion-style) scrolling
	defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

	#Set default location for screenshots
	defaults write com.apple.screencapture location ~/Downloads/

	# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
	defaults write com.apple.screencapture type -string "png"

	# Enable Secure Keyboard Entry in Terminal.app
	# See: https://security.stackexchange.com/a/47786/8918
	defaults write com.apple.terminal SecureKeyboardEntry -bool true

	killall SystemUIServer

	# Prompt for re-login
	echo "Some of these settings will require you to re-login..."
fi
