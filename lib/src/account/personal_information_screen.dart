import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindway/src/auth/auth_controller.dart';
import 'package:mindway/src/auth/user.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/firebase_collections.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformation extends StatefulWidget {
  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  UserDataModel? userModel;
  late SharedPreferences sharedPreferences;
  var _textFieldController = TextEditingController();
  var _textFieldController2 = TextEditingController();

  @override
  void initState() {
    userModel = AuthController().getSavedUser();
    if (userModel != null) {
      setState(() {
        userModel;
      });
    }
    initSharedPreferences();
    super.initState();
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  const Text(
                    "Account Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 30,
                  )
                ]),
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 10,
          ),
          InfoBox(
            name: "Prefered Name",
            value: userModel!.name,
            manageText: "Edit",
            onClick: () {
              setState(() {
                _textFieldController.text = userModel!.name;
              });
              debugPrint("Name");
              _displayTextInputDialog(context, "name");
            },
            singleButton: false,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          InfoBox(
            name: "Email Address",
            value: userModel!.email,
            manageText: "Edit",
            onClick: () {
              setState(() {
                _textFieldController.text = userModel!.email;
              });
              debugPrint("Email");
              _displayTextInputDialog(context, "email");
            },
            singleButton: false,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          InfoBox(
            name: "Password [8 *Charecters]",
            value: "********",
            manageText: "Edit",
            onClick: () {
              setState(() {
                _textFieldController.text = "";
              });
              debugPrint("Password");
              _displayTextInputDialog(context, "password");
            },
            singleButton: false,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          InfoBox(
            name: "Linked Google Account",
            value: userModel!.gmail == null || userModel!.gmail!.isEmpty
                ? "Not Linked"
                : userModel!.email,
            manageText: userModel!.gmail == null || userModel!.gmail!.isEmpty
                ? "Link"
                : "Manage",
            onClick: () {
              debugPrint("Google");
              linkOrUnlinkGoogleAccount(
                  userModel!.gmail == null || userModel!.gmail!.isEmpty
                      ? true
                      : false);
            },
            singleButton: false,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          InfoBox(
            name: "Delete Account",
            value: "",
            manageText: "Delete",
            onClick: () {
              debugPrint("Delete");
              _displayTextInputDialog(context, "delete");
            },
            singleButton: true,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            color: Colors.grey,
          ),
        ],
      )),
    ));
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, String type) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: type == "delete"
              ? const Text('Delete account')
              : Text('Change your $type'),
          content: DataForm(type),
          actions: <Widget>[
            InkWell(
              child: const Text('Cancel'),
              onTap: () {
                Navigator.pop(context, "");
              },
            ),
            InkWell(
              child: const Text('Ok'),
              onTap: () {
                if (type == "name") {
                  changeName(_textFieldController.text);
                } else if (type == "email") {
                  changeEmail(
                      _textFieldController.text, _textFieldController2.text);
                } else if (type == "password") {
                  changePassword(
                      _textFieldController.text, _textFieldController2.text);
                } else if (type == "delete") {
                  deleteAccount(_textFieldController.text);
                }
                print(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Widget DataForm(String type) {
    if (type == "password") {
      return SizedBox(
        height: 100,
        child: Column(
          children: [
            TextField(
                obscureText: true,
                controller: _textFieldController,
                decoration:
                    InputDecoration(hintText: "Type your current $type")),
            TextField(
                obscureText: true,
                controller: _textFieldController2,
                decoration: InputDecoration(hintText: "Type your new $type")),
          ],
        ),
      );
    }

    if (type == "name") {
      return TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Type your $type"),
      );
    }
    if (type == "delete") {
      return TextField(
        obscureText: true,
        controller: _textFieldController,
        decoration: const InputDecoration(
            hintText: "Type your password to Delete Account"),
      );
    }

    return SizedBox(
      height: 100,
      child: Column(
        children: [
          TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Type your new $type")),
          TextField(
              obscureText: true,
              controller: _textFieldController2,
              decoration: const InputDecoration(
                  hintText: "Current password to Confirm")),
        ],
      ),
    );
  }

  Future<void> deleteAccount(password) async {
    if (password.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Enter password");
      return;
    }
    if (password.toString().length < 8) {
      Fluttertoast.showToast(msg: "Password must be 8 characters");
      return;
    }

    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid!;
    UserCredential userCredential;
    try {
      userCredential = await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: user.email!, password: password));
    } catch (e) {
      e.printError();
      Fluttertoast.showToast(msg: "Incorrect  password");
      return;
    }

    userCredential.user!.delete().then((value) => {
          userCollection.doc(userId).delete().then((value) {
            AuthController().logOutUser(context);
          })
        });
  }

  void changeName(text) {
    if (text.toString().isEmpty) {
      return;
    }
    userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"name": text}).then((value) async {
      setState(() {
        userModel!.name = text;
      });
      try {
        String data = json.encode(userModel);
        await sharedPreferences.setString('user', data);
      } catch (e) {
        e.printError();
      }

      Navigator.pop(context);
    });
  }

  void changeEmail(email, password) async {
    if (email.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Enter email");
      return;
    }
    if (password.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Enter password");
      return;
    }
    if (password.toString().length < 8) {
      Fluttertoast.showToast(msg: "Password must be 8 characters");
      return;
    }
    //if(password.toString().)

    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid!;
    UserCredential userCredential;
    try {
      userCredential = await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: user.email!, password: password));
    } catch (e) {
      e.printError();
      Fluttertoast.showToast(msg: "Incorrect email or password");
      return;
    }

    userCredential.user!.updateEmail(email).then((value) {
      userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"email": email}).then((value) async {
        setState(() {
          userModel!.email = email;
        });
        try {
          String data = json.encode(userModel);
          await sharedPreferences.setString('user', data);
        } catch (e) {
          e.printError();
        }
        Navigator.pop(context);
      });
    });
  }

  void changePassword(currentPass, newPass) async {
    if (currentPass.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Enter password");
      return;
    }
    if (newPass.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Enter Confirm password");
      return;
    }
    if (currentPass.toString().length < 8) {
      Fluttertoast.showToast(msg: "Password must be 8 characters");
      return;
    }
    if (newPass.toString().length < 8) {
      Fluttertoast.showToast(msg: "Password must be 8 characters");
      return;
    }

    //if(password.toString().)

    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid!;
    UserCredential userCredential;
    try {
      userCredential = await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
              email: user.email!, password: currentPass));
    } catch (e) {
      e.printError();
      Fluttertoast.showToast(msg: "Incorrect password");
      return;
    }
    userCredential.user!.updatePassword(newPass).then((value) {
      Navigator.pop(context);
    });
  }

  void linkOrUnlinkGoogleAccount(notLink) async {
    String gmail = "";
    if (notLink) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User? user = FirebaseAuth.instance.currentUser;
      try {
        await user!.linkWithCredential(credential).then((value) {
          gmail = value.user!.email!;
          userCollection
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"gmail": gmail}).then((value) async {
            setState(() {
              userModel!.gmail = gmail;
            });
            try {
              String data = json.encode(userModel);
              await sharedPreferences.setString('user', data);
            } catch (e) {
              e.printError();
            }
          });
        });
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.disconnect().then((value) {
        userCollection
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"gmail": ""}).then((value) async {
          setState(() {
            userModel!.gmail = "";
          });
          try {
            String data = json.encode(userModel);
            await sharedPreferences.setString('user', data);
          } catch (e) {
            e.printError();
          }
        });
      });
    }
  }
}

class InfoBox extends StatefulWidget {
  final name;
  final value;
  final onClick;
  final singleButton;
  final manageText;

  const InfoBox({
    super.key,
    required this.name,
    required this.value,
    required this.onClick,
    required this.singleButton,
    required this.manageText,
  });

  @override
  State<InfoBox> createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Visibility(
                  visible: !widget.singleButton,
                  child: Text(
                    widget.value,
                    style: const TextStyle(fontSize: 16),
                  )),
            ],
          ),
          InkWell(
            onTap: widget.onClick,
            child: Text(widget.manageText,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue)),
          ),
        ]),
      ),
    );
  }
}
