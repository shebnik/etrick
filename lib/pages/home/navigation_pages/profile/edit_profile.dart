import 'package:etrick/models/app_user.dart';
import 'package:etrick/pages/home/home_app_bar.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:etrick/widgets/app_snackbar.dart';
import 'package:etrick/widgets/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController firsNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ValueNotifier<bool> isFirstNameError = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSurnameError = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPhoneError = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<AppUserModel>();
    var user = userModel.user!;
    firsNameController.text = user.firstName;
    surnameController.text = user.lastName;
    phoneController.text = user.phoneNumber?.replaceAll('+380', '') ?? '';

    return Scaffold(
      appBar: const HomeAppBar(title: 'Налаштування профілю'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: isFirstNameError,
            builder: (context, value, child) => TextFormField(
              controller: firsNameController,
              decoration: InputDecoration(
                labelText: 'Ім\'я',
                errorText: value ? 'Введіть ім\'я' : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: isSurnameError,
            builder: (context, value, child) => TextFormField(
              controller: surnameController,
              decoration: InputDecoration(
                labelText: 'Прізвище',
                errorText: value ? 'Введіть прізвище' : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<bool>(
            valueListenable: isPhoneError,
            builder: (context, value, child) => PhoneInput(
              phoneNumberController: phoneController,
              error: value,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              isFirstNameError.value = false;
              isSurnameError.value = false;
              isPhoneError.value = false;
              if (firsNameController.text.isEmpty) {
                isFirstNameError.value = true;
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnakbar(text: 'Введіть ім\'я').snackbar,
                );
                return;
              }
              if (surnameController.text.isEmpty) {
                isSurnameError.value = true;
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnakbar(text: 'Введіть прізвище').snackbar,
                );
                return;
              }
              if (phoneController.text.isEmpty) {
                isPhoneError.value = true;
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnakbar(text: 'Введіть номер телефону').snackbar,
                );
                return;
              }
              userModel.user = user.copyWith(
                firstName: firsNameController.text,
                lastName: surnameController.text,
                phoneNumber: "+380${phoneController.text}",
              );
              await FirestoreService.updateUser(userModel.user!);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                AppSnakbar(text: 'Профіль оновлено').snackbar,
              );
              Navigator.pop(context);
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }
}
