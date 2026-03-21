.PHONY: gen watch test analyze clean format check

## Run build_runner to generate code
gen:
	dart run build_runner build --delete-conflicting-outputs

## Run build_runner in watch mode
watch:
	dart run build_runner watch --delete-conflicting-outputs

## Run all tests with coverage
test:
	flutter test --coverage

## Run static analysis
analyze:
	dart analyze

## Check formatting
format:
	dart format --set-exit-if-changed .

## Clean build artifacts and generated files
clean:
	flutter clean
	dart run build_runner clean

## Run analyze + format check (CI-style)
check: analyze format
