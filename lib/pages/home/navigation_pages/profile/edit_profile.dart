import 'package:etrick/models/app_user.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firsNameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  ValueNotifier

  @override
  Widget build(BuildContext context) {
    var userModel = context.watch<AppUserModel>();
    var firestoreService = FirestoreService();

  }
}
