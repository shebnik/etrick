import 'package:etrick/app_theme.dart';
import 'package:etrick/constants.dart';
import 'package:etrick/models/app_user.dart';
import 'package:etrick/services/auth_service.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:etrick/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final isEmailError = ValueNotifier<bool>(false);
  final isPasswordError = ValueNotifier<bool>(false);
  final isPasswordVisible = ValueNotifier<bool>(false);

  void _toggleObscurePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validateFields() {
    isEmailError.value = false;
    isPasswordError.value = false;

    final auth = context.read<AuthService>();
    if (!auth.isEmailValid(emailController.text.trim())) {
      isEmailError.value = true;
      return false;
    }
    if (!auth.isPasswordValid(passwordController.text)) {
      isPasswordError.value = true;
      return false;
    }
    return true;
  }

  Future<void> _login() async {
    if (!validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Будь ласка, введіть коректні дані'),
        ),
      );
      return;
    }

    final String email = emailController.text.trim();
    final String password = passwordController.text;
    final result = await context.read<AuthService>().login(email, password);

    bool success = result.keys.first;
    String e = result.values.first;
    if (!success && mounted) {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(context.read<AuthService>().getFirebaseAuthErrorMessage(e)),
        ),
      );
    }
    if (!mounted) return;
    context.read<AppUserModel>().user = await FirestoreService.getUserById(
        context.read<AuthService>().user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Увійти'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 40,
          ),
          children: [
            const LogoWidget(),
            const SizedBox(height: 32.0),
            ValueListenableBuilder<bool>(
              valueListenable: isEmailError,
              builder: (context, value, child) {
                return TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Електронна пошта',
                    errorText: value ? 'Некоректна пошта' : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            ValueListenableBuilder<bool>(
              valueListenable: isPasswordError,
              builder: (context, error, child) {
                return ValueListenableBuilder(
                  valueListenable: isPasswordVisible,
                  builder: (context, visible, child) => TextField(
                    controller: passwordController,
                    obscureText: !visible,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      errorText: error ? 'Некоректний пароль' : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                            visible ? Icons.visibility : Icons.visibility_off),
                        onPressed: _toggleObscurePassword,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Увійти'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(Constants.createAccountLoc);
                }
              },
              child: const Text(
                'Зареєструватися',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Align(
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                  children: [
                    const TextSpan(
                      text: 'Забули пароль?',
                    ),
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.only(left: 4),
                      ),
                    ),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            context.go(Constants.resetPasswordLoc);
                          },
                          child: Text(
                            'Відновити тут',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
