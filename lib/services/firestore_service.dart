import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/TaskModel.dart';
import '../models/UserModel.dart';

abstract class Jsonable {
  Map<String, dynamic> toFirestore();

  factory Jsonable.fromFirestore(DocumentSnapshot json, Type t) {
    switch (t) {
      case UserModel:
        return UserModel.fromFirestore(json);
      case TaskModel:
        return TaskModel.fromFirestore(json);

      default:
        throw ArgumentError('Invalid JSON data');
    }
  }
}

class FirestoreService<T extends Jsonable> {
  final String collectionName;
  late FirebaseFirestore _firestore;

  FirestoreService(this.collectionName) {
    _firestore = FirebaseFirestore.instance;
    _firestore.settings = const Settings(persistenceEnabled: false);
  }

  Future<String?> addDocument(T data) async {
    if (kDebugMode) {
      print('Adding document to collection: $collectionName with id: ');
    }
    try {
      var result =
          await _firestore.collection(collectionName).add(data.toFirestore());

      return result.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateDocument(T data, String id) async {
    if (kDebugMode) {
      print('Updating document in collection: $collectionName with id: $id');
    }
    try {
      await _firestore
          .collection(collectionName)
          .doc(id)
          .update(data.toFirestore());
      if (kDebugMode) {
        print('Document updated in collection: $collectionName with id: $id');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
            'Failed to update document in collection: $collectionName with id: $id');
        print('Error: $e');
      }

      return false;
    }
  }

  Future<bool> setDocument(T data, String id) async {
    if (kDebugMode) {
      print('Updating document in collection: $collectionName with id: $id');
    }

    try {
      await _firestore
          .collection(collectionName)
          .doc(id)
          .set(data.toFirestore());
      if (kDebugMode) {
        print('Document updated in collection: $collectionName with id: $id');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
            'Failed to update document in collection: $collectionName with id: $id');
        print('Error: $e');
      }

      return false;
    }
  }

  Future<T?> get(String documentId) async {
    final documentReference =
        _firestore.collection(collectionName).doc(documentId);
    final snapshot = await documentReference.get();
    if (!snapshot.exists) {
      return null;
    }
    return _documentSnapshotToModel(snapshot) as T;
    // return snapshot.data() as T;
  }

  Future<List<T>> getWhere(List<List<dynamic>> conditions,
      {String? orderBy,
      int? limit,
      DocumentSnapshot? startAfterDocument,
      bool descending = false,
      Function(DocumentSnapshot)? lastDocfromData}) async {
    print(
        'Getting documents from collection: $collectionName with where conditions: $conditions');
    Query<Map<String, dynamic>> collectionReference;
    if (orderBy != null && limit != null && startAfterDocument != null) {
      collectionReference = _firestore
          .collection(collectionName)
          .orderBy(orderBy, descending: descending)
          .startAfterDocument(startAfterDocument)
          .limit(limit);
    } else if (orderBy != null && limit != null) {
      collectionReference = _firestore
          .collection(collectionName)
          .orderBy(orderBy, descending: descending)
          .limit(limit);
    } else if (orderBy != null && startAfterDocument != null) {
      collectionReference = _firestore
          .collection(collectionName)
          .orderBy(orderBy)
          .startAfterDocument(startAfterDocument);
    } else if (orderBy != null) {
      collectionReference =
          _firestore.collection(collectionName).orderBy(orderBy);
    } else if (limit != null) {
      collectionReference = _firestore.collection(collectionName).limit(limit);
    } else {
      collectionReference = _firestore.collection(collectionName);
    }

    Query query = collectionReference;
    List<List<String>> userNamesChunks = <List<String>>[];
    for (final condition in conditions) {
      final field = condition[0];
      final operator = condition[1];
      final value = condition[2];
      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        case 'arrayContains':
          query = query.where(field, arrayContains: value);
          break;
        case 'arrayContainsAny':
          query = query.where(field, arrayContainsAny: value);
          break;
        case 'whereIn':
          List<String> chunk = [];
          for (int i = 0; i < value.length; i += 10) {
            chunk =
                value.sublist(i, i + 10 > value.length ? value.length : i + 10);
            userNamesChunks.add(chunk);
          }

          break;
        case 'arrayContainsAll':
          query = query.where(field, whereIn: [
            [value.first, value[1]],
            [value[1], value.first]
          ]);

          // query = query.where(field, arrayContainsAny: value);
          break;
        default:
          throw ArgumentError('Invalid operator: $operator');
      }
    }

