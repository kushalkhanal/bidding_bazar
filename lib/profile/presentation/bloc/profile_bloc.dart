import 'package:bidding_bazar/core/usecase/usecase.dart';
import 'package:bidding_bazar/profile/domain/entities/profile_data_entity.dart';
import 'package:bidding_bazar/profile/domain/usecases/get_profile_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileData getProfileData;

  ProfileBloc({required this.getProfileData}) : super(ProfileInitial()) {
    on<FetchProfileDataEvent>(_onFetchProfileData);
  }

  void _onFetchProfileData(
      FetchProfileDataEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final failureOrData = await getProfileData(NoParams());
    emit(failureOrData.fold(
      (failure) => ProfileError(failure.message),
      (data) => ProfileLoaded(data),
    ));
  }
}