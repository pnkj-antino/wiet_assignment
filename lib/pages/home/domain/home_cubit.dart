import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiet_assignment/pages/home/domain/home_state.dart';
import 'package:wiet_assignment/pages/home/repository/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit({required this.homeRepository})
      : super(HomeState(cats: List.empty(), tiers: const [], currentTier: ''));

  Future<void> fetchData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final catModel = await homeRepository.getData();
      if (catModel != null) {
        emit(state.copyWith(
            cats: catModel.result.cats,
            isLoading: false,
            tiers: catModel.result.tiers,
            tierPoints: catModel.result.tierPoints,
            currentTier: catModel.result.currentTier));
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
