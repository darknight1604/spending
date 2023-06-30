import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dani/core/app_config.dart';
import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/firestore/firestore_order_by.dart';
import 'package:dani/core/utils/firestore/firestore_query.dart';
import 'package:dani/core/utils/string_util.dart';

import '../../utils/iterable_util.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AppConfig _appConfig = AppConfig.instance;

  Future<QuerySnapshot> getCollection(
    String collectionPath, {
    List<FirestoreQuery>? queries,
    List<FirestoreOrderBy>? listOrderBy,
    DocumentSnapshot<Object?>? lastDocumentSnapshot,
    int? limit,
  }) async {
    CollectionReference collection = _firestore.collection(
      _collectionNameBuilder(collectionPath),
    );
    if (IterableUtil.isNullOrEmpty(queries) &&
        IterableUtil.isNullOrEmpty(listOrderBy)) {
      return await collection.get();
    }
    if (IterableUtil.isNotNullOrEmpty(queries) &&
        IterableUtil.isNotNullOrEmpty(listOrderBy)) {
      return await FirestoreOrderByHelper.magicByQuery(
        FirestoreQueryHelper.magic(collection, queries!),
        listOrderBy!,
        lastDocumentSnapshot: lastDocumentSnapshot,
        limit: limit,
      ).get();
    }
    if (queries != null && queries.isNotEmpty) {
      return FirestoreQueryHelper.magic(collection, queries).get();
    }
    return await FirestoreOrderByHelper.magic(
      collection,
      listOrderBy!,
      lastDocumentSnapshot: lastDocumentSnapshot,
      limit: limit,
    ).get();
  }

  Future<bool> createDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    CollectionReference collection = _firestore.collection(
      _collectionNameBuilder(collectionPath),
    );

    return await collection
        .add(data)
        .then((value) => true)
        .catchError((_) => false);
  }

  Future<bool> updateDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    String? id = data[JsonKeyConstants.id];
    if (StringUtil.isNullOrEmpty(id)) {
      return false;
    }
    CollectionReference collection = _firestore.collection(
      _collectionNameBuilder(collectionPath),
    );
    return await collection
        .doc(id)
        .update(data)
        .then((value) => true)
        .catchError((_) => false);
  }

  String _collectionNameBuilder(String collection) {
    bool isDevelop = _appConfig.appConfigData?.isDevelop ?? false;
    if (isDevelop) {
      return '${_appConfig.appConfigData?.environment.devPath}$collection';
    }
    return '${_appConfig.appConfigData?.environment.prodPath}$collection';
  }
}
