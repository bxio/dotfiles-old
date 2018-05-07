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
  #sudo rm /private/var/vm/sleepimage# Create a zero-byte file instead…
  #sudo touch /private/var/vm/sleepimage# …and make sure it can’t be rewritten
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
# Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Enable spring loading for directories
  defaults write NSGlobalDomain com.apple.springing.enabled -bool true
# Remove the spring loading delay for directories
  defaults write NSGlobalDomain com.apple.springing.delay -float 0
# Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Disable disk image verification
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# Automatically open a new Finder window when a volume is mounted
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Disable the warning before emptying the Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Enable AirDrop over Ethernet and on unsupported Macs running Lion
  defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
# Show the ~/Library folder
  chflags nohidden ~/Library
# Remove Dropbox’s green checkmark icons in Finder
# file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
# [ -e "${file}" ] && mv -f "${file}" "${file}.bak"

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################
# Enable highlight hover effect for the grid view of a stack (Dock)
  defaults write com.apple.dock mouse-over-hilite-stack -bool true
# Set the icon size of Dock items to 36 pixels
  defaults write com.apple.dock tilesize -int 36
# Change minimize/maximize window effect
  defaults write com.apple.dock mineffect -string "scale"

  # Minimize windows into their application’s icon
  defaults write com.apple.dock minimize-to-application -bool true

  # Enable spring loading for all Dock items
  defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

  # Show indicator lights for open applications in the Dock
  defaults write com.apple.dock show-process-indicators -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true

  # Don’t animate opening applications from the Dock
  defaults write com.apple.dock launchanim -bool false

  # Speed up Mission Control animations
  defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
  # (i.e. use the old Exposé behavior instead)
  defaults write com.apple.dock expose-group-by-app -bool false

  # Disable Dashboard
  defaults write com.apple.dashboard mcx-disabled -bool true

  # Don’t show Dashboard as a Space
  defaults write com.apple.dock dashboard-in-overlay -bool true

  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false

  # Remove the auto-hiding Dock delay
  defaults write com.apple.dock autohide-delay -float 0
  # Remove the animation when hiding/showing the Dock
  defaults write com.apple.dock autohide-time-modifier -float 0

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

  # Make Dock icons of hidden applications translucent
  defaults write com.apple.dock showhidden -bool true

  # Disable the Launchpad gesture (pinch with thumb and three fingers)
  #defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

  # Add iOS & Watch Simulator to Launchpad
  # sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
  # sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

  # Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
  # Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

  # Hot corners
  # Possible values:
  #  0: no-op
  #  2: Mission Control
  #  3: Show application windows
  #  4: Desktop
  #  5: Start screen saver
  #  6: Disable screen saver
  #  7: Dashboard
  # 10: Put display to sleep
  # 11: Launchpad
  # 12: Notification Center
  # Top left screen corner → Mission Control
  defaults write com.apple.dock wvous-tl-corner -int 2
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # Top right screen corner → Desktop
  defaults write com.apple.dock wvous-tr-corner -int 4
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # Bottom left screen corner → Start screen saver
  defaults write com.apple.dock wvous-bl-corner -int 5
  defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

  # Privacy: don’t send search queries to Apple
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  # Press Tab to highlight each item on a web page
  defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

  # Show the full URL in the address bar (note: this still hides the scheme)
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

  # Set Safari’s home page to `about:blank` for faster loading
  defaults write com.apple.Safari HomePage -string "about:blank"

  # Prevent Safari from opening ‘safe’ files automatically after downloading
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

  # Allow hitting the Backspace key to go to the previous page in history
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

  # Hide Safari’s bookmarks bar by default
  defaults write com.apple.Safari ShowFavoritesBar -bool false

  # Hide Safari’s sidebar in Top Sites
  defaults write com.apple.Safari ShowSidebarInTopSites -bool false

  # Disable Safari’s thumbnail cache for History and Top Sites
  defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

  # Enable Safari’s debug menu
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  # Make Safari’s search banners default to Contains instead of Starts With
  defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

  # Remove useless icons from Safari’s bookmarks bar
  defaults write com.apple.Safari ProxiesInBookmarksBar "()"

  # Enable the Develop menu and the Web Inspector in Safari
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

  # Add a context menu item for showing the Web Inspector in web views
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  # Enable continuous spellchecking
  defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
  # Disable auto-correct
  defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

  # Disable AutoFill
  defaults write com.apple.Safari AutoFillFromAddressBook -bool false
  defaults write com.apple.Safari AutoFillPasswords -bool false
  defaults write com.apple.Safari AutoFillCreditCardData -bool false
  defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

  # Warn about fraudulent websites
  defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

  # Enable “Do Not Track”
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

  # Update extensions automatically
  defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

  # Disable send and reply animations in Mail.app
  defaults write com.apple.mail DisableReplyAnimations -bool true
  defaults write com.apple.mail DisableSendAnimations -bool true

  # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

  # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
  defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

  # Display emails in threaded mode, sorted by date (oldest at the top)
  defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
  defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
  defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

  # Disable inline attachments (just show the icons)
  defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

  # Disable automatic spell checking
  defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

###############################################################################
# Spotlight                                                                   #
###############################################################################

  # Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600         /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
  # Disable Spotlight indexing for any volume that gets mounted and has not yet
  # been indexed before.
  # Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
  sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
  # Change indexing order and disable some search results
  # Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
  # 	MENU_DEFINITION
  # 	MENU_CONVERSION
  # 	MENU_EXPRESSION
  # 	MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
  # 	MENU_WEBSEARCH             (send search queries to Apple)
  # 	MENU_OTHER
  defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 1;"name" = "FONTS";}' \
    '{"enabled" = 0;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
  # Load new settings before rebuilding the index
  killall mds > /dev/null 2>&1
  # Make sure indexing is enabled for the main volume
  sudo mdutil -i on / > /dev/null
  # Rebuild the index from scratch
  sudo mdutil -E / > /dev/null

# Reset Launchpad, but keep the desktop wallpaper intact
  find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

  # Enable Secure Keyboard Entry in Terminal.app
  # See: https://security.stackexchange.com/a/47786/8918
  defaults write com.apple.terminal SecureKeyboardEntry -bool true

  killall SystemUIServer

	# Prompt for re-login
	echo "Some of these settings will require you to re-login..."
fi
