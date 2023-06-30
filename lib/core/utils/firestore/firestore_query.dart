import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreQuery {
  final String key;
  final List<dynamic> listValue;

  FirestoreQuery(this.key, this.listValue);
}

class FirestoreQueryEqualTo extends FirestoreQuery {
  FirestoreQueryEqualTo(super.key, super.listValue);
}

class FirestoreQueryNotEqualTo extends FirestoreQuery {
  FirestoreQueryNotEqualTo(super.key, super.listValue);
}

class FirestoreQueryGreaterThanOrEqualTo extends FirestoreQuery {
  FirestoreQueryGreaterThanOrEqualTo(super.key, super.listValue);
}

class FirestoreQueryLessThanOrEqualTo extends FirestoreQuery {
  FirestoreQueryLessThanOrEqualTo(super.key, super.listValue);
}

class FirestoreQueryHelper {
  static Query<Object?> _magic(
    Query<Object?> collectionRef,
    FirestoreQuery query,
  ) {
    switch (query.runtimeType) {
      case FirestoreQueryEqualTo:
        return collectionRef.where(query.key, isEqualTo: query.listValue.first);
      case FirestoreQueryGreaterThanOrEqualTo:
        return collectionRef.where(query.key,
            isGreaterThanOrEqualTo: query.listValue.first);
      case FirestoreQueryLessThanOrEqualTo:
        return collectionRef.where(query.key,
            isLessThanOrEqualTo: query.listValue.first);
      default:
    }
    return collectionRef;
  }

  static Query<Object?> magic(
    Query<Object?> collectionRef,
    List<FirestoreQuery> firestoreQueries,
  ) {
    for (var firestoreQuery in firestoreQueries) {
      collectionRef = _magic(collectionRef, firestoreQuery);
    }
    return collectionRef;
  }
}
