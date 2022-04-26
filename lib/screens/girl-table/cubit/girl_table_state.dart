part of 'girl_table_cubit.dart';

enum GirlTableStatus { initial, loading, succuss, error }

class GirlTableState extends Equatable {
  final List<Topic?> topics;
  final List<Discussion?> discussions;
  final GirlTableStatus status;
  final Topic? problemTopic;
  final String? problemTitle;
  final String? problemDescription;
  final Failure failure;
  final List<DiscussionComment?> discussionComments;

  const GirlTableState({
    required this.topics,
    required this.discussions,
    required this.status,
    this.problemDescription,
    this.problemTitle,
    this.problemTopic,
    required this.failure,
    this.discussionComments = const [],
  });

  factory GirlTableState.initial() => const GirlTableState(
        topics: [],
        discussions: [],
        status: GirlTableStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object?> get props => [
        topics,
        discussions,
        status,
        problemTopic,
        problemTitle,
        problemDescription,
        failure,
        discussionComments
      ];

  GirlTableState copyWith({
    List<Topic?>? topics,
    List<Discussion?>? discussions,
    GirlTableStatus? status,
    Topic? problemTopic,
    String? problemTitle,
    String? problemDescription,
    Failure? failure,
    List<DiscussionComment?>? discussionComments,
  }) {
    return GirlTableState(
      topics: topics ?? this.topics,
      discussions: discussions ?? this.discussions,
      status: status ?? this.status,
      problemTopic: problemTopic ?? this.problemTopic,
      problemDescription: problemDescription ?? this.problemDescription,
      problemTitle: problemTitle ?? this.problemTitle,
      failure: failure ?? this.failure,
      discussionComments: discussionComments ?? this.discussionComments,
    );
  }
}
