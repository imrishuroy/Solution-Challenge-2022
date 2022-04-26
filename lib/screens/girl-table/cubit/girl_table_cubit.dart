import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/discussion_comment.dart';

import '/models/discussion.dart';
import '/models/failure.dart';
import '/models/topic.dart';
import '/repositories/girl-table/girl_table_repository.dart';
part 'girl_table_state.dart';

class GirlTableCubit extends Cubit<GirlTableState> {
  final GirlTableRepository _girlTableRepository;
  final AuthBloc _authBloc;

  GirlTableCubit({
    required GirlTableRepository girlTableRepository,
    required AuthBloc authBloc,
  })  : _girlTableRepository = girlTableRepository,
        _authBloc = authBloc,
        super(GirlTableState.initial());

  void loadTopics() async {
    try {
      emit(state.copyWith(status: GirlTableStatus.loading));
      final topics = await _girlTableRepository.fetchTopics();
      emit(state.copyWith(topics: topics, status: GirlTableStatus.succuss));
    } on Failure catch (error) {
      print(error.message);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void loadDiscussions({required String? topicId}) async {
    try {
      emit(state.copyWith(status: GirlTableStatus.loading));
      final discussions =
          await _girlTableRepository.getTopicDiscussions(topicId: topicId);

      print('Discussions ---- ${await Future.wait(discussions)}');
      emit(state.copyWith(
          discussions: await Future.wait(discussions),
          status: GirlTableStatus.succuss));
    } on Failure catch (error) {
      print(error.message);
    }
  }

  void addProblemTopic(Topic? topic) async {
    emit(state.copyWith(problemTopic: topic));
  }

  void problemTitleChanged(String value) async {
    emit(state.copyWith(problemTitle: value));
  }

  void problemDescriptionChanged(String value) async {
    emit(state.copyWith(problemDescription: value));
  }

  void deleteProblemTopic() async {
    emit(state.copyWith(problemTopic: null));
  }

  void addTopicDiscussion({required Discussion discussion}) async {
    try {
      emit(state.copyWith(status: GirlTableStatus.loading));

      await _girlTableRepository.addDiscussion(discussion: discussion);
      emit(state.copyWith(status: GirlTableStatus.succuss));
    } on Failure catch (error) {
      print('Error in adding topic discussion ${error.toString()}');
      emit(
        state.copyWith(
          status: GirlTableStatus.error,
          failure: Failure(
            message: error.toString(),
          ),
        ),
      );
    }
  }

  void joinDiscussion({required Discussion? discussion}) async {
    try {
      await _girlTableRepository.joinDiscussion(
          discussion: discussion, userId: _authBloc.state.user?.uid);
    } on Failure catch (error) {
      print(error.message);
    }
  }
}
