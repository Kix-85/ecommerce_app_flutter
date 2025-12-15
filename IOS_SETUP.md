# iOS Setup Guide

## Issue: "Application not configured for iOS"

This error occurs when the iOS platform is not properly configured. Follow these steps:

## Step 1: Install CocoaPods

CocoaPods is required for iOS development. Choose one of these methods:

### Option A: Install via Homebrew (Recommended)
```bash
brew install cocoapods
```

### Option B: Install via RubyGems (requires sudo)
```bash
sudo gem install cocoapods
```

### Option C: Install without sudo (using user directory)
```bash
gem install --user-install cocoapods
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"  # Add to ~/.zshrc
```

## Step 2: Install iOS Dependencies

After installing CocoaPods, run:

```bash
cd ios
pod install
cd ..
```

## Step 3: Verify iOS Configuration

Run Flutter doctor to check iOS setup:

```bash
flutter doctor -v
```

You should see:
- ✓ Xcode - develop for iOS and macOS
- ✓ CocoaPods installed

## Step 4: Build for iOS

Once CocoaPods is installed and dependencies are set up:

```bash
flutter build ios
```

Or to run on a simulator:

```bash
flutter run -d ios
```

## Common Issues

### If you get "CocoaPods not installed":
1. Make sure CocoaPods is in your PATH
2. Try: `which pod` to verify installation
3. Restart your terminal after installation

### If you get permission errors:
- Use Homebrew method (Option A) instead of sudo
- Or install to user directory (Option C)

### If pod install fails:
```bash
cd ios
pod deintegrate
pod install
```

## Next Steps

After completing these steps, your iOS app should be properly configured. The project has been recreated with the iOS platform, so you should be able to build and run.

