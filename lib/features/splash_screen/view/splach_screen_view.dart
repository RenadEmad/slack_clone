import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/core/constants/app_image_strings.dart';
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackgroundColor,
      body: SafeArea(
        child: 
        Center(
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

              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(300, 50),
                    ),
                    child: const Text(
                      'Go on..',
                      style: TextStyle(
                        color: AppColors.mainTextColor,
                        fontFamily: 'SignikaNegative',
                        fontWeight: FontWeight.normal,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go(Routes.signup);
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: AppColors.mainTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
