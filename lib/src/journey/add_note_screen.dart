import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mindway/src/new/models/note_model.dart';
import 'package:mindway/utils/app_theme.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:mindway/utils/firebase_collections.dart';

import '../../utils/helper.dart';

class AddNoteScreen extends StatelessWidget {
  String dbDate;
  String notes;

  AddNoteScreen({super.key, required this.dbDate, required this.notes});

  @override
  Widget build(BuildContext context) {
    String text = notes;
    TextEditingController notesController = TextEditingController();
    notesController.text = notes;
    return Scaffold(
        body: Container(
      color: Color(0xffEFEFEF),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 250,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            child: TextField(
              controller: notesController,
              maxLines: 20,
              decoration: const InputDecoration(
                  enabled: true,
                  hintText: 'Add Note',
                  contentPadding: const EdgeInsets.all(15),
                  border: InputBorder.none),
              onChanged: (value) {
                text = value;
                // do something
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: CustomAsyncBtn(
                  btnColor: Colors.grey,
                  btnTxt: 'Cancel',
                  onPress: () async {
                    hapticFeedbackMedium();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: CustomAsyncBtn(
                  btnTxt: 'Done',
                  onPress: () async {
                    hapticFeedbackMedium();
                    String date = dbDate.replaceAll("-", "_");
                    NoteModel noteModel = NoteModel(date: dbDate, notes: text);
                    Map<String, dynamic> data = NoteModel.getMap(noteModel);
                    notesCollection
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection(date)
                        .doc("note")
                        .set(data)
                        .then((value) {
                      Navigator.pop(context, text);
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ]),
    ));
  }
}
