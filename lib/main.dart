import 'package:flutter/material.dart';
import 'package:slack_clone/core/utils/powersync.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  openDatabase();
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lefjwsixkkojulrpvgdy.supabase.co',
    anonKey: 'sb_publishable_rmXp62eXCRGlfX7WXRtjvA_rEkwjXNB',
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,

      //     theme: ThemeData(
      //   textTheme: AppTextTheme.lightTextTheme,
      // ),
    );
  }
}
