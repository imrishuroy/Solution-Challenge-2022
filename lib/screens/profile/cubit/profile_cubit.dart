import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/bloc/auth_bloc.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/profile/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthBloc _authBloc;
  final ProfileRepository _profileRepository;
  ProfileCubit(
      {required AuthBloc authBloc,
      required ProfileRepository profileRepository})
      : _authBloc = authBloc,
        _profileRepository = profileRepository,
        super(ProfileState.initial());

  void loadUserProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await _profileRepository.getUserProfile(
          userId: _authBloc.state.user?.uid);
      emit(state.copyWith(status: ProfileStatus.succuss, user: user));
    } on Failure catch (failure) {
      emit(state.copyWith(status: ProfileStatus.error, failure: failure));
    }
  }
}
