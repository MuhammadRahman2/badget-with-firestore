import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/model/user_model.dart';
import '../data/firestore_helper.dart/firestore_helper.dart';
import 'costom_textfield.dart';
import 'costome_elevated_button.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction({this.addTx});
  final Function? addTx;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // List<Transaction>? transaction;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
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
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                    controllers: amountController,
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
                    title: 'Add Data',
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
      final enteredAmount = double.parse(amountController.text.toString());
      if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
        debugPrint('text field is missing');
      } else {
        debugPrint('add data');
        FirestoreHelper.create(UserModel(
                title: titleController.text,
                price: amountController.text,
                date: _selectedDate))
            .then((value) {
          Navigator.of(context).pop();
        });
      }
    }
  }
}
