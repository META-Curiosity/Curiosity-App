# curiosity_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

**Documentation to Start Running the Flutter App Locally**
Navigate to our code repository
https://github.com/META-Curiosity/Curiosity-App

Clone the repository using
```git clone https://github.com/META-Curiosity/Curiosity-App.git```

Open the repository using an IDE of your choice (VS Code, IntelliJ, Android Studio, etc.). I would suggest VS code for now for simplicity. Android Studio and IntelliJ provide better ways to navigate the codebase. You'll also have to download XCode for iOS simulations (Flutter works on all devices, when changing the codebase, we want to make sure it functions in all devices and input types).

Download flutter 2.10.0 version. Or, if already downloaded, run ```flutter downgrade 2.10.0``` to get onto the correct flutter version (this codebase is a couple of years old). If there is an error (saying flutter cannot be downgraded/found), follow:
https://stackoverflow.com/questions/66545480/flutter-downgrade-error-there-is-no-previously-recorded-version-for-channel
You'll have to cd into the directory where Flutter is downloaded, and checkout their 2.10.0 branch.
```git checkout 2.10.0``` You can find what path flutter is located on your computer with:
```flutter doctor -v```

Run ```flutter pub get``` or ```flutter pub upgrade``` as needed to download dependent packages and libraries.

Run ```flutter doctor``` This command will tell you all the needed installations and bug fixes needed to be able to run a Flutter project fully. Follow the instructions if there are any errors in the logs, such as downloading the Android SDK, iOS SDK, etc.

If cocoapods is required, either download via the link, or if you are on an Apple Chip mac, run:
```brew install cocoapods``` to download it via Homebrew.
https://stackoverflow.com/questions/64901180/how-to-run-cocoapods-on-apple-silicon-m1

Once Android Studio is downloaded, if ```flutter doctor``` still outputs an error for Android SDK, follow the instructions here: https://stackoverflow.com/questions/60475481/flutter-doctor-error-android-sdkmanager-tool-not-found-windows

Once there are no errors left for ```flutter doctor```, try to run the app in a chrome browser:
```flutter run -d chrome --web-port 8000 ```

Extra: If you are attempting to run the application via android studio code or another IDE, and an error says "flutter command not found", follow the instructions here:
https://stackoverflow.com/questions/50652071/flutter-command-not-found

There's also extensive backend documentation for each API endpoint written by the previous team in the backend-documentation.md file.

Done!
