import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/firestore_helper.dart/firestore_helper.dart';
import '../data/model/user_model.dart';
import '../widget/costom_textfield.dart';
import '../widget/costome_elevated_button.dart';

class EditPage extends StatefulWidget {
  UserModel? user;
  EditPage({this.user});
  // final Function? addTx;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // List<Transaction>? transaction;
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  DateTime? _selectedDate;

  // void submitData() {
  //   if (amountController.text.isEmpty) {
  //     return;
  //   }
  //   final enteredTitle = titleController.text.toString();
  //   final enteredAmount = double.parse(amountController.text.toString());
  //   // final selectDate = DateTime.now();
  //   if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
  //     return;
  //   }
  //   // widget.addTx!(enteredTitle, enteredAmount, _selectedDate);
  //   Navigator.of(context).pop();
  // }

  @override
  void initState() {
    titleController = TextEditingController(text: widget.user!.title);
    priceController = TextEditingController(text: widget.user!.price);
    _selectedDate;
    super.initState();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  CostomTextField(
                    controllers: titleController,
                    title: 'tile',
                  ),
                  CostomTextField(
                    controllers: priceController,
                    title: 'price',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                          onPressed: _presentDatePicker,
                          child: const Text('Choose Data')),
                    ],
                  ),
                  CostomElevatedButton(
                    onTap: () {
                      onSubmitDataFirestore();
                    },
                    title: 'update Data',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmitDataFirestore() {
    if (formKey.currentState!.validate()) {
      final enteredTitle = titleController.text.toString();
      final enteredAmount = double.parse(priceController.text.toString());
      if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
        debugPrint('text field is missing');
      } else {
        debugPrint('add data');
        FirestoreHelper.update(UserModel(
                id: widget.user!.id,
                title: titleController.text,
                price: priceController.text,
                date: _selectedDate))
            .then((value) {
          Navigator.of(context).pop();
        });
      }
    }
  }
}
