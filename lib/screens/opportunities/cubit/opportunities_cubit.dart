import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/repositories/opportunities/opportunities_repository.dart';
import '/models/failure.dart';
import '/models/opportunity.dart';

part 'opportunities_state.dart';

class OpportunitiesCubit extends Cubit<OpportunitiesState> {
  final AuthBloc _authBloc;
  final OpportunitiesRepository _opportunitiesRepo;
  OpportunitiesCubit({
    required AuthBloc authBloc,
    required OpportunitiesRepository opportunitiesRepository,
  })  : _authBloc = authBloc,
        _opportunitiesRepo = opportunitiesRepository,
        super(OpportunitiesState.initial());

  void loadOpportunities() async {
    try {
      emit(state.copyWith(status: OpportunitiesStatus.loading));
      final opportunities = await _opportunitiesRepo.getOpportunities();
      emit(state.copyWith(
          status: OpportunitiesStatus.succuss, opportunities: opportunities));
    } on Failure catch (failure) {
      print(failure.message);
      emit(state.copyWith(status: OpportunitiesStatus.error, failure: failure));
    }
  }

  void saveOpportunity({required String? opportunityId}) async {
    try {
      emit(state.copyWith(status: OpportunitiesStatus.loading));

      await _opportunitiesRepo.saveOpportunity(
          userId: _authBloc.state.user?.uid, opportunityId: opportunityId);
      emit(state.copyWith(status: OpportunitiesStatus.succuss));
    } on Failure catch (failure) {
      print(failure.message);
      emit(state.copyWith(status: OpportunitiesStatus.error, failure: failure));
    }
  }

  void loadSavedOpportunities() async {
    try {
      emit(state.copyWith(status: OpportunitiesStatus.loading));

      final opportunities = await _opportunitiesRepo.getUserSavedOpportunities(
          userId: _authBloc.state.user?.uid);
      emit(state.copyWith(
          status: OpportunitiesStatus.succuss, opportunities: opportunities));
    } on Failure catch (failure) {
      print(failure.message);
      emit(state.copyWith(status: OpportunitiesStatus.error, failure: failure));
    }
  }
}
