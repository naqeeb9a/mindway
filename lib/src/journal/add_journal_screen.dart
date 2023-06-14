import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mindway/src/journal/controller/journal_controller.dart';
import 'package:mindway/utils/constants.dart';
import 'package:mindway/utils/display_toast_message.dart';
import 'package:mindway/widgets/custom_async_btn.dart';
import 'package:mindway/widgets/custom_input_field.dart';
import 'package:mindway/widgets/custom_input_validators.dart';

class AddJournalScreen extends StatefulWidget {
  static const String routeName = '/add-journal';

  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _journalCtrl = Get.find<JournalController>();

  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();

  final DateTime now = DateTime.now();

  String? formattedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Journal'),
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Back',
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Add Another',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                _buildDateAndEmotionsView(),
                const Divider(),
                CustomInputField(
                  hintText: 'Title',
                  controller: _titleController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    return CustomInputValidators.validateString(value);
                  },
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Write something here...',
                    hintStyle: const TextStyle(fontSize: 14.0),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomAsyncBtn(
                  btnTxt: 'Save',
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (_journalCtrl.selectedFeelVal != null) {
                        await _journalCtrl.handleAddJournal(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          date: '$formattedDate',
                        );
                        Get.back();
                      } else {
                        displayToastMessage('Please select an feeling');
                      }
                    }
                  },
                ),
                const SizedBox(height: 12.0),
                // GetBuilder<JournalController>(
                //   builder: (_) => _journalCtrl.isLoading
                //       ? const LoadingWidget()
                //       : Column(
                //           children: [
                //             ..._journalCtrl.journalList
                //                 .map(
                //                   (e) => Card(
                //                     child: ListTile(
                //                       leading: CacheImgWidget('$sessionImgURL/${e.emoji}'),
                //                       title: Text(e.title.capitalizeFirst ?? ''),
                //                       subtitle: Text(e.description),
                //                     ),
                //                   ),
                //                 )
                //                 .toList()
                //           ],
                //         ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndEmotionsView() {
    formattedDate = DateFormat.yMMMEd().format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: Wrap(
            spacing: 8.0,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text('$formattedDate'),
              ),
              const Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ),
        GetBuilder<JournalController>(
          builder: (_) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: kPrimaryColor),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Map>(
                value: _journalCtrl.selectedFeelVal ?? _journalCtrl.feelList.first,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                elevation: 16,
                // style: const TextStyle(color: Colors.deepPurple),
                // underline: Container(
                //   height: 2,
                //   color: Colors.deepPurpleAccent,
                // ),
                onChanged: (Map? value) {
                  _journalCtrl.doSelect(value!);
                },
                items: _journalCtrl.feelList.map<DropdownMenuItem<Map>>((Map value) {
                  return DropdownMenuItem<Map>(
                    value: value,
                    child: Wrap(
                      spacing: 8.0,
                      children: [
                        // Image.asset(value['icon'], width: 25.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(value['name']),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