    QuerySnapshot querySnapshot;
    if (userNamesChunks.isNotEmpty) {
      List<QuerySnapshot> snapshots =
          await Future.wait(userNamesChunks.map((List<String> chunk) {
        return query.where(FieldPath.documentId, whereIn: chunk).get();
      }));
      List<T> list = <T>[];
      for (QuerySnapshot sn in snapshots) {
        list.addAll(
            sn.docs.map((e) => _documentSnapshotToModel(e) as T).toList());
      }
      return list;
    } else {
      querySnapshot = await query.get();
      if (lastDocfromData != null) {
        if (kDebugMode) {
          print("querySnapshot.docs.last");
          print(querySnapshot.docs.last);
        }

        lastDocfromData(querySnapshot.docs.last);
      }

      return querySnapshot.docs
          .map((e) => _documentSnapshotToModel(e) as T)
          .toList();
    }
  }

  Future<bool> checkExists(List<List<dynamic>> conditions) async {
    if (kDebugMode) {
      print(
          'Getting documents from collection: $collectionName with where conditions: $conditions');
    }
    var collectionReference = _firestore.collection(collectionName);

    Query query = collectionReference;

    for (final condition in conditions) {
      final field = condition[0];
      final operator = condition[1];
      final value = condition[2];
      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        case 'arrayContains':
          query = query.where(field, arrayContains: value);
          break;
        case 'arrayContainsAll':
          query = query
              .where(field, arrayContains: value.first)
              .where(field, arrayContains: value[1]);
          break;
        default:
          throw ArgumentError('Invalid operator: $operator');
      }
    }

    QuerySnapshot querySnapshot = await query.get();

    return querySnapshot.docs.isEmpty ? false : true;
  }

  Stream<QuerySnapshot<Object?>> getWhereListen(List<List<dynamic>> conditions,
      {String? orderBy,
      int? limit,
      DocumentSnapshot? startAfterDocument,
      bool descending = false}) {
    if (kDebugMode) {
      print(
          'Getting documents from collection: $collectionName with where conditions: $conditions');
    }
    Query<Map<String, dynamic>> collectionReference;
    if (orderBy != null && limit != null && startAfterDocument != null) {
      collectionReference = _firestore
          .collection(collectionName)
          .orderBy(orderBy, descending: descending)
          .startAfterDocument(startAfterDocument)
          .limit(limit);
    } else if (orderBy != null && limit != null) {
      collectionReference = _firestore
          .collection(collectionName)
          .orderBy(orderBy, descending: descending)
          .limit(limit);
    } else if (orderBy != null && startAfterDocument != null) {
      collectionReference = _firestore
          .collection(collectionName)
          .orderBy(orderBy, descending: descending)
          .startAfterDocument(startAfterDocument);
    } else if (orderBy != null) {
      collectionReference = _firestore
          .collection(collectionName)
          .orderBy(orderBy, descending: descending);
    } else if (limit != null) {
      collectionReference = _firestore.collection(collectionName).limit(limit);
    } else {
      collectionReference = _firestore.collection(collectionName);
    }

    Query query = collectionReference;

    for (final condition in conditions) {
      final field = condition[0];
      final operator = condition[1];
      final value = condition[2];
      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        case 'arrayContains':
          query = query.where(field, arrayContains: value);
          break;
        case 'arrayContainsAll':
          query = query
              .where(field, arrayContains: value.first)
              .where(field, arrayContains: value[1]);
          break;
        default:
          throw ArgumentError('Invalid operator: $operator');
      }
    }

    return query.snapshots();
  }

  Future<List<T>> getAllDocuments() async {
    if (kDebugMode) {
      print('Getting all documents from collection: $collectionName');
    }
    final queryStream = _firestore.collection(collectionName).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => _documentSnapshotToModel(doc))
              .toList(),
        );
    return await queryStream.first as List<T>;
  }

  Future<void> removeDocument(String id) async {
    if (kDebugMode) {
      print('Removing document from collection: $collectionName with id: $id');
    }
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      if (kDebugMode) {
        print('Document removed from collection: $collectionName with id: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'Failed to remove document from collection: $collectionName with id: $id');
        print('Error: $e');
      }
    }
  }

  Future<void> removeMultipleDocuments(List<List<dynamic>> conditions) async {
    if (kDebugMode) {
      print('Removing document from collection: $collectionName with id:');
    }
    try {
      var collectionReference = _firestore.collection(collectionName);
      Query query = collectionReference;

      for (final condition in conditions) {
        final field = condition[0];
        final operator = condition[1];
        final value = condition[2];
        switch (operator) {
          case '==':
            query = query.where(field, isEqualTo: value);
            break;
          case '<':
            query = query.where(field, isLessThan: value);
            break;
          case '<=':
            query = query.where(field, isLessThanOrEqualTo: value);
            break;
          case '>':
            query = query.where(field, isGreaterThan: value);
            break;
          case '>=':
            query = query.where(field, isGreaterThanOrEqualTo: value);
            break;
          case 'in':
            query = query.where(field, whereIn: value);
            break;
          case 'arrayContains':
            query = query.where(field, arrayContains: value);
            break;
          default:
            throw ArgumentError('Invalid operator: $operator');
        }
      }

      final WriteBatch batch = _firestore.batch();
      QuerySnapshot querySnapshot = await query.get();

      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });

      await batch.commit();
      if (kDebugMode) {
        print('Document removed from collection: $collectionName with id: ');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'Failed to remove document from collection: $collectionName with id: ');
        print('Error: $e');
      }
    }
  }

  Jsonable _documentSnapshotToModel(DocumentSnapshot data) {
    return Jsonable.fromFirestore(data, T);
  }
}
