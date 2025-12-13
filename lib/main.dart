import 'package:flutter/material.dart';
// import 'package:slack_clone/core/constants/app_text_style.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}



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
