import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagein/pages/main/photo_edit_page.dart';

import '../../constants/colors.dart';

import '../../widget/general_widgets.dart/logo_widget.dart';
import '../../widget/general_widgets.dart/modified_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker picker = ImagePicker();
  XFile? _imageFile;

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> takeAPicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Icon(
            Icons.abc,
            color: scaffoldBackgroundColor,
          ),
          actions: const [
            Icon(
              Icons.abc_outlined,
              color: scaffoldBackgroundColor,
            )
          ],
          title: const LogoWidget()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              CustomizedElevatedButton(
                label: "Take a picture",
                icon: Icons.add_a_photo,
                onPressed: () async {
                  await takeAPicture();
                },
              ),
              const SizedBox(height: 15),
              CustomizedElevatedButton(
                label: "Choose from gallery",
                icon: Icons.photo_album_outlined,
                onPressed: () async {
                  await pickImageFromGallery();
                },
              ),
              const SizedBox(height: 15),
              _imageFile != null
                  ? GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _imageFile = null;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(_imageFile!.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera,
                              color: primaryColor.withOpacity(0.4),
                            ),
                            const SizedBox(width: 10),
                            ModifiedText(
                              text: "There is no image yet",
                              color: darkColor.withOpacity(0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 15),
              _imageFile != null
                  ? CustomizedElevatedButton(
                      label: "Start Editing",
                      icon: Icons.edit,
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhotoEditPage(
                            image: _imageFile!,
                          ),
                        ));
                      },
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width - 30,
                      decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.edit,
                              color: primaryColor.withOpacity(0.4),
                            ),
                            const SizedBox(width: 10),
                            ModifiedText(
                              text: "Start Editing",
                              color: darkColor.withOpacity(0.4),
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomizedElevatedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final void Function() onPressed;
  const CustomizedElevatedButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color = secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: 15),
              ModifiedText(
                text: label,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ));
  }
}
