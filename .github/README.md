# GitHub Actions Configuration for Task App

This directory contains GitHub Actions workflows for automated builds and releases.

## Files

- **build-apk.yml** - Builds release APK and creates GitHub releases
- **version-bump.yml** - Auto-bumps semantic versions  
- **lint.yml** - Runs code analysis and tests

## Quick Start

1. **First release:**
   ```bash
   git tag -a v1.3.0 -m "Release v1.3.0"
   git push origin v1.3.0
   ```

2. **Subsequent releases (recommended):**
   - Go to Actions → Auto Version Bump and Release
   - Select bump type and click "Run workflow"
   - APK automatically builds and releases

## Full Documentation

See [WORKFLOW_GUIDE.md](./WORKFLOW_GUIDE.md) for complete guide.
