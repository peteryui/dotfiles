---
paths:
  - "**/*.dart"
  - "**/pubspec.yaml"
---
# Flutter

- Every command is `fvm flutter …` or `fvm dart …`; the bare binaries are not on
  the agent's PATH.
- Gates: `fvm dart format --set-exit-if-changed .` · `fvm flutter analyze` ·
  `fvm flutter test`, plus `fvm dart run build_runner build
  --delete-conflicting-outputs` first when `pubspec.yaml` lists `build_runner`.
- Simulator or device runs, code signing and store uploads are Peter's: prepare
  the change, then hand him the command.
