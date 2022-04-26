import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/discussion_comment.dart';
import '/models/failure.dart';
import '/repositories/girl-table/girl_table_repository.dart';

part 'commnets_state.dart';

class CommnetsCubit extends Cubit<CommnetsState> {
  final GirlTableRepository _girlTableRepository;
  final AuthBloc _authBloc;
  final String? _discussionId;

  late StreamSubscription<List<Future<DiscussionComment?>>>? _commentsSubs;

  CommnetsCubit(
      {required GirlTableRepository girlTableRepository,
      required AuthBloc authBloc,
      required String? discussionId})
      : _girlTableRepository = girlTableRepository,
        _authBloc = authBloc,
        _discussionId = discussionId,
        super(CommnetsState.initial()) {
    streamDiscussionChats();
  }

  void streamDiscussionChats() async {
    try {
      _commentsSubs = _girlTableRepository
          .streamDiscussionComments(discussionId: _discussionId)
          .listen((event) async {
        emit(state.copyWith(discussionComments: await Future.wait(event)));
      });
    } on Failure catch (error) {
      print(error.message);
      throw Failure(message: error.message);
    }
  }

  void commentChanged(String value) {
    emit(state.copyWith(comment: value, status: CommentsStatus.initial));
  }

  void sendChat() async {
    try {
      _girlTableRepository.addDiscussionChat(
        comment: DiscussionComment(
          comment: state.comment,
          discussionId: _discussionId,
          author: _authBloc.state.user,
          createdAt: DateTime.now(),
        ),
      );
    } on Failure catch (error) {
      print('Error in send chat cubit  ${error.message}');
    }
  }

  @override
  Future<void> close() {
    _commentsSubs?.cancel();

    return super.close();
  }
}
