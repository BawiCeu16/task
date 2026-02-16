# Task Manager

> A **minimalist, open-source** task management application built with Flutter. Experience powerful functionality with a clean, intuitive design and rich customization options.

## Features

- **Minimalist Design** - Clean, distraction-free interface focused on productivity
- **Rich Customizations** - Personalize your experience with extensive theme and layout options
- **Open Source** - Community-driven development with full transparency
- **Cross-Platform** - Available on iOS, Android, Web, macOS, Windows, and Linux
- **AI-Powered Development** - Built using VS Code with AI Agent assistance for intelligent development
- **Antigravity Integration** - Advanced floating UI elements and dynamic interactions

## Code Structure & Maintenance

This project follows clean code principles with:
- **Reusable Components** - Centralized widget library in `lib/widgets/common/`
- **Constants System** - All styling constants in `lib/constants/app_constants.dart`
- **Best Practices** - Organized patterns for dialogs, forms, and UI components

📖 **For Development**: See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for architecture details and component usage.
📋 **For Cleanup Details**: See [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md) and [REFACTORING.md](REFACTORING.md)

Key reusable components:
- `ColorPicker` - Color selection for any dialog
- `IconPicker` - Icon selection for folders/categories
- `ConfirmationDialog` - Standardized delete/confirm dialogs
- `BottomSheetAction` - Consistent action menus
- Dialog utilities for common patterns

## Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK
- Android Studio or Xcode for mobile development

### Installation

1. Clone the repository:
```bash
git clone https://github.com/bawiceu/task.git
cd task
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Development

This project leverages:
- **VS Code and Antigravity** - Modern development environment with AI Agent extensions
- **Flutter** - Cross-platform framework
- **Provider** - State management

### Build for Different Platforms

```bash
# iOS
flutter build ios

# Android
flutter build apk

# Web
flutter build web

# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux
```

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── pages/                 # App pages and screens
├── provider/              # State management
├── utils/                 # Utility functions and helpers
└── widgets/               # Reusable UI components
```

## Customization

The app supports:
- **Theme Customization** - Dark/Light modes and custom color schemes
- **Layout Options** - Choose from various navigation patterns
- **Category Management** - Organize tasks with custom categories
- **Folder Structures** - Create nested task hierarchies

## Release Notes

Check out our [GitHub Release Tags](https://github.com/bawiceu/task/releases) for version history and updates.

## Stay Updated

- **Telegram Channel** - [Join our community](https://t.me/bawiceu) for announcements and discussions
- **Email** - Contact us at **bawiceu142@gmail.com** for support and feedback

## License

This project is open source and available under the MIT License. See the LICENSE file for details.

## Contributing

We welcome contributions! Please feel free to submit issues and pull requests.

## About

Developed with using Flutter, VS Code, and AI-assisted development tools (Antigravity framework included).

**Built by:** bawiceu  
**Email:** [bawiceu1428@gmail.com](mailto:bawiceu142@gmail.com)  
**Telegram:** [Community Channel](https://t.me/bawiceuapp)  
**GitHub:** [Release Tags](https://github.com/BawiCeu16/task/releases)

---

*For more information and future updates, check our Telegram channel and GitHub releases.*
