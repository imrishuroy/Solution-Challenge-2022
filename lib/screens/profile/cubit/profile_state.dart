part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, succuss, error }

class ProfileState extends Equatable {
  final AppUser? user;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    this.user,
    required this.status,
    required this.failure,
  });

  ProfileState copyWith({
    AppUser? user,
    ProfileStatus? status,
    Failure? failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  factory ProfileState.initial() =>
      const ProfileState(status: ProfileStatus.initial, failure: Failure());

  @override
  List<Object?> get props => [user, status, failure];
}
