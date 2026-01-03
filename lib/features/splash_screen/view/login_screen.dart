import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slack_clone/core/constants/app_colors.dart';
import 'package:slack_clone/features/homeScreen/presentation/view/home_screen_view.dart';
import 'package:slack_clone/features/sign_in/presentation/widget/custom_text_field.dart';
import 'package:slack_clone/features/sign_in/presentation/widget/text_button_word.dart';
import 'package:slack_clone/sharedConfig/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        final profile = await supabase
            .from('profiles')
            .select()
            .eq('user_id', user.id)
            .single();

        final username = profile['username'] ?? '';

        await supabase
            .from('profiles')
            .update({'is_online': true})
            .eq('user_id', user.id);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Welcome, $username!')));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreenView()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go(Routes.splashScreen);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('Login'),
        backgroundColor: AppColors.splashBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Text(
              'Welcome Back!',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),
            CustomTextField(
              label: 'Password',
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            SizedBox(height: 10),
            Align(
              alignment: AlignmentGeometry.center,
              child: TextWithButton(
                text: 'Already have an account? ',
                tfontSize: 14,
                t2fontSize: 16,
                buttonText: 'Login',
                onPressed: () {
                  context.go(Routes.login);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
