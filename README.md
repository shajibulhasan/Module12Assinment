# Flutter Calculator

A simple, clean, and responsive calculator app built with Flutter.

## Features
- Standard calculator buttons: 0-9, +, -, ×, ÷, %, ., =, AC, backspace, ± (toggle sign)
- Accurate calculations using the `math_expressions` package
- Prevents invalid inputs (like multiple operators in a row, multiple decimals in a number)
- Dark/Light theme with a toggle in the AppBar
- Theme persistence using `shared_preferences`

## Files
- `lib/main.dart` — Main application file (this file)

## Dependencies
Add the following to your `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.15
  math_expressions: ^2.2.0
```

Then run:

```bash
flutter pub get
```

## Setup & Run
1. Create a new Flutter project (or use an existing one):
```bash
flutter create flutter_calculator
```
2. Replace the contents of `lib/main.dart` with the provided `main.dart` file.
3. Add dependencies to `pubspec.yaml` (see Dependencies section).
4. Run the app:
```bash
flutter run
```

## GitHub Submission
- Create a repository on GitHub named e.g. `flutter_calculator`.
- Add the project files (only source files — do **not** include `build/` or `.dart_tool/` folders).
- Include a `README.md` (you can use the included README content above).
- Add a `.gitignore` (use the default Flutter `.gitignore`).
- Commit and push.

## Notes & Extensions
- The app uses the `math_expressions` package for reliable evaluation and operator precedence.
- You can extend the UI by adding animations, haptic feedback, long-press for copy, or history tracking.
- If you want the app to support landscape layout better, tweak button sizes and use GridView for a responsive grid.

