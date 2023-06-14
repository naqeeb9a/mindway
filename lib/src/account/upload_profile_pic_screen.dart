import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindway/src/main_screen.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadProfilePicScreen extends StatefulWidget {
  static const String routeName = '/upload-profile-pic';

  const UploadProfilePicScreen({super.key});

  @override
  State<UploadProfilePicScreen> createState() => _UploadProfilePicScreenState();
}

class _UploadProfilePicScreenState extends State<UploadProfilePicScreen> {
  String userName = "";
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("username")!;
    });
  }

  _imgFromCamera() async {
    await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);
  }

  _imgFromGallery() async {
    await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _showPicker(context);
              },
              child: Image.asset('assets/images/profile_pic.png'),
            ),
            const SizedBox(height: 30.0),
            Text('Welcome, ${userName}', style: kTitleStyle),
            const SizedBox(height: 22.0),
            Text(
              'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit',
              style: kBodyStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50.0),
            CustomAsyncBtn(
              btnTxt: 'Next',
              onPress: () {
                Get.offAllNamed(MainScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _imgFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _imgFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
