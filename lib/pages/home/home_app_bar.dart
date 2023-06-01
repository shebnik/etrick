import 'package:etrick/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('eTrick'),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: TextButton(
                onPressed: () async {
                  await context.read<AuthService>().signOut();
                },
                child: const Text('Вийти'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
