---
name: build
description: Run flutter build for Android and/or iOS, report errors, and attempt to fix build issues.
argument-hint: "[android|ios|apk|appbundle|ipa] or empty for both"
user-invocable: true
allowed-tools: Bash, Read, Edit, Grep, Glob, WebSearch
model: sonnet
context: inline
---

Build the Flutter app and resolve any issues.

## Steps

1. **Run analysis first**: `flutter analyze`
2. **Build based on argument**:
   - `android` or `apk`: `flutter build apk --debug`
   - `appbundle`: `flutter build appbundle`
   - `ios`: `flutter build ios --debug --no-codesign`
   - `ipa`: `flutter build ipa`
   - No argument: build both android APK and iOS (no codesign)

3. **If build fails**:
   - Read the error output carefully
   - Check common causes: missing dependencies, SDK version mismatch, manifest/plist issues
   - Fix the issue
   - Rebuild

4. **Report**: Build success/failure, output location, APK/IPA size, any warnings.

## Common Build Issues

- **Gradle version mismatch**: Check `android/gradle/wrapper/gradle-wrapper.properties`
- **Kotlin version**: Check `android/build.gradle` kotlin plugin version
- **iOS signing**: Use `--no-codesign` for debug builds
- **SDK constraints**: Check `pubspec.yaml` environment and `android/app/build.gradle` minSdkVersion
- **Missing permissions**: Check AndroidManifest.xml and Info.plist per `.claude/agents/platform-integrator.md`
