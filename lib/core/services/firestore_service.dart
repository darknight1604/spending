import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dani/core/constants.dart';
import 'package:dani/core/repositories/remote/firestore_repository.dart';
import 'package:dani/core/services/local_service.dart';
import 'package:dani/core/utils/extensions/date_time_extension.dart';
import 'package:dani/core/utils/iterable_util.dart';

import '../../features/login/domains/models/user.dart';
import '../utils/firestore/firestore_order_by.dart';
import '../utils/firestore/firestore_query.dart';

class FirestoreService {
  final FirestoreRepository firestoreRepository;
  final LocalService localService;

  FirestoreService(
    this.firestoreRepository,
    this.localService,
  );

  Future<QuerySnapshot> getCollection(
    String collectionPath, {
    List<FirestoreQuery>? queries,
    DocumentSnapshot<Object?>? lastDocumentSnapshot,
  }) async {
    return await firestoreRepository.getCollection(
      collectionPath,
      queries: queries,
      lastDocumentSnapshot: lastDocumentSnapshot,
    );
  }

  Future<QuerySnapshot?> getCollectionByUser(
    String collectionPath, {
    List<FirestoreOrderBy>? listOrderBy,
    DocumentSnapshot<Object?>? lastDocumentSnapshot,
    int? limit,
    List<FirestoreQuery>? queries,
  }) async {
    User? user = await localService.getUser();
    if (user == null) return null;
    return await firestoreRepository.getCollection(
      collectionPath,
      lastDocumentSnapshot: lastDocumentSnapshot,
      listOrderBy: listOrderBy,
      limit: limit,
      queries: [
        FirestoreQueryEqualTo(
          JsonKeyConstants.userEmail,
          [
            user.email ?? StringPool.empty,
          ],
        ),
        if (IterableUtil.isNotNullOrEmpty(queries)) ...queries!,
      ],
    );
  }

  Future<bool> createDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    User? user = await localService.getUser();
    if (user == null) return false;
    Map<String, dynamic> payload = data;
    payload[JsonKeyConstants.userEmail] = user.email;
    DateTime? createdDate = () {
      dynamic createdDateData = data[JsonKeyConstants.createdDate];
      if (createdDateData is String) {
        return DateTime.tryParse(data[JsonKeyConstants.createdDate] ?? StringPool.empty);
      }
      if (createdDateData is! Timestamp) {
        return null;
      }
      return createdDateData.toDate();
    }.call();
    String index = StringPool.empty;
    if (createdDate != null) {
      index = createdDate.formatYYYYMMPlain();
    }
    payload[JsonKeyConstants.index] = index;
    return firestoreRepository.createDocument(
      collectionPath: collectionPath,
      data: payload,
    );
  }

  Future<bool> updateDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    User? user = await localService.getUser();
    if (user == null) return false;
    Map<String, dynamic> payload = data;
    payload[JsonKeyConstants.userEmail] = user.email;
    return firestoreRepository.updateDocument(
      collectionPath: collectionPath,
      data: payload,
    );
  }
}
