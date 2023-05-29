import 'package:etrick/constants.dart';
import 'package:etrick/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailTextFieldController =
      ValueNotifier<TextEditingController>(TextEditingController());

  final isEmailError = ValueNotifier<bool>(false);

  void _login() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go(Constants.loginLoc);
    }
  }

  Future<void> _resetPassword() async {
    isEmailError.value = false;
    String email = emailTextFieldController.value.text.trim().toLowerCase();

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      isEmailError.value = true;
      return;
    }

    await context.read<AuthService>().resetPassword(email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('На вашу єлектронну адресу надіслано листа з посиланням для зміни паролю.'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Login',
          onPressed: _login,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isEmailError,
                builder: (context, isEmailError, _) => TextField(
                  controller: emailTextFieldController.value,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: isEmailError ? 'Invalid email' : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
