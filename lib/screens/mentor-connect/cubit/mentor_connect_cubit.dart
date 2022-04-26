import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/config/shared_prefs.dart';
import '/enums/user_type.dart';
import '/models/mentor.dart';
import '/repositories/mentor-connect/mentor_connect_repo.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/failure.dart';
import '/models/mentee.dart';

part 'mentor_connect_state.dart';

class MentorConnectCubit extends Cubit<MentorConnectState> {
  final MentorConnectRepository _mentorRepository;
  final AuthBloc _authBloc;

  MentorConnectCubit({
    required MentorConnectRepository mentorConnectRepository,
    required AuthBloc authBloc,
  })  : _mentorRepository = mentorConnectRepository,
        _authBloc = authBloc,
        super(MentorConnectState.initial());

  void degreeNameChanged(String value) async {
    print('Degree name -- $value');
    emit(state.copyWith(degree: value));
  }

  void phNoChanged(String value) async {
    print('Degree name -- $value');
    emit(state.copyWith(phNo: value));
  }

  void reasonChanged(String value) async {
    emit(state.copyWith(reason: value, status: MentorConnectStatus.initial));
  }

  void clearInterests() {
    emit(state.copyWith(interests: [], status: MentorConnectStatus.initial));
  }

  void addInterest(String value) {
    final List<String> interests = List.from(state.interests)
      ..add(value)
      ..sort();

    emit(state.copyWith(
        interests: interests, status: MentorConnectStatus.initial));
  }

  void delteInterest(String value) {
    final List<String> interests = List.from(state.interests)
      ..remove(value)
      ..sort();

    emit(state.copyWith(
        interests: interests, status: MentorConnectStatus.initial));
  }

  Future<void> register({required UserType userType}) async {
    try {
      emit(state.copyWith(status: MentorConnectStatus.submitting));
      print('User type in cubit - ${SharedPrefs().getUserType}');

      if (userType == UserType.mentee) {
        final Mentee mentee = Mentee(
          phNo: state.phNo,
          user: _authBloc.state.user,
          interests: state.interests,
          degree: state.degree,
          reason: state.reason,
        );

        await _mentorRepository.createMentee(mentee: mentee);
      } else if (SharedPrefs().getUserType == UserType.mentor) {
        final Mentor mentor = Mentor(
          user: _authBloc.state.user,
          interests: state.interests,
          degree: state.degree,
          reason: state.reason,
          website: '',
          linkedin: '',
          github: '',
          twitter: '',
          about: '',
          phNo: state.phNo,
        );

        await _mentorRepository.createMentor(mentor: mentor);
      }

      // emit(state.copyWith(status: MentorConnectStatus.succuss));
    } on Failure catch (error) {
      print('Error in registering mentee ${error.message}');
      emit(state.copyWith(
          failure: Failure(message: error.message),
          status: MentorConnectStatus.error));
    }
  }

  void loadMentee() async {
    try {
      emit(
        state.copyWith(status: MentorConnectStatus.loading),
      );
      final mentee = await _mentorRepository.getMentee(
          menteeId: _authBloc.state.user?.uid);

      print('Mentee from loaad mentee $mentee');
      emit(
        state.copyWith(
          mentee: mentee,
          interests: List.from(state.interests)
            ..addAll(mentee?.interests ?? []),
          degree: mentee?.degree,
          reason: mentee?.reason,
          phNo: mentee?.phNo,
          status: MentorConnectStatus.succuss,
        ),
      );
    } on Failure catch (error) {
      print('Error in loading mentee ${error.message}');
      emit(state.copyWith(
          status: MentorConnectStatus.error,
          failure: Failure(message: error.message)));
    }
  }

  void connect({
    required String? mentorId,
    required String? menteeId,
    required Mentee? mentee,
  }) async {
    try {
      print('THsi  russaalmlala');

      await _mentorRepository.connect(
        mentorId: mentorId,
        menteeId: menteeId,
        mentee: mentee,
      );
    } on Failure catch (error) {
      print(error.message);
    }
  }

