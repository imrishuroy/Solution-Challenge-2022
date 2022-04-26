import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/study_group_user.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/failure.dart';
import '/models/study_group.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';

part 'study_group_state.dart';

class StudyGroupCubit extends Cubit<StudyGroupState> {
  final StudyBuddyRepository _studyBuddyRepository;
  final AuthBloc _authBloc;
  StudyGroupCubit({
    required StudyBuddyRepository studyBuddyRepository,
    required AuthBloc authBloc,
  })  : _authBloc = authBloc,
        _studyBuddyRepository = studyBuddyRepository,
        super(StudyGroupState.initial());

  void degreeNameChanged(String value) async {
    print('Degree name -- $value');
    emit(state.copyWith(degree: value));
  }

  void clearInterests() {
    emit(state.copyWith(interests: [], status: StudyGroupStatus.initial));
  }

  void addInterest(String value) {
    final List<String> interests = List.from(state.interests)
      ..add(value)
      ..sort();

    emit(
        state.copyWith(interests: interests, status: StudyGroupStatus.initial));
  }

  void delteInterest(String value) {
    final List<String> interests = List.from(state.interests)
      ..remove(value)
      ..sort();

    emit(
        state.copyWith(interests: interests, status: StudyGroupStatus.initial));
  }

  void register() async {
    try {
      emit(state.copyWith(status: StudyGroupStatus.loading));
      final user = StudyGroupUser(
        interests: state.interests,
        degree: state.degree,
        user: _authBloc.state.user,
      );
      await _studyBuddyRepository.createUser(groupUser: user);
      emit(
        state.copyWith(
          status: StudyGroupStatus.succuss,
        ),
      );
    } on Failure catch (error) {
      emit(state.copyWith(failure: error, status: StudyGroupStatus.error));
    }
  }

  void loadProfile() async {
    try {
      emit(state.copyWith(status: StudyGroupStatus.loading));
      final buddy = await _studyBuddyRepository.getCurrentGroupUser(
          userId: _authBloc.state.user?.uid);

      print('Buddy --- $buddy');
      emit(
        state.copyWith(
          degree: buddy?.degree,
          interests: buddy?.interests,
          status: StudyGroupStatus.succuss,
        ),
      );
    } on Failure catch (error) {
      print(error.message);
      emit(state.copyWith(status: StudyGroupStatus.error, failure: error));
    }
  }

  void loadGroupsSuggestions({required StudyGroupUser? user}) async {
    try {
      emit(state.copyWith(status: StudyGroupStatus.loading));
      final groups =
          await _studyBuddyRepository.getGroupSuggestions(user: user);

      print('Groups ---- $groups');

      emit(state.copyWith(
          studyGroups: groups, status: StudyGroupStatus.succuss));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: StudyGroupStatus.error));
    }
  }

  void joinGroup({
    required String? groupId,
    required String? studyGroupUserId,
  }) async {
    try {
      emit(state.copyWith(status: StudyGroupStatus.loading));

      await _studyBuddyRepository.joinGroup(
          groupId: groupId, studyGroupUserId: studyGroupUserId);

      emit(state.copyWith(status: StudyGroupStatus.succuss));
    } on Failure catch (error) {
      emit(state.copyWith(failure: error, status: StudyGroupStatus.error));
    }
  }
}
