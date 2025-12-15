# Flutter Beginner Guide

Welcome to your fresh Flutter project! This guide will help you get started with the basics.

## 1. Project Structure

Your project has been simplified to the essentials:

- **`lib/`**: This is where your code lives.
  - **`main.dart`**: The entry point of your app. This single file currently contains the entire "Counter App" demo.
- **`pubspec.yaml`**: The configuration file. This is where you declare:
  - **Dependencies**: External libraries you want to use (e.g., `google_fonts`, `http`).
  - **Assets**: Images, fonts, and files you want to include in the app.
- **`analysis_options.yaml`**: Configures the "linter" (rules that help you write good code).

## 2. Basic Commands

Open the terminal in this directory to run these commands:

- **Run the app**:

  ```bash
  flutter run
  ```

  Use `R` (shift+r) in the terminal to "Hot Restart" (reset app state) or `r` to "Hot Reload" (update code changes instantly).

- **Install dependencies**:
  If you add a new package to `pubspec.yaml`, run:

  ```bash
  flutter pub get
  ```

- **Clean build**:
  If things act weird are aren't updating:
  ```bash
  flutter clean
  flutter pub get
  ```

## 3. How to Start Coding

1.  **Open `lib/main.dart`**.
2.  **Experiment**: Try changing the `seedColor` in `ThemeData` to `Colors.blue` or `Colors.red`. Save the file and see the app update instantly (Hot Reload)!
3.  **Add text**: Look for the `Text` widget in `build` and change the string.

## 4. Learning Resources

- **[Flutter Documentation](https://docs.flutter.dev/)**: The official docs are excellent.
- **[Flutter Codelabs](https://codelabs.developers.google.com/flutter)**: Step-by-step interactive tutorials.
- **[Dartpad](https://dartpad.dev/)**: Test Dart code in your browser.

Happy coding!
