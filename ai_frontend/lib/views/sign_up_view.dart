import 'package:ai_frontend/services/auth/auth_service.dart';
import 'package:ai_frontend/utils/theme.dart';
import 'package:ai_frontend/widgets/auth_gradient_button.dart';
import 'package:ai_frontend/widgets/custom_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final authService = AuthService();
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void signUp() async {
    final email = TextEditingController().text;
    final password = TextEditingController().text;
    final confirmPassword = TextEditingController().text;
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }
    try {
      if (formKey.currentState!.validate()) {
        authService.signUpWithEmailPassword(
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
    _confirmPasswordController.dispose();
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
                "Sign Up.",
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
                height: 15,
              ),
              CustomField(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                isObscure: true,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradientButton(
                buttonText: 'Sign Up',
                onTap: () => signUp(),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  text: 'Already have an account?',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: ' Sign In',
                      style: TextStyle(
                        color: AppColors.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacementNamed(
                              context, '/signin'); // Change route as needed
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
