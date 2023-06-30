# Alpha Project

## Gen

```dart
flutter packages pub run build_runner build --delete-conflicting-outputs

flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart -O lib/gen
```

### Build release

`flutter build apk --split-per-abi`
