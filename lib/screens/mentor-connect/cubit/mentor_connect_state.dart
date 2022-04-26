part of 'mentor_connect_cubit.dart';

enum MentorConnectStatus { initial, loading, submitting, succuss, error }

class MentorConnectState extends Equatable {
  final String? degree;
  final List<String?> interests;
  final String reason;
  final MentorConnectStatus status;
  final Failure failure;
  final Mentee? mentee;
  final Mentor? mentor;
  final List<Mentor?> suggestedMentors;
  final List<Mentee?> suggestedMentees;
  final bool isMenteeConnected;
  final String? phNo;

  const MentorConnectState({
    this.degree,
    this.interests = const [],
    required this.reason,
    required this.status,
    required this.failure,
    this.mentor,
    this.mentee,
    this.suggestedMentors = const [],
    this.suggestedMentees = const [],
    this.isMenteeConnected = false,
    this.phNo,
  });

  factory MentorConnectState.initial() => const MentorConnectState(
        interests: [],
        reason: '',
        status: MentorConnectStatus.initial,
        failure: Failure(),
        mentee: null,
        mentor: null,
        suggestedMentors: [],
        isMenteeConnected: false,
        phNo: '',
      );

  MentorConnectState copyWith({
    String? degree,
    List<String?>? interests,
    String? reason,
    MentorConnectStatus? status,
    Failure? failure,
    Mentee? mentee,
    Mentor? mentor,
    List<Mentor?>? suggestedMentors,
    List<Mentee?>? suggestedMentees,
    bool? isMenteeConnected,
    String? phNo,
  }) {
    return MentorConnectState(
      degree: degree ?? this.degree,
      interests: interests ?? this.interests,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      mentee: mentee ?? this.mentee,
      mentor: mentor ?? this.mentor,
      suggestedMentors: suggestedMentors ?? this.suggestedMentors,
      suggestedMentees: suggestedMentees ?? this.suggestedMentees,
      isMenteeConnected: isMenteeConnected ?? this.isMenteeConnected,
      phNo: phNo ?? this.phNo,
    );
  }

  @override
  String toString() {
    return 'MentorConnectState(degree: $degree, interests: $interests, reason: $reason, status: $status, failure: $failure, mentor: $mentor, mentee: $mentee, suggestedMentors: $suggestedMentors,suggestedMentees: $suggestedMentees , isMenteeConnected: $isMenteeConnected, phNo: $phNo)';
  }

  @override
  List<Object?> get props {
    return [
      degree,
      interests,
      reason,
      status,
      failure,
      mentee,
      mentor,
      suggestedMentors,
      suggestedMentees,
      isMenteeConnected,
      phNo,
    ];
  }
}
