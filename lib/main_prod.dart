import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/flavors/env_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.initialize(Environment.prod);
  runApp(const ProviderScope(child: App()));
}
