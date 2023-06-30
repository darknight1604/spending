import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreOrderBy {
  final String key;

  FirestoreOrderBy(this.key);
}

class FirestoreOrderByAscending extends FirestoreOrderBy {
  FirestoreOrderByAscending(super.key);
}

class FirestoreOrderByDesending extends FirestoreOrderBy {
  FirestoreOrderByDesending(super.key);
}

class FirestoreOrderByHelper {
  static Query<Object?> _magic(
    Query<Object?> collectionRef,
    FirestoreOrderBy orderBy,
  ) {
    switch (orderBy.runtimeType) {
      case FirestoreOrderByDesending:
        return collectionRef.orderBy(orderBy.key, descending: true);
      default:
        return collectionRef.orderBy(orderBy.key);
    }
  }

  static Query<Object?> magic(
    Query<Object?> collectionRef,
    List<FirestoreOrderBy> listOrderBy, {
    DocumentSnapshot<Object?>? lastDocumentSnapshot,
    int? limit,
  }) {
    Query<Object?> query = collectionRef;
    for (var orderBy in listOrderBy) {
      query = _magic(collectionRef, orderBy);
    }
    if (lastDocumentSnapshot != null) {
      query = query.startAfterDocument(lastDocumentSnapshot);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query;
  }

  static Query<Object?> magicByQuery(
    Query<Object?> query,
    List<FirestoreOrderBy> listOrderBy, {
    DocumentSnapshot<Object?>? lastDocumentSnapshot,
    int? limit,
  }) {
    return magic(
      query,
      listOrderBy,
      lastDocumentSnapshot: lastDocumentSnapshot,
      limit: limit,
    );
  }
}
