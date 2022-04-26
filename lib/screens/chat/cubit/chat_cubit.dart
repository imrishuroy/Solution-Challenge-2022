import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/enums/user_type.dart';
import '/models/chat.dart';
import '/models/failure.dart';
import '/repositories/chat/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String? _menteeId;
  final String? _mentorId;
  final UserType _userType;

  late StreamSubscription<List<ChatMessage?>> _chatsSubscription;

  ChatCubit({
    required ChatRepository chatRepository,
    required String? menteeId,
    required String? mentorId,
    required UserType userType,
  })  : _menteeId = menteeId,
        _mentorId = mentorId,
        _chatRepository = chatRepository,
        _userType = userType,
        super(ChatState.initial()) {
    streamChats();
  }

  void streamChats() {
    try {
      emit(state.copyWith(status: ChatStatus.loading));
      if (_userType == UserType.mentor) {
        _chatsSubscription =
            _chatRepository.streamChat(userId: _mentorId).listen((chats) {
          emit(state.copyWith(chats: chats));
        });
      } else if (_userType == UserType.mentee) {
        _chatsSubscription =
            _chatRepository.streamChat(userId: _menteeId).listen((chats) {
          emit(state.copyWith(chats: chats));
        });
      }
      emit(state.copyWith(status: ChatStatus.succuss));
    } on Failure catch (error) {
      print('Error in stream chats  ${error.message}');
      emit(state.copyWith(
          status: ChatStatus.error, failure: Failure(message: error.message)));
    }
  }

  @override
  Future<void> close() {
    _chatsSubscription.cancel();
    return super.close();
  }

  void messageChanged(String value, UserType userType) {
    emit(state.copyWith(
        message: value, userType: userType, status: ChatStatus.initial));
  }

  void sendChat() async {
    try {
      _chatRepository.addChat(
        mentorId: _mentorId,
        menteeId: _menteeId,
        chat: ChatMessage(
          messageContent: state.message,
          userType: _userType,
          createdAt: DateTime.now(),
        ),
      );
    } on Failure catch (error) {
      print('Error in send chat cubit  ${error.message}');
    }
  }
}
