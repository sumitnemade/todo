import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class UserModel implements Jsonable {
  String? id;
  String? email;
  String? displayName;
  String? photoUrl;
  String? status;
  String? fcmToken;
  Timestamp? createdAt;

  UserModel({
    this.id,
    this.email,
    this.displayName,
    this.status,
    this.createdAt,
    this.fcmToken,
    this.photoUrl,
  });

  factory UserModel.fromFirestore(DocumentSnapshot? doc,
      {Map<String, dynamic>? mapData}) {
    Map data;
    if (doc != null) {
      data = doc.data() as Map;
    } else {
      data = mapData!;
    }
    return UserModel(
        id: doc?.id ?? data["id"],
        email: data['email'],
        status: data['status'],
        photoUrl: data['photo_url'],
        fcmToken: data['fcmToken'],
        createdAt: data['createdAt'],
        displayName: data['display_name']);
  }

  @override
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> data = {
      'id': id,
      'email': email,
      'display_name': displayName,
      'fcmToken': fcmToken,
      'photo_url': photoUrl,
      'createdAt': createdAt,
      'status': status,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
