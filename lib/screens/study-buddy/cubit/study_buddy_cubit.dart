import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/study_buddy.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/failure.dart';
import '/repositories/study-buddy/study_buddy_repo.dart';
part 'study_buddy_state.dart';

class StudyBuddyCubit extends Cubit<StudyBuddyState> {
  final StudyBuddyRepository _studyBuddyRepository;
  final AuthBloc _authBloc;

  StudyBuddyCubit({
    required StudyBuddyRepository studyBuddyRepository,
    required AuthBloc authBloc,
  })  : _studyBuddyRepository = studyBuddyRepository,
        _authBloc = authBloc,
        super(StudyBuddyState.initial());

  void degreeNameChanged(String value) {
    emit(state.copyWith(degree: value, status: StudyBuddyStatus.initial));
  }

  void clearInterests() {
    emit(state.copyWith(interests: [], status: StudyBuddyStatus.initial));
  }

  void addInterest(String value) {
    final List<String> interests = List.from(state.interests)
      ..add(value)
      ..sort();

    emit(
        state.copyWith(interests: interests, status: StudyBuddyStatus.initial));
  }

  void delteInterest(String value) {
    final List<String> interests = List.from(state.interests)
      ..remove(value)
      ..sort();

    emit(
        state.copyWith(interests: interests, status: StudyBuddyStatus.initial));
  }

  Future<void> register() async {
    try {
      emit(state.copyWith(status: StudyBuddyStatus.submitting));

      final buddy = StudyBuddy(
        interests: state.interests,
        degree: state.degree,
        user: _authBloc.state.user,
      );

      await _studyBuddyRepository.createStudyBuddy(buddy: buddy);

      emit(state.copyWith(status: StudyBuddyStatus.succuss));
    } on Failure catch (error) {
      print('Error in registering mentee ${error.message}');
      emit(state.copyWith(
          failure: Failure(message: error.message),
          status: StudyBuddyStatus.error));
    }
  }

  void loadProfile() async {
    try {
      emit(state.copyWith(status: StudyBuddyStatus.loading));
      final buddy = await _studyBuddyRepository.getCurrentStudyBuddy(
          userId: _authBloc.state.user?.uid);
      print('Buddy --- $buddy');
      emit(
        state.copyWith(
          degree: buddy?.degree,
          interests: buddy?.interests,
          status: StudyBuddyStatus.succuss,
        ),
      );
    } on Failure catch (error) {
      print(error.message);
      emit(state.copyWith(status: StudyBuddyStatus.error, failure: error));
    }
  }

  void loadRecommendedBuddies({
    required StudyBuddy? studyBuddy,
  }) async {
    try {
      emit(state.copyWith(status: StudyBuddyStatus.loading));
      final buddies = await _studyBuddyRepository.getRecommendedStudyBuddies(
          studyBuddy: studyBuddy);
      emit(
        state.copyWith(
          status: StudyBuddyStatus.succuss,
          recommendedBuddies: await Future.wait(buddies)
            ..removeWhere(
                (element) => element?.user?.uid == _authBloc.state.user?.uid),
        ),
      );
    } on Failure catch (error) {
      print('Error in getting buddies recommendations');
      emit(state.copyWith(status: StudyBuddyStatus.error, failure: error));
    }
  }

  void connect({
    required String? currentUserId,
    required String? buddyUserId,
  }) async {
    try {
      await _studyBuddyRepository.connectBuddy(
          currentUserId: currentUserId, buddyUserId: buddyUserId);
    } on Failure catch (error) {
      emit(state.copyWith(status: StudyBuddyStatus.error, failure: error));
    }
  }
}
