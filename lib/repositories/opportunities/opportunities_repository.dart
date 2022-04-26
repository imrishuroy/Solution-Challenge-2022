import 'package:cloud_firestore/cloud_firestore.dart';
import '/config/paths.dart';
import '/models/failure.dart';
import '/models/opportunity.dart';
import '/repositories/opportunities/base_opportunities_repo.dart';

class OpportunitiesRepository extends BaseOpportunitiesRepo {
  final FirebaseFirestore _firestore;

  OpportunitiesRepository({FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<Opportunity?>> getOpportunities() async {
    try {
      final opportunitySnaps =
          await _firestore.collection(Paths.opportunities).get();
      return opportunitySnaps.docs
          .map((doc) => Opportunity.fromDoc(doc))
          .toList();
    } catch (error) {
      print('Error in getting opportunities');
      throw const Failure(message: 'Error in getting opportunities');
    }
  }

  Future<void> saveOpportunity({
    required String? userId,
    required String? opportunityId,
  }) async {
    try {
      if (userId == null || opportunityId == null) {
        return;
      }
      await _firestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.opportunities)
          .doc(opportunityId)
          .set({});
    } catch (error) {
      throw const Failure(message: 'Error in saving opportunity');
    }
  }

  Future<List<Opportunity?>> getUserSavedOpportunities({
    required String? userId,
  }) async {
    try {
      List<Opportunity?> opportunities = [];
      if (userId == null) {
        return [];
      }
      final opportunitiesSnaps = await _firestore
          .collection(Paths.users)
          .doc(userId)
          .collection(Paths.opportunities)
          .get();

      for (var item in opportunitiesSnaps.docs) {
        final opportunityDocRef =
            _firestore.collection(Paths.opportunities).doc(item.id);

        final docSnaps = await opportunityDocRef.get();

        opportunities.add(Opportunity.fromDoc(docSnaps));
      }
      return opportunities;
    } catch (error) {
      throw const Failure(message: 'Error in saving opportunity');
    }
  }
}
