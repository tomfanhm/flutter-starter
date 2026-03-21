import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'flavors/env_config.dart';
import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: EnvConfig.instance.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: EnvConfig.instance.isDev,
    );
  }
}
