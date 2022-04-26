part of 'study_buddy_cubit.dart';

enum StudyBuddyStatus { initial, loading, submitting, succuss, error }

class StudyBuddyState extends Equatable {
  final String? degree;
  final List<String?> interests;
  final StudyBuddyStatus status;
  final Failure failure;
  final List<StudyBuddy?> recommendedBuddies;

  const StudyBuddyState({
    this.degree,
    required this.interests,
    required this.status,
    required this.failure,
    this.recommendedBuddies = const [],
  });

  factory StudyBuddyState.initial() => const StudyBuddyState(
        interests: [],
        status: StudyBuddyStatus.initial,
        failure: Failure(),
        recommendedBuddies: [],
      );

  @override
  List<Object?> get props => [degree, interests, status, failure];

  StudyBuddyState copyWith({
    String? degree,
    List<String?>? interests,
    StudyBuddyStatus? status,
    Failure? failure,
    List<StudyBuddy?>? recommendedBuddies,
  }) {
    return StudyBuddyState(
      degree: degree ?? this.degree,
      interests: interests ?? this.interests,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      recommendedBuddies: recommendedBuddies ?? this.recommendedBuddies,
    );
  }

  @override
  String toString() {
    return 'StudyBuddyState(degree: $degree, interests: $interests, status: $status, failure: $failure, recommendedBuddies: $recommendedBuddies)';
  }
}
