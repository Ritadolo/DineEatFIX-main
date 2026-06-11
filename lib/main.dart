import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app_theme.dart';
import 'screens/registration_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://znlvldmdplbltjsepqga.supabase.co',
    anonKey: 'sb_publishable_DGlXpkicWjij5i836CebeA_J_RS_GXk',
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const DineAndGoApp(),
    ),
  );
}

class DineAndGoApp extends StatelessWidget {
  const DineAndGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DineAndGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const RegistrationScreen(),
    );
  }
}
