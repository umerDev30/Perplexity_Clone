import 'package:ai_frontend/services/auth/auth_service.dart';
import 'package:ai_frontend/utils/theme.dart';
import 'package:ai_frontend/widgets/auth_gradient_button.dart';
import 'package:ai_frontend/widgets/custom_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final authService = AuthService();
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      if (formKey.currentState!.validate()) {
        authService.signInWithEmailPassword(
          email,
          password,
        );
        Navigator.pushReplacementNamed(context, '/home');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomField(
                controller: _emailController,
                hintText: "Email",
              ),
              const SizedBox(
                height: 15,
              ),
              CustomField(
                controller: _passwordController,
                hintText: "Password",
                isObscure: true,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradientButton(
                buttonText: 'Login',
                onTap: () => login(),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: ' Sign Up',
                      style: TextStyle(
                        color: AppColors.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
