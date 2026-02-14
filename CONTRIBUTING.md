# Quick Start Guide for Contributors

Welcome to the Task App project! This guide helps you get started with development and contributing.

## 🚀 Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/BawiCeu16/task.git
cd task
```

### 2. Install Dependencies

```bash
# Get Flutter packages
flutter pub get

# Get Android dependencies
cd android
./gradlew build
cd ..
```

### 3. Run the App

```bash
flutter run
```

## 📋 Development Workflow

### Create a Feature Branch

```bash
# Always create a new branch for features/fixes
git checkout -b feature/your-feature-name
```

### Make Changes

```bash
# Edit files as needed
# Commit regularly
git commit -m "type: description"
```

**Commit types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `style:` - Code style (formatting, semicolons)
- `refactor:` - Code refactoring
- `test:` - Adding/updating tests
- `chore:` - Build, dependencies, tooling

### Push and Create PR

```bash
# Push your branch
git push origin feature/your-feature-name

# Create Pull Request on GitHub
# - Go to: https://github.com/BawiCeu16/task
# - Click "Compare & pull request"
# - Add description and wait for reviews
```

### Code Review Process

1. Push your changes
2. Create Pull Request
3. GitHub Actions runs automatic checks
4. Team reviews code
5. Make requested changes if any
6. Merge when approved

## 🔍 Code Quality

Before committing, run:

```bash
# Check code formatting
dart format lib test

# Run analysis
flutter analyze

# Run tests
flutter test
```

## 📦 Release Process

### If You're a Maintainer

#### Option 1: Interactive Release Script

```bash
./release.sh
# Follow the menu:
# - Select "2" for patch version bump
# - Select "3" for minor version bump
# - Select "4" for major version bump
```

#### Option 2: Manual Git Command

```bash
# Create release tag
git tag -a v1.3.1 -m "Release v1.3.1"
git push origin v1.3.1

# APK builds automatically on GitHub
```

#### Option 3: GitHub Actions UI

1. Go to Actions tab
2. Select "Auto Version Bump and Release"
3. Click "Run workflow"
4. Select version bump type
5. Watch APK build

### Version Format

- `1` = Major version (breaking changes)
- `3` = Minor version (new features)
- `0` = Patch version (bug fixes)

Example: `1.3.0+6`
- Version: `1.3.0`
- Build: `6` (auto-incremented)

## 🔐 Security

⚠️ **Never commit:**
- API keys or secrets
- Keystore files
- Passwords or credentials
- Private configuration files

## ❓ Common Tasks

### Update Dependencies

```bash
flutter pub upgrade
```

### Clean Build

```bash
flutter clean
./gradlew clean  # Android
flutter pub get
```

### Run on Specific Device

```bash
flutter devices  # List available devices
flutter run -d device_id
```

### Build APK Locally

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

## 📚 Documentation

- `.github/WORKFLOW_GUIDE.md` - GitHub Actions workflows
- `.github/ANDROID_SIGNING.md` - Production signing setup
- `.github/BRANCH_PROTECTION.md` - Branch protection rules
- `README.md` - Project overview (if exists)
- `CONTRIBUTING.md` - Contribution guidelines (if exists)

## 🆘 Getting Help

### Check Logs

Test failures or CI issues? Check the GitHub Actions logs:
1. Go to repository Actions tab
2. Click on the failed workflow
3. Expand the step logs to see error details

### Common Issues

**"Flutter command not found"**
```bash
flutter upgrade
flutter config --android-sdk /path/to/android/sdk
```

**"Gradle sync failed"**
```bash
cd android
./gradlew clean
cd ..
flutter pub get
```

**"Dependencies resolution failed"**
```bash
flutter pub cache repair
flutter pub get
```

## 📞 Contact

- **Repository:** https://github.com/BawiCeu16/task
- **Issues:** GitHub Issues tab
- **Discussions:** GitHub Discussions (if enabled)

## ✅ Checklist Before PR

- [ ] Code follows project style
- [ ] `flutter analyze` passes
- [ ] `dart format` applied
- [ ] Tests pass locally
- [ ] PR description is clear
- [ ] No sensitive data committed
- [ ] Branch is up-to-date with main
- [ ] Commit messages are clear

## 🎉 You're Ready!

You now have everything you need to contribute to the Task App project.

Happy coding! 🚀

---

**Need to release?** → See `.github/WORKFLOW_GUIDE.md`  
**Need to set up signing?** → See `.github/ANDROID_SIGNING.md`  
**Team workflow?** → See `.github/BRANCH_PROTECTION.md`
