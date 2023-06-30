import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dani/core/constants.dart';
import 'package:dani/core/services/firestore_service.dart';
import 'package:dani/core/utils/firestore/firestore_order_by.dart';
import 'package:dani/core/utils/firestore/firestore_query.dart';
import 'package:dani/core/utils/iterable_util.dart';
import 'package:dani/features/spending/businesses/models/spending.dart';
import 'package:dani/features/spending/businesses/models/spending_category.dart';

import '../businesses/models/spending_request.dart';

class SpendingService {
  final FirestoreService firestoreService;

  SpendingService(this.firestoreService);

  final String _collectionName = 'spending_category';
  final String _collectionSpending = 'spending_request';

  late QueryDocumentSnapshot _lastDocumentSpending;

  Future<List<SpendingCategory>> getListSpendingCategory() async {
    QuerySnapshot querySnapshot =
        await firestoreService.getCollection(_collectionName);
    return querySnapshot.docs.map((element) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      data[JsonKeyConstants.id] = element.id;
      return SpendingCategory.fromJson(data);
    }).toList();
  }

  Future<List<Spending>> getListSpending({
    QueryDocumentSnapshot<Object?>? lastDocumentSnapshot,
    int? limit,
    List<FirestoreQuery>? queries,
  }) async {
    QuerySnapshot? querySnapshot = await firestoreService.getCollectionByUser(
      limit: limit,
      _collectionSpending,
      lastDocumentSnapshot: lastDocumentSnapshot,
      queries: [
        FirestoreQueryEqualTo(JsonKeyConstants.isDeleted, [false, null]),
        if (IterableUtil.isNotNullOrEmpty(queries)) ...queries!,
      ],
      listOrderBy: [
        FirestoreOrderByDesending(JsonKeyConstants.createdDate),
      ],
    );
    if (querySnapshot == null || querySnapshot.docs.isEmpty) return [];
    _lastDocumentSpending = querySnapshot.docs.last;
    return querySnapshot.docs.map((element) {
      Map<String, dynamic> data = element.data() as Map<String, dynamic>;
      data[JsonKeyConstants.id] = element.id;

      return Spending.fromJson(data);
    }).toList();
  }

  Future<List<Spending>> loadMoreListSpending() async => getListSpending(
        lastDocumentSnapshot: _lastDocumentSpending,
        limit: Constants.limitNumberOfItem,
      );

  Future<bool> addSpendingRequest(SpendingRequest spendingRequest) async {
    return await firestoreService.createDocument(
      collectionPath: _collectionSpending,
      data: spendingRequest.toJson(),
    );
  }

  Future<bool> updateSpendingRequest(SpendingRequest spendingRequest) =>
      updateByRawJson(spendingRequest.toJson());

  Future<bool> updateByRawJson(Map<String, dynamic> json) async {
    return await firestoreService.updateDocument(
      collectionPath: _collectionSpending,
      data: json,
    );
  }
}
