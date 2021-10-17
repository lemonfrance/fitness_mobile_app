### wearable_intelligence

Part 4 Project. Created by Tessa Gush and Jaimee McLaghlan

## Download and install Flutter SDK
  * Based on the instructions from https://flutter.dev/docs/get-started/install/windows
  * Clone flutter somewhere convenient
    * I use a Projects folder within my Home, ie `C:\Users\<my name>\Projects\flutter`)
    * Start a git bash prompt (right-click, select "Git Bash Here", and run `git clone https://github.com/flutter/flutter.git -b stable`
  * Follow the instructions for updating your Path
  * Start a new Windows command prompt, and run:
    * `where flutter dart` to verify that you've updated your Path correctly
    * `flutter doctor` and let flutter download the Dart SDK and other tools it needs. At this point it should complain about a missing Android SDK - this is OK, because next we will:

## Download and install Android Studio
  * Download and run the installer from https://developer.android.com/studio, accepting the defaults 
  * Start Android Studio, select "Standard" setup when prompted. This will download and install the emulator and platform tools
  * Follow the instructions in the Flutter docs about getting an emulator installed
  * Run `flutter doctor` again, and see that flutter detects the Android toolchain and Android Studio. It should be complaining about a missing JDK
    * If flutter doctor complains about Android Studio not being installed, run `flutter config --android-studio-dir="C:\Program Files\Android\Android Studio"` and try again

## Grab the code
  * If you haven't done so already, generate an SSH key to use for cloning the code from GitHub
    * Open a git bash prompt
    * Double check you don't already have a `.ssh/id_*` file - if you do, skip to adding your key to GitHub
    * In a git bash prompt, run `ssh-keygen -t ecdsa`
    * Accept the default path for storing the key (usually `/c/Users/<username>/.ssh/id_ecdsa`)
    * Enter a passphrase for the key
    * Run `cat ~/.ssh/id_ecdsa.pub` (this should output a line starting with `ecdsa-sha2-nistp256` - if it doesn't, you've got the wrong file. Double check you got the file that ends with `.pub`)
    * In GitHub, go to Account settings, SSH and GPG keys, select New SSH key, and paste the output from the previous command. Click Add key
  * Clone this repo somewhere
    * I used the Projects directory as above.
