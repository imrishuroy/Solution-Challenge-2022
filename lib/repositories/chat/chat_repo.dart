import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/failure.dart';
import '/models/chat.dart';
import '/config/paths.dart';
import '/repositories/chat/base_chat_repo.dart';

class ChatRepository extends BaseChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addChat({
    required String? mentorId,
    required String? menteeId,
    required ChatMessage chat,
  }) async {
    try {
      if (mentorId == null || menteeId == null) {
        return;
      }

      await _firestore
          .collection(Paths.chats)
          .doc(mentorId)
          .collection(Paths.chats)
          .add(chat.toMap());

      await _firestore
          .collection(Paths.chats)
          .doc(menteeId)
          .collection(Paths.chats)
          .add(chat.toMap());
    } catch (error) {
      print('Error in adding chat ${error.toString()}');
    }
  }

  Stream<List<ChatMessage?>> streamChat({
    required String? userId,
  }) {
    try {
      final chatSnaps = _firestore
          .collection(Paths.chats)
          .doc(userId)
          .collection(Paths.chats)
          .orderBy('createdAt', descending: false)
          .snapshots();
      return chatSnaps.map((event) {
        return event.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList();
      });
    } catch (error) {
      print('Error in stream chat ${error.toString()}');
      throw const Failure(message: 'Error in gettings chats');
    }
  }
}
