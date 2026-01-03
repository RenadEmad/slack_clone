import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/core/constants/app_strings.dart';
import 'package:slack_clone/core/constants/app_text_style.dart';
import 'package:slack_clone/features/homeScreen/presentation/view/home_screen_view.dart';
import 'package:slack_clone/features/sign_in/presentation/widget/custom_text_field.dart';
import 'package:slack_clone/features/sign_in/presentation/widget/text_button_word.dart';
import 'package:slack_clone/features/splash_screen/view/splach_screen_view.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:slack_clone/main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Future<void> signUp() async {
  //   try {
  //     await supabase.auth.signUp(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //       data: {'username': usernameController.text.trim()},
  //     );

  //     if (!mounted) return;

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const HomeScreenView()),
  //     );
  //   } on AuthApiException catch (e) {
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(e.message)));
  //   }
  // }

  Future<void> signUp() async {
    try {
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user;
      if (user == null) return;

      print('Signed up user id: ${user.id}');

      await supabase.from('profiles').insert({
        'user_id': user.id,
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'is_online': true,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreenView()),
      );
    } on AuthApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
      log('Auth error: ${e.message}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      log('Other error: $e');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

              const SizedBox(height: 20),

              CustomTextField(
                label: 'Username',
                controller: usernameController,
                obscureText: false,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                label: 'Email',
                controller: emailController,
                obscureText: false,
              ),

              const SizedBox(height: 20),
              CustomTextField(
                label: 'Password',
                controller: passwordController,
                obscureText: true,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SignikaNegative',
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: AlignmentGeometry.center,
                child: TextWithButton(
                  text: 'Already have an account? ',
                  tfontSize: 16,
                  t2fontSize: 18,
                  buttonText: 'Login',
                  onPressed: () {
                    context.go(Routes.login);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xffcacaca))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('OR'),
                    ),
                    Expanded(child: Divider(color: Color(0xffcacaca))),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: Color(0xffbebebe)),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.google,
                      size: 22,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Google',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Column(
                children: [
                  const TextWithButton(
                    text: 'Signed in on a computer? ',
                    buttonText: 'Continue with a QR code',
                  ),
                  const SizedBox(height: 12),
                  const TextWithButton(
                    text: 'Having trouble? ',
                    buttonText: 'Enter a workspace URL',
                  ),
                  const SizedBox(height: 12),
                  const TextWithButton(
                    text: 'Looking for GovSlack? ',
                    buttonText: 'Sign in',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    );
  }
}
