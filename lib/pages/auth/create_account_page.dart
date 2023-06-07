import 'package:etrick/app_theme.dart';
import 'package:etrick/constants.dart';
import 'package:etrick/models/app_user.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/services/auth_service.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:etrick/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isEmailError = ValueNotifier<bool>(false);
  final isPasswordError = ValueNotifier<bool>(false);
  final isFirstNameError = ValueNotifier<bool>(false);
  final isLastNameError = ValueNotifier<bool>(false);
  final isPasswordVisible = ValueNotifier<bool>(false);

  void _toggleObscurePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validateFields() {
    isEmailError.value = false;
    isPasswordError.value = false;
    isFirstNameError.value = false;
    isLastNameError.value = false;

    final auth = context.read<AuthService>();
    if (!auth.isFirstNameValid(firstNameController.text.trim())) {
      isFirstNameError.value = true;
      return false;
    }
    if (!auth.isLastNameValid(lastNameController.text.trim())) {
      isLastNameError.value = true;
      return false;
    }
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

  Future<void> _createAccount() async {
    if (!validateFields()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Будь ласка, введіть коректні дані'),
        ),
      );
      return;
    }

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    final appUserModel = context.read<AppUserModel>();
    final auth = context.read<AuthService>();
    final catalog = context.read<CatalogModel>();

    final result = await context.read<AuthService>().createAccount(
          AppUser(
            firstName: firstName,
            lastName: lastName,
            email: email,
            id: '',
          ),
          password,
        );

    bool success = result.keys.first;
    String e = result.values.first;
    if (!success && mounted) {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.getFirebaseAuthErrorMessage(e)),
        ),
      );
    }
    appUserModel.user = await FirestoreService.getUserById(auth.user!.uid);
    catalog.items = await FirestoreService.getCatalog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Створити обліковий запис'),
        centerTitle: true,
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
            ValueListenableBuilder(
              valueListenable: isFirstNameError,
              builder: (context, value, child) => TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  errorText:
                      value ? 'Будь ласка, введіть правильне ім\'я' : null,
                  labelText: 'Ім\'я',
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ValueListenableBuilder(
              valueListenable: isLastNameError,
              builder: (context, value, child) => TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  errorText:
                      value ? 'Будь ласка, введіть правильне прізвище' : null,
                  labelText: 'Прізвище',
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ValueListenableBuilder(
              valueListenable: isEmailError,
              builder: (context, value, child) => TextField(
                controller: emailController,
                decoration: InputDecoration(
                  errorText:
                      value ? 'Будь ласка, введіть правильний email' : null,
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            ValueListenableBuilder(
              valueListenable: isPasswordError,
              builder: (context, passwordError, child) =>
                  ValueListenableBuilder(
                valueListenable: isPasswordVisible,
                builder: (context, visible, child) => TextField(
                  controller: passwordController,
                  obscureText: !visible,
                  decoration: InputDecoration(
                    errorText: passwordError
                        ? 'Будь ласка, введіть пароль (мін. 8 символів)'
                        : null,
                    labelText: 'Пароль',
                    suffixIcon: IconButton(
                      onPressed: _toggleObscurePassword,
                      icon: Icon(
                        visible ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('Створити обліковий запис'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                context.go(Constants.loginLoc);
              },
              child: const Text(
                'Увійти',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
