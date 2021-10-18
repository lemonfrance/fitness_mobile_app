# Wearable Intelligence

Part 4 Project. Created by Tessa Gush and Jaimee McLaghlan

For help please contatct us at:
* tessagush@gmail.com - frontend
* - backend

## Download and install Flutter SDK
  * From https://flutter.dev/docs/get-started/install

## Download and install Android Studio
  * Download and run the installer from https://developer.android.com/studio, accepting the defaults 
  * Start Android Studio, select "Standard" setup when prompted. This will download and install the emulator and platform tools
  * Follow the instructions in the Flutter docs about getting an emulator installed
  * Run `flutter doctor` again, and see that flutter detects the Android toolchain and Android Studio. It should be complaining about a missing JDK
    * If flutter doctor complains about Android Studio not being installed, run `flutter config --android-studio-dir="C:\Program Files\Android\Android Studio"` and try again

## Get the code
  * If you haven't done so already, generate an SSH key to use for cloning the code from GitHub
    * Open a git bash prompt
    * Double check you don't already have a `.ssh/id_*` file - if you do, skip to adding your key to GitHub
    * In a git bash prompt, run `ssh-keygen -t ecdsa`
    * Accept the default path for storing the key (usually `/c/Users/<username>/.ssh/id_ecdsa`)
    * Enter a passphrase for the key
    * Run `cat ~/.ssh/id_ecdsa.pub` (this should output a line starting with `ecdsa-sha2-nistp256` - if it doesn't, you've got the wrong file. Double check you got the file that ends with `.pub`)
    * In GitHub, go to Account settings, SSH and GPG keys, select New SSH key, and paste the output from the previous command. Click Add key
  * Clone this repo through Android Studio

## Run the code on an android device
* https://developer.android.com/training/basics/firstapp/running-app
* If you are unable to get the device connected, check that the cable you are using is a debugging one.

## Run the code on an apple device
* https://medium.com/front-end-weekly/how-to-test-your-flutter-ios-app-on-your-ios-device-75924bfd75a8

Limitations to running on an apple device include:
* needed an apple phone
* Needing an apple computer or laptop
* Having xcode on your computer
