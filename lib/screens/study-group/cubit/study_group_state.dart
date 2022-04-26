part of 'study_group_cubit.dart';

enum StudyGroupStatus { initial, loading, submitting, succuss, error }

class StudyGroupState extends Equatable {
  final String? degree;
  final List<String?> interests;
  final StudyGroupStatus status;
  final Failure failure;
  final List<StudyGroup?> studyGroups;

  const StudyGroupState({
    this.degree,
    required this.interests,
    required this.status,
    required this.failure,
    required this.studyGroups,
  });

  factory StudyGroupState.initial() => const StudyGroupState(
        interests: [],
        status: StudyGroupStatus.initial,
        failure: Failure(),
        studyGroups: [],
      );

  @override
  List<Object?> get props {
    return [
      degree,
      interests,
      status,
      failure,
      studyGroups,
    ];
  }

  StudyGroupState copyWith({
    String? degree,
    List<String?>? interests,
    StudyGroupStatus? status,
    Failure? failure,
    List<StudyGroup?>? studyGroups,
  }) {
    return StudyGroupState(
      degree: degree ?? this.degree,
      interests: interests ?? this.interests,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      studyGroups: studyGroups ?? this.studyGroups,
    );
  }

  @override
  String toString() {
    return 'StudyGroupState(degree: $degree, interests: $interests, status: $status, failure: $failure, studyGroups: $studyGroups)';
  }
}
