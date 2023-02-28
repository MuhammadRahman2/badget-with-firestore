import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? title;
  final String? price;
  final DateTime? date;

  UserModel({this.title, this.price, this.id,this.date});
  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    final Timestamp timestamp = snap['date'];
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      title: snapshot['title'],
      price: snapshot['price'],
      id: snapshot['id'],
      date: snap['date'] == null? null: (snap['date'] as Timestamp).toDate(),
    );
  }



  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "id": id,
        'date': date == null ? null: Timestamp.fromDate(date!),
      };

      // updatedAt == null ? null : Timestamp.fromDate(updatedAt)
}
