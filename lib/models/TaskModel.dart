import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class TaskModel implements Jsonable {
  String? id;
  String? name;
  String? description;
  String? createdBy;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? date;

  TaskModel({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.createdBy,
    this.date,
    this.updatedAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot? doc,
      {Map<String, dynamic>? mapData}) {
    Map data;
    if (doc != null) {
      data = doc.data() as Map;
    } else {
      data = mapData!;
    }
    return TaskModel(
        id: doc?.id ?? data["id"],
        name: data['name'],
        createdBy: data['createdBy'],
        updatedAt: data['updatedAt'],
        date: data['date'],
        description: data['description'],
        createdAt: data['createdAt']);
  }

  @override
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'date': date,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