  void deleteConnect({
    required String? mentorId,
    required String? menteeId,
    required Mentee? mentee,
  }) async {
    try {
      await _mentorRepository.deleteConnection(
          menteeId: menteeId, mentorId: mentorId, mentee: mentee);
      //emit(state.copyWith(mentee: mentee?.copyWith(connectedMentor: null)));
    } on Failure catch (error) {
      print(error.message);
    }
  }

  void loadMentor() async {
    try {
      emit(
        state.copyWith(status: MentorConnectStatus.loading),
      );
      final mentor = await _mentorRepository.getMentor(
          mentorId: _authBloc.state.user?.uid);

      print('mentor from load mentor $mentor');

      emit(
        state.copyWith(
          mentor: mentor,
          interests: List.from(state.interests)
            ..addAll(mentor?.interests ?? []),
          degree: mentor?.degree,
          reason: mentor?.reason,
          phNo: mentor?.phNo,
          status: MentorConnectStatus.succuss,
        ),
      );
    } on Failure catch (error) {
      print('Error in loading mentee ${error.message}');
      emit(state.copyWith(
          status: MentorConnectStatus.error,
          failure: Failure(message: error.message)));
    }
  }

  void loadMentorsSuggestions() async {
    try {
      //  emit(state.copyWith(status: MentorConnectStatus.loading));

      // final mentorId = await _mentorRepository.getMenteesMentorId(
      //     menteeId: _authBloc.state.user?.uid);
      // print('Mentee connected mentor id $mentorId');
      // emit(state.copyWith(isMenteeConnected: true));

      // final mentee = await _mentorRepository.getMentee(
      //     menteeId: _authBloc.state.user?.uid);

      print('Mentee from loaad mentee ${state.mentee}');
      final mentors =
          await _mentorRepository.getMentorsSugestions(mentee: state.mentee);

      print('Mentee from load mentors suggestions ${state.mentee}');

      print('Mentors suggestiosn ${await Future.wait(mentors)}');

      emit(state.copyWith(
        mentee: state.mentee,
        suggestedMentors: await Future.wait(mentors)
          ..removeWhere(
              (mentor) => mentor?.user?.uid == _authBloc.state.user?.uid),
        status: MentorConnectStatus.succuss,
        interests: List.from(state.interests)
          ..addAll(state.mentee?.interests ?? []),
        degree: state.mentee?.degree,
        reason: state.mentee?.reason,
      ));
    } on Failure catch (error) {
      print('Error in mentors suggestions ${error.toString()}');
      emit(state.copyWith(
          failure: Failure(message: error.message),
          status: MentorConnectStatus.succuss));
    }
  }

  void loadMenteesSuggestions() async {
    try {
      emit(state.copyWith(status: MentorConnectStatus.loading));

      final mentor = await _mentorRepository.getMentor(
          mentorId: _authBloc.state.user?.uid);

      print('Mentee from loaad mentee $mentor');
      final mentees =
          await _mentorRepository.getSuggestedMentee(mentor: mentor);

      print(
          'Mentee from load mentors suggestions ${await Future.wait(mentees)}');

      emit(state.copyWith(
        mentor: mentor,
        status: MentorConnectStatus.succuss,
        suggestedMentees: await Future.wait(mentees)
          ..removeWhere(
              (mentee) => mentee?.user?.uid == _authBloc.state.user?.uid),
        interests: List.from(state.interests)..addAll(mentor?.interests ?? []),
        degree: mentor?.degree,
        reason: mentor?.reason,
      ));
    } on Failure catch (error) {
      print('Error in mentors suggestions ${error.toString()}');
      emit(state.copyWith(
          failure: Failure(message: error.message),
          status: MentorConnectStatus.succuss));
    }
  }

  void connectMentor({
    required String? mentorId,
    required String? menteeId,
  }) async {
    try {
      emit(state.copyWith(status: MentorConnectStatus.loading));
      await _mentorRepository.connectMentor(
          mentorId: mentorId, menteeId: menteeId);
    } on Failure catch (error) {
      emit(state.copyWith(
          failure: Failure(message: error.message),
          status: MentorConnectStatus.error));
    }
  }
}
