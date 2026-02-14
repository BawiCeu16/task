# GitHub Actions Setup Guide

This project is configured with GitHub Actions to automatically build and release APK files with version management.

## Workflows

### 1. **Build and Release APK** (`build-apk.yml`)
Builds a release APK and creates GitHub releases.

#### Triggers:
- **Push Git Tag**: When you push a tag like `v1.3.0`
- **Manual Trigger**: Via `workflow_dispatch` with optional custom version

#### How to Use:

**Option A: Using Git Tags (Recommended)**
```bash
# Update your version in pubspec.yaml first, then create a tag
git tag -a v1.4.0 -m "Release version 1.4.0"
git push origin v1.4.0
```

**Option B: Manual Trigger via GitHub**
1. Go to Actions → Build and Release APK
2. Click "Run workflow"
3. Enter version number (optional) or leave blank to use current pubspec.yaml version
4. Click "Run workflow"

#### Output:
- APK artifact available in Actions artifacts
- GitHub Release created with APK attached

---

### 2. **Auto Version Bump** (`version-bump.yml`)
Automatically bumps semantic versions and creates tags.

#### Triggers:
- Manual trigger only (`workflow_dispatch`)

#### How to Use:
1. Go to GitHub Actions → Auto Version Bump and Release
2. Click "Run workflow"
3. Select bump type: **major**, **minor**, or **patch**
4. Check "Create git tag" to automatically create and push tag
5. Click "Run workflow"

#### What it does:
- Updates `pubspec.yaml` with new version
- Commits the change
- Creates git tag (if enabled)
- Triggers build workflow automatically

**Examples:**
- `1.3.0` → patch → `1.3.1`
- `1.3.0` → minor → `1.4.0`
- `1.3.0` → major → `2.0.0`

---

### 3. **Lint and Analyze** (`lint.yml`)
Runs code analysis and tests on push/PR.

#### Triggers:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`

#### What it does:
- Runs `flutter analyze`
- Checks code formatting
- Runs unit tests
- Uploads coverage reports

---

## Workflow: Complete Release Process

### **Recommended Release Workflow:**

```bash
# 1. Make your changes
git commit -m "Feature: Add new feature"

# 2. Auto-bump version (from GitHub UI or CLI)
# This creates commit and tag automatically

# 3. APK builds and releases automatically
# Check GitHub Actions tab for progress
```

### **Manual Release Workflow:**

```bash
# 1. Update version in pubspec.yaml
# version: 1.4.0+8

# 2. Commit changes
git add pubspec.yaml
git commit -m "chore: bump version to 1.4.0"

# 3. Create tag
git tag -a v1.4.0 -m "Release v1.4.0"

# 4. Push
git push origin main
git push origin v1.4.0

# 5. GitHub Actions automatically builds and releases
```

---

## Configuration Details

### Version Format
The app uses semantic versioning: `MAJOR.MINOR.PATCH+BUILD_NUMBER`

Example: `1.3.0+6`
- `1` = Major version
- `3` = Minor version  
- `0` = Patch version
- `6` = Build number (auto-incremented by GitHub Actions)

### APK Output
Release APK is built at: `build/app/outputs/flutter-apk/app-release.apk`

### Secrets Required
- No additional secrets needed! Uses default `GITHUB_TOKEN`

---

## Checking Workflow Status

1. Go to your GitHub repository
2. Click the "Actions" tab
3. Select the workflow you want to check
4. View the logs and download artifacts

---

## Troubleshooting

**Build fails with "Flutter command not found"**
- Workflows uses `flutter@v2` action. Check internet connection.

**APK too large**
- Flutter automatically optimizes release builds
- Consider enabling R8/ProGuard in build.gradle.kts

**Tag already exists**
- Delete the tag: `git tag -d v1.4.0` and `git push origin --delete v1.4.0`
- Then try again

---

## Next Steps

1. Push this repository to GitHub
2. Try creating a test tag: `git tag v1.3.0-test && git push origin v1.3.0-test`
3. Watch Actions build and create the release
4. Download and test the APK

Happy releasing! 🚀
