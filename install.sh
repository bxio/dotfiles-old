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

  brew cleanup
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

  brew cleanup
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

###############################################################################
# General UI/UX                                                               #
###############################################################################

  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Always show scrollbars
  #defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
  # Possible values: `WhenScrolling`, `Automatic` and `Always`

  # Disable the over-the-top focus ring animation
  defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

  # Expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  # Automatically quit printer app once the print jobs complete
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable Resume system-wide
  defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

  # Disable automatic termination of inactive apps
  #defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

  # Disable the crash reporter
  #defaults write com.apple.CrashReporter DialogType -string "none"

  # Set Help Viewer windows to non-floating mode
  defaults write com.apple.helpviewer DevMode -bool true

  # Reveal IP address, hostname, OS version, etc. when clicking the clock
  # in the login window
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

  # Disable smart quotes as they’re annoying when typing code
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

###############################################################################
# SSD-specific tweaks                                                         #
##############################################################################


  # Disable hibernation (speeds up entering sleep mode)
  #sudo pmset -a hibernatemode 0

  # Remove the sleep image file to save disk space
  #sudo rm /private/var/vm/sleepimage
  # Create a zero-byte file instead…
  #sudo touch /private/var/vm/sleepimage
  # …and make sure it can’t be rewritten
  #sudo chflags uchg /private/var/vm/sleepimage

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

  # Trackpad: enable tap to click for this user and for the login screen
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Trackpad: map bottom right corner to right-click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
  defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

  # Disable “natural” (Lion-style) scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

  # Disable press-and-hold for keys in favor of key repeat
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  # Set a blazingly fast keyboard repeat rate
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10

  # Set language and text formats
  # Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
  # `Inches`, `en_GB` with `en_US`, and `true` with `false`.
  defaults write NSGlobalDomain AppleLanguages -array "en-CA" "zh-Hans"
  defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=CAD"
  defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
  defaults write NSGlobalDomain AppleMetricUnits -bool true

  # Show language menu in the top right corner of the boot screen
  sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

  # Set the timezone; see `sudo systemsetup -listtimezones` for other values
  sudo systemsetup -settimezone "America/Vancouver" > /dev/null

###############################################################################
# Screen                                                                      #
###############################################################################


  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"

  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"

  # Disable shadow in screenshots
  defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

  # Finder: disable window animations and Get Info animations
  defaults write com.apple.finder DisableAllAnimations -bool true
  # Set Desktop as the default location for new Finder windows
  # For other paths, use `PfLo` and `file:///full/path/here/`
  defaults write com.apple.finder NewWindowTarget -string "PfDe"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

  # Show icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  # Finder: show hidden files by default
  #  defaults write com.apple.finder AppleShowAllFiles -bool true

  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"



  # Enable Secure Keyboard Entry in Terminal.app
  # See: https://security.stackexchange.com/a/47786/8918
  defaults write com.apple.terminal SecureKeyboardEntry -bool true

  killall SystemUIServer

	# Prompt for re-login
	echo "Some of these settings will require you to re-login..."
fi
