# Android Release Signing Setup

This guide helps you set up production Android signing for release APK builds through GitHub Actions.

## Prerequisites

- Java Keytool installed (comes with JDK)
- Access to your GitHub repository settings

## Step 1: Create/Prepare Keystore File

### If you already have a keystore:
Skip to Step 2.

### If you need to create a new keystore:

```bash
keytool -genkey -v -keystore task.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias task_key
```

You'll be prompted to enter:
- Keystore password (remember this!)
- Key password (can be same as keystore)
- Your name, organization, etc.

This creates `task.keystore` file.

## Step 2: Encode Keystore to Base64

GitHub Secrets can't store binary files, so we encode it:

```bash
# macOS/Linux
base64 -i task.keystore -o task.keystore.base64

# Or use this command on any system:
base64 < task.keystore > task.keystore.base64
```

The output file contains your keystore as text.

## Step 3: Add GitHub Secrets

1. Go to GitHub repository → Settings → Secrets and Variables → Actions
2. Click "New repository secret"
3. Add these 4 secrets:

| Secret Name | Value |
|------------|-------|
| `ANDROID_KEYSTORE_FILE` | Contents of `task.keystore.base64` (entire file content) |
| `ANDROID_KEYSTORE_PASSWORD` | Your keystore password |
| `ANDROID_KEY_ALIAS` | `task_key` (or whatever you named it) |
| `ANDROID_KEY_PASSWORD` | Your key password |

**Important:** Keep these values secret! Never commit them to git.

## Step 4: Update Build Workflow

The workflow needs to be updated to use the keystore. Here's an example addition to `build-apk.yml`:

```yaml
- name: Setup Android Signing
  if: github.event_name == 'push' && startsWith(github.ref, 'refs/tags/')
  env:
    KEYSTORE_FILE: ${{ secrets.ANDROID_KEYSTORE_FILE }}
    KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
    KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
    KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
  run: |
    # Decode and create keystore
    echo "$KEYSTORE_FILE" | base64 -d > android/app/task.keystore
    
    # Create signing config
    cat > android/key.properties << EOF
    storeFile=task.keystore
    storePassword=$KEYSTORE_PASSWORD
    keyAlias=$KEY_ALIAS
    keyPassword=$KEY_PASSWORD
    EOF
```

## Step 5: Update Android Build Configuration

Update `android/app/build.gradle.kts`:

```kotlin
android {
    // ... existing config ...
    
    signingConfigs {
        create("release") {
            storeFile = file("task.keystore")
            storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
            keyAlias = System.getenv("KEY_ALIAS") ?: ""
            keyPassword = System.getenv("KEY_PASSWORD") ?: ""
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

## Step 6: Test Locally (Optional)

```bash
# Set environment variables
export KEYSTORE_PASSWORD="your_password"
export KEY_ALIAS="task_key"
export KEY_PASSWORD="your_key_password"

# Build signed APK
flutter build apk --release
```

## Security Best Practices

✅ **DO:**
- Use strong passwords (20+ characters)
- Store keystore file in secure location
- Use GitHub Secrets for passwords
- Rotate passwords periodically
- Keep backup of keystore file

❌ **DON'T:**
- Commit keystore to git repository
- Share passwords via email/chat
- Use weak passwords
- Store plain passwords in code
- Reuse keystore between different apps

## Troubleshooting

**"Invalid keystore format"**
- Ensure you encoded the keystore correctly with base64
- Check file isn't corrupted

**"Wrong password"**
- Verify secret values match keystore credentials
- Check for extra spaces in GitHub Secrets

**"Key alias not found"**
- Confirm the alias matches: `keytool -list -v -keystore task.keystore`

**APK not signed**
- Ensure secrets are properly created
- Check workflow has access to secrets
- Re-run workflow after adding secrets

## Viewing Certificate Info

```bash
keytool -list -v -keystore task.keystore -alias task_key
```

## Rotating Keystore (Advanced)

If you need to create a new keystore:

1. Create new keystore with different password
2. Update GitHub Secrets with new values
3. Keep old keystore as backup
4. Apps will need to be un/reinstalled

## References

- [Android Signing Documentation](https://developer.android.com/studio/publish/app-signing)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions)
- [Keytool Reference](https://docs.oracle.com/en/java/javase/11/tools/keytool.html)

