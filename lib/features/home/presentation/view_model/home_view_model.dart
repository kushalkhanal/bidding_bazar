import 'package:bidding_bazar/features/home/presentation/view_model/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel() : super(const HomeState());

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}