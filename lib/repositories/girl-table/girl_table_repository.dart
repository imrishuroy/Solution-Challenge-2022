import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/discussion_comment.dart';
import '/models/app_user.dart';
import '/config/paths.dart';
import '/models/topic.dart';
import '/models/discussion.dart';
import '/models/failure.dart';
import 'base_girl_table_repo.dart';

class GirlTableRepository extends BaseGirlTableRepository {
  final FirebaseFirestore _firestore;

  GirlTableRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Topic?>> fetchTopics() async {
    try {
      final topicSnaps = await _firestore.collection(Paths.girlTtable).get();

      return topicSnaps.docs.map((doc) => Topic.fromDocument(doc)).toList();
    } catch (error) {
      print('Error in gettings topics ${error.toString()}');
      throw const Failure(message: 'Error in getting topics');
    }
  }

  Future<List<Future<Discussion?>>> getTopicDiscussions({
    required String? topicId,
  }) async {
    try {
      if (topicId == null) {
        return [];
      }

      // final discussionSnaps =
      //     await _firestore.collection(Paths.discussion).get();

      final discussionSnaps = await _firestore
          .collection(Paths.girlTtable)
          .doc(topicId)
          .collection(Paths.discussion)
          .get();

      return discussionSnaps.docs.map((doc) async {
        final users = await getDiscussionUsers(discussionId: doc.id);
        final dicussion = await Discussion.fromDocument(doc: doc);
        //dicussion?.copyWith(users: users);
        return dicussion?.copyWith(users: users);
      }).toList();
    } catch (error) {
      print('Error in getting discussion ${error.toString()}');
      throw const Failure(message: 'Error getting discussion');
    }
  }

  Future<void> addDiscussion({
    required Discussion? discussion,
  }) async {
    try {
      print('Disccussion from discussio  $discussion');
      if (discussion == null) {
        return;
      }
      await _firestore
          .collection(Paths.girlTtable)
          .doc(discussion.topicId)
          .collection(Paths.discussion)
          .add(discussion.toMap());
    } catch (error) {
      print('Error adding discussion ${error.toString()}');
      throw const Failure(message: 'Error adding discussion');
    }
  }

  Future<List<AppUser?>> getDiscussionUsers({
    required String? discussionId,
  }) async {
    try {
      List<AppUser?> users = [];
      final userSnaps = await _firestore
          .collection(Paths.discussionUsers)
          .doc(discussionId)
          .collection(Paths.users)
          .get();
      for (var item in userSnaps.docs) {
        final _userRef = _firestore.collection(Paths.users).doc(item.id);
        final userSnap = await _userRef.get();

        final user = AppUser.fromDocument(userSnap);
        print('Users added $user');
        users.add(user);
      }
      return users;
    } catch (error) {
      print('Error in discussion users  ${error.toString()}');
      throw const Failure(message: 'Error in discussion users');
    }
  }

  Future<void> joinDiscussion({
    required Discussion? discussion,
    required String? userId,
  }) async {
    try {
      if (discussion == null) {
        return;
      }

      await _firestore
          .collection(Paths.discussionUsers)
          .doc(discussion.discussionId)
          .collection(Paths.users)
          .doc(userId)
          .set({});
    } catch (error) {
      print('Error in joining discussion ${error.toString()}');
      throw const Failure(message: 'Error in joining discussion');
    }
  }

  Future<void> addDiscussionChat({
    required DiscussionComment comment,
  }) async {
    try {
      await _firestore
          .collection(Paths.discussionComments)
          .doc(comment.discussionId)
          .collection(Paths.comments)
          .add(comment.toMap());
    } catch (error) {
      print('Error in addin discussion chat ${error.toString()}');
      throw const Failure(message: 'Error in adding discussion chat');
    }
  }

  Stream<List<Future<DiscussionComment?>>> streamDiscussionComments({
    required String? discussionId,
  }) {
    try {
      final commentsSnaps = _firestore
          .collection(Paths.discussionComments)
          .doc(discussionId)
          .collection(Paths.comments)
          .orderBy('createdAt', descending: true)
          .snapshots();
      return commentsSnaps.map((snaps) {
        return snaps.docs
            .map((doc) => DiscussionComment.fromDocument(doc: doc))
            .toList();
      });
    } catch (error) {
      print('Error in streaming discussion comments ${error.toString()}');
      throw const Failure(message: 'Error in getting discussion commnets');
    }
  }
}
