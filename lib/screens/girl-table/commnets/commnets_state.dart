part of 'commnets_cubit.dart';

enum CommentsStatus { initial, loading, succuss, error }

class CommnetsState extends Equatable {
  final Failure failure;
  final List<DiscussionComment?> discussionComments;
  final CommentsStatus status;
  final String comment;

  const CommnetsState({
    required this.failure,
    required this.discussionComments,
    required this.status,
    this.comment = '',
  });

  bool get isFormValid => comment.isNotEmpty;

  factory CommnetsState.initial() => const CommnetsState(
      failure: Failure(),
      discussionComments: [],
      status: CommentsStatus.initial);
  @override
  List<Object> get props => [failure, discussionComments, status, comment];

  CommnetsState copyWith({
    Failure? failure,
    List<DiscussionComment?>? discussionComments,
    CommentsStatus? status,
    String? comment,
  }) {
    return CommnetsState(
      failure: failure ?? this.failure,
      discussionComments: discussionComments ?? this.discussionComments,
      status: status ?? this.status,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() =>
      'CommnetsState(failure: $failure, discussionComments: $discussionComments, status: $status, message: $comment,)';
}
