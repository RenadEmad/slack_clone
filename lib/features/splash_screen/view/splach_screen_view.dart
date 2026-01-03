import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/core/constants/app_image_strings.dart';
import 'package:slack_clone/main.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _imageAnimation;

  Future<void> _redirect() async {
    log("_redirect started");

    await Future.delayed(const Duration(seconds: 2));

    try {
      final session = supabase.auth.currentSession;

      if (session == null) {
        log("No session found locally. Redirecting to SignUp");
        GoRouter.of(context).go(Routes.signup);
      } else {
        log("Session found locally. Checking if user exists on Supabase...");

        final userId = session.user.id;
        try {
          final userRecord = await supabase
              .from('profiles')
              .select()
              .eq('user_id', userId)
              .maybeSingle();

          if (userRecord == null) {
            log("User not found in Supabase. Signing out...");
            await supabase.auth.signOut();
            GoRouter.of(context).go(Routes.signup);
          } else {
            log("User exists. Redirecting to HomeScreen");
            GoRouter.of(context).go(Routes.homeScreen);
          }
        } catch (e) {
          log("Error querying user table: $e");
          await supabase.auth.signOut();
          GoRouter.of(context).go(Routes.signup);
        }
      }
    } catch (e, stackTrace) {
      log("Error checking session: $e", stackTrace: stackTrace);
      GoRouter.of(context).go(Routes.signup);
    }

    log("_redirect finished");
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _imageAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _redirect();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      log("User signed out successfully");
      GoRouter.of(context).go(Routes.signup);
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.3,
                        fontFamily: 'SignikaNegative',
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainTextColor,
                      ),
                      children: [
                        TextSpan(text: 'Picture this: a\n'),
                        TextSpan(text: ' messaging app,\n'),
                        TextSpan(
                          text: ' but built for\n',
                          style: TextStyle(color: AppColors.mainTextColor),
                        ),
                        TextSpan(
                          text: ' work.',
                          style: TextStyle(color: AppColors.mainTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SlideTransition(
                position: _imageAnimation,
                child: Image.asset(AppImageStrings.welcomeImage, width: 500),
              ),

              const SizedBox(height: 40),

              // Column(
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         log("Log in button pressed");
              //         GoRouter.of(context).go(Routes.login);
              //       },
              //       style: ElevatedButton.styleFrom(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         minimumSize: const Size(300, 50),
              //       ),
              //       child: const Text(
              //         'Log in',
              //         style: TextStyle(
              //           color: AppColors.mainTextColor,
              //           fontFamily: 'SignikaNegative',
              //           fontWeight: FontWeight.normal,
              //           fontSize: 22,
              //         ),
              //       ),
              //     ),

              //     const SizedBox(height: 12),
              //     TextButton(
              //       onPressed: () {
              //         log("Sign in button pressed");
              //         GoRouter.of(context).go(Routes.signup);
              //       },
              //       child: const Text(
              //         'Sign in',
              //         style: TextStyle(
              //           color: AppColors.mainTextColor,
              //           fontSize: 22,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),

              //     const SizedBox(height: 20),

              //     // ElevatedButton(
              //     //   onPressed: signOut,
              //     //   style: ElevatedButton.styleFrom(
              //     //     backgroundColor: Colors.redAccent,
              //     //     shape: RoundedRectangleBorder(
              //     //       borderRadius: BorderRadius.circular(8),
              //     //     ),
              //     //     minimumSize: const Size(200, 45),
              //     //   ),
              //     //   child: const Text(
              //     //     'Sign Out',
              //     //     style: TextStyle(
              //     //       color: Colors.white,
              //     //       fontSize: 18,
              //     //       fontWeight: FontWeight.w600,
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
