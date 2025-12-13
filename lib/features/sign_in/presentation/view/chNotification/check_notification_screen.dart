import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/core/constants/app_image_strings.dart';
import 'package:slack_clone/core/constants/app_text_style.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';

class CheckNotificationScreen extends StatelessWidget {
  const CheckNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.splashBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(Routes.checkEmail);
          },
        ),
      ),
      backgroundColor: AppColors.splashBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppImageStrings.notification, height: 200),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 34,
                        height: 1.3,
                        fontFamily: 'SignikaNegative',
                        fontWeight: FontWeight.w700,
                        color: AppColors.mainTextColor,
                      ),
                      children: [
                        const TextSpan(text: "Don't miss a beat!\n"),

                        TextSpan(
                          text:
                              "Set up push notifications so you know when you've been messaged or mentioned.\n",
                          style: AppTextTheme.lightTextTheme.headlineSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

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
                      'Turn on notification',
                      style: TextStyle(
                        color: AppColors.mainTextColor,
                        fontFamily: 'SignikaNegative',
                        fontWeight: FontWeight.normal,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
