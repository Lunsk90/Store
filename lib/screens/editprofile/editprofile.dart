// ignore_for_file: library_private_types_in_public_api, avoid_init_to_null

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final ImageProvider<Object> avatarImage;
  final String email;

  const EditProfileScreen({
    Key? key,
    required this.avatarImage,
    required this.email,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late File? _imageFile = null;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _getImage,
              child: CircleAvatar(
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : widget.avatarImage,
                radius: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
             'User: ${widget.email}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
