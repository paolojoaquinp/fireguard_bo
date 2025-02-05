# fireguard_bo

A new Flutter project.

# Mapbox Setup in Flutter

## Tokens and Security

To use Mapbox in the application you'll need two types of tokens:
- Public token for using Mapbox services in the app 
- Secret token for downloading native SDKs during development

## Token Configuration

### Android

1. In `android/gradle.properties.template`:
```properties
MAPBOX_DOWNLOADS_TOKEN=${MAPBOX_DOWNLOADS_TOKEN}

In android/app/src/main/res/values/strings.xml:

xmlCopy<string name="mapbox_access_token">your_public_token</string>
iOS
```

Create configuration files:

```bash
Copyios/Flutter/Debug.xcconfig
ios/Flutter/Release.xcconfig
```
Add to both files:

```properties
MAPBOX_ACCESS_TOKEN=your_token_here
```
Ignored Files
Make sure your .gitignore includes:

```gitignore
# iOS
ios/Flutter/Debug.xcconfig
ios/Flutter/Release.xcconfig

# Android
gradle.local.properties
gradle.properties
!gradle.properties.template
```

Getting Started

* Clone the repository
* Copy **gradle.properties.template** to **gradle.properties**

Add your tokens in the configuration files, Run:
```bash
flutter pub get
```

And finally In ./zshrc add:
```bash
export MAPBOX_DOWNLOADS_TOKEN_IOS="public"
```
## Local Private Setup for IOS

#### For Ios
create .netrc:
```bash
# Go to home directory
cd ~

# Create .netrc file
touch .netrc

# Open .netrc file
open .netrc
```
Add this content in .netrc:
```bash
machine api.mapbox.com
login mapbox
password your_secret_token_here
```



#### Security Notes

- Never commit your tokens to version control
- Use template files as reference
- Set environment variables in your CI/CD

#### Aditional Resources
- Mapbox Documentation
- Flutter Location Package
- Flutter dotenv
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
