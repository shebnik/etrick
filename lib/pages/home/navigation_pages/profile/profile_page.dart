import 'package:etrick/pages/home/navigation_pages/profile/edit_profile.dart';
import 'package:etrick/pages/home/navigation_pages/profile/my_orders.dart';
import 'package:etrick/services/auth_service.dart';
import 'package:etrick/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/app_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<AppUserModel>();
    return ListView(
      children: [
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(
              '${userModel.user?.firstName ?? 'Профіль'} ${userModel.user?.lastName ?? ''}'),
          onTap: () => Utils.showPageNoAnimation(
            context,
            const EditProfile(),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.list_alt_outlined),
          title: const Text('Мої замовлення'),
          onTap: () => Utils.showPageNoAnimation(
            context,
            const MyOrders(),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        // const ListTile(
        //   leading: Icon(Icons.favorite_outline),
        //   title: Text('Мої обрані'),
        // ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Вийти', style: TextStyle(color: Colors.red)),
          onTap: () => context.read<AuthService>().signOut(),
        ),
      ],
    );
  }
}
