---
name: feature
description: Scaffold a complete feature module with screen, state, models, and tests following the boxing app architecture.
argument-hint: "<feature-name> [description]"
user-invocable: true
allowed-tools: Read, Grep, Glob, Write, Bash
model: opus
context: inline
---

Scaffold a complete feature module for: $ARGUMENTS

## Steps

1. **Read existing features** - Check `lib/features/` to understand the established pattern
2. **Read the theme and shared widgets** - Know what's reusable
3. **Create the feature structure**:

```
lib/features/<feature_name>/
├── <feature_name>_screen.dart      # Main screen widget
├── <feature_name>_controller.dart  # State notifier / controller
├── <feature_name>_state.dart       # Immutable state class
├── <feature_name>_provider.dart    # Riverpod providers
└── widgets/                        # Feature-specific widgets
    └── <component>.dart
```

4. **Create corresponding test structure**:

```
test/
├── unit/providers/<feature_name>_provider_test.dart
└── widget/features/<feature_name>_screen_test.dart
```

5. **Wire into navigation** - Add route to the app's router if one exists
6. **Run analysis**: `flutter analyze lib/features/<feature_name>/`

Follow all boxing UX rules if this feature has an active-workout screen.
Ensure all state is managed through providers, not local widget state.
