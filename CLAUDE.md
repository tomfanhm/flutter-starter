# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                  # Install dependencies
make gen                         # Code generation (freezed, json_serializable, riverpod_generator)
make watch                       # Code generation in watch mode
make test                        # Run all tests with coverage
make analyze                     # Static analysis (dart analyze)
make format                      # Check formatting (dart format --set-exit-if-changed .)
make check                       # analyze + format (CI-style)
flutter test test/path/to_test.dart  # Run a single test file
flutter run --target lib/main_dev.dart  # Run dev flavor
```

After modifying any file with `part '*.g.dart'`, `part '*.freezed.dart'`, or `@riverpod` annotations, run `make gen` before testing.

## Architecture

Clean Architecture with feature-first organization. **Dependency rule**: Domain has zero framework imports; outer layers depend inward, never the reverse.

Each feature under `lib/features/<name>/` has three layers:
- **domain/** — Entities (plain Dart), repository interfaces (abstract classes), use cases (single `call()` method)
- **data/** — Repository implementations, remote data sources (use `ApiClient`), freezed request/response models
- **presentation/** — Pages, widgets, Riverpod providers (using `@riverpod` codegen)

Shared infra lives in `lib/core/` (networking, theme, storage). The `lib/app/` directory holds the root widget, GoRouter config, and environment/flavor setup.

## Key Patterns

- **Riverpod codegen**: Providers use `@riverpod` annotation with `part '*.g.dart'`. Provider dependency chain: `ApiClient → DataSource → Repository → UseCase → Notifier`. See `auth_providers.dart` for the canonical wiring pattern.
- **Freezed models**: Data-layer models use `@freezed` for immutable data classes with JSON serialization. Domain entities are plain Dart classes.
- **Environment flavors**: Three entry points (`main_dev.dart`, `main_staging.dart`, `main_prod.dart`) each call `EnvConfig.initialize()` with the appropriate `Environment` enum. `EnvConfig.instance` is a late-initialized singleton.
- **API layer**: `ApiClient` wraps Dio with auth/logging interceptors and maps `DioException` to typed `ApiException` subclasses.
- **Navigation**: GoRouter with route constants in `routes.dart`.

## Code Style

- `prefer_single_quotes`, `prefer_relative_imports`, `prefer_final_locals`
- `unawaited_futures` is treated as an **error**
- Generated files (`*.g.dart`, `*.freezed.dart`) are excluded from analysis
- Use `const` constructors wherever possible
