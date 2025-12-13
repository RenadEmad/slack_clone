import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/core/constants/app_image_strings.dart';
import 'package:slack_clone/core/constants/app_text_style.dart';
import 'package:slack_clone/features/sign_in/presentation/widget/text_button_word.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email sent',
          style: AppTextTheme.lightTextTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(Routes.signup);
          },
        ),
      ),
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.3,
                      fontFamily: 'SignikaNegative',
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(
                        text: 'We’ve sent you a confirmation email.\n',
                        style: TextStyle(
                          color: AppColors.mainTextColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Please check your inbox to continue.\n',
                        style: TextStyle(
                          color: AppColors.mainTextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Image.asset(AppImageStrings.checkEmail),
            const SizedBox(height: 40),

            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.go(Routes.checkNotification);
                  },

                  // openEmailApp,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(300, 50),
                  ),
                  child: const Text(
                    'Open email app',
                    style: TextStyle(
                      color: AppColors.mainTextColor,
                      fontFamily: 'SignikaNegative',
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                TextWithButton(
                  text: 'Having trouble?',
                  buttonText: ' Enter a workspace URL',
                  tfontSize: 16,
                  t2fontSize: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openEmailApp() async {
  final uri = Uri(scheme: 'mailto');

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
