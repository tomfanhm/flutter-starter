import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/flavors/env_config.dart';

/// Default entry point — runs the dev flavor.
/// For explicit flavors use: main_dev.dart, main_staging.dart, main_prod.dart.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.initialize(Environment.dev);
  runApp(const ProviderScope(child: App()));
}
