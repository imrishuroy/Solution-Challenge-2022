part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, succuss, error }

class ChatState extends Equatable {
  final String message;
  final String messageType;
  final Failure failure;
  final ChatStatus status;
  final List<ChatMessage?> chats;

  const ChatState({
    required this.message,
    required this.messageType,
    required this.failure,
    required this.status,
    required this.chats,
  });

  bool get isFormValid => message.isNotEmpty;
  // && password.isNotEmpty;

  factory ChatState.initial() => const ChatState(
        messageType: '',
        failure: Failure(),
        status: ChatStatus.initial,
        message: '',
        chats: [],
      );
  @override
  List<Object?> get props => [
        message,
        messageType,
        failure,
        status,
        chats,
      ];

  ChatState copyWith({
    String? message,
    String? messageType,
    Failure? failure,
    ChatStatus? status,
    UserType? userType,
    List<ChatMessage?>? chats,
  }) {
    return ChatState(
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      failure: failure ?? this.failure,
      status: status ?? this.status,
      chats: chats ?? this.chats,
    );
  }
}
