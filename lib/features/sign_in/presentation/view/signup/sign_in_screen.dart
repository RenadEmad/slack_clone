import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/core/constants/app_strings.dart';
import 'package:slack_clone/core/constants/app_text_style.dart';
import 'package:slack_clone/features/sign_in/presentation/widget/text_button_word.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(Routes.splashScreen);
          },
        ),
        title: Text(
          'Sign In',
          style: AppTextTheme.lightTextTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: AppColors.splashBackgroundColor,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  AppStrings.enterEmailText,
                  style: AppTextTheme.lightTextTheme.headlineMedium!.copyWith(
                    color: AppColors.blackTextColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.optionText,
                  style: AppTextTheme.lightTextTheme.titleMedium!.copyWith(
                    color: AppColors.blackTextColor,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppStrings.emailHintText,
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.blackTextColor,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                                          context.go(Routes.checkEmail);

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffe2e2e2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Color(0xff5e5e5e),
                      fontFamily: 'SignikaNegative',
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Color(0xffcacaca), thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'OR',
                          style: AppTextTheme.lightTextTheme.titleMedium!
                              .copyWith(color: const Color(0xff7c7c7c)),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color(0xffcacaca), thickness: 1),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Color(0xffbebebe)),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.google,
                        color: AppColors.blackTextColor,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Google',
                        style: TextStyle(
                          color: AppColors.blackTextColor,
                          fontFamily: 'SignikaNegative',
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    TextWithButton(
                      text: 'Signed in on a computer? ',
                      buttonText: 'Continue with a QR code',
                    ),
                    SizedBox(height: 12),
                    TextWithButton(
                      text: 'Having trouble? ',
                      buttonText: 'Enter a workspace URL',
                    ),
                    SizedBox(height: 12),
                    TextWithButton(
                      text: 'Looking for GovSlack? ',
                      buttonText: 'Sign in',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
