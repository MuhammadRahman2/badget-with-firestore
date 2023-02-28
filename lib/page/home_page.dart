import 'package:budget_firestore/page/edit_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../data/firestore_helper.dart/firestore_helper.dart';
import '../data/model/user_model.dart';
import '../widget/costom_textfield.dart';
import '../widget/costome_elevated_button.dart';
import '../widget/new_transation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('person Expensive'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              startAddNewTransaction(context);
            });
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              height: 0,
              width: double.infinity,
            ),
            StreamBuilder<List<UserModel>>(
                stream: FirestoreHelper.read(),
                // FirebaseFirestore.instance.collection('users').snapshots(),
                // AsyncSnapshot<QuerySnapshot>
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("some error occured"),
                    );
                  }
                  if (snapshot.hasData) {
                    final userData = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            final singleUser = snapshot.data![index];
                            // final Timestamp timestamp = singleUser['date'];
                            // final DateTime dateTime = timestamp.toDate();
                            return Column(
                              children: [
                                // Row(
                                //   children: [
                                //     Column(
                                //       children: [
                                // Text('$Amount')
                                //       ],
                                //     )
                                //   ],
                                // ),

                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text(
                                            '\$${singleUser.price.toString()}'),
                                      ),
                                      title: Text(singleUser.title.toString()),
                                      subtitle: Text(
                                          "Date: ${singleUser.date!.day}/${singleUser.date!.month}/${singleUser.date!.year}"),
                                      // 'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}, Time: ${dateTime.hour}:${dateTime.minute}'),
                                      trailing: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditPage(
                                                user: UserModel(
                                                    title: singleUser.title,
                                                    price: singleUser.price,
                                                    id: singleUser.id,
                                                    date: _selectedDate),
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(Icons.edit),
                                      ),
                                      onLongPress: () {
                                        deleteDialogo(context, singleUser);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ));
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(
              // addTx: addNewTransaction
              ),
        );
      },
    );
  }

  Future<dynamic> deleteDialogo(BuildContext context, UserModel singleUser) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text("are you sure you want to delete"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    FirestoreHelper.delete(singleUser).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Delete"))
            ],
          );
        });
  }
}
