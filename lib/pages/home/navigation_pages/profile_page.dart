import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<AppUserModel>().user!;
    return ListView(
      children: [
        ListTile(
          title: const Text('Ім\'я'),
          subtitle: Text(user.firstName),
        ),
        ListTile(
          title: const Text('Прізвище'),
          subtitle: Text(user.lastName),
        ),
        ListTile(
          title: const Text('Електронна адреса'),
          subtitle: Text(user.email),
        ),
        ListTile(
          title: const Text('Номер телефону'),
          subtitle: Text(user.phoneNumber ?? 'Не вказано'),
        ),
      ],
    );
  }
}