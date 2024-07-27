import 'package:equatable/equatable.dart';
import 'package:wiet_assignment/pages/home/models/cat_model.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => [message, isLoading];
  final String? message;
  final bool isLoading;
  final List<Cat> cats;
  final List<Tier> tiers;
  final String currentTier;
  final int tierPoints;

  const HomeState({
    this.message,
    this.isLoading = false,
    required this.cats,
    required this.tiers,
    required this.currentTier,
    this.tierPoints = 0,
  });

  HomeState initialState() {
    return const HomeState(
        isLoading: true, cats: [], tiers: [], currentTier: '', tierPoints: 0);
  }

  HomeState copyWith({
    String? message,
    bool? isLoading,
    List<Cat>? cats,
    List<Tier>? tiers,
    String? currentTier,
    int? tierPoints,
  }) {
    return HomeState(
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      cats: cats ?? this.cats,
      tiers: tiers ?? this.tiers,
      tierPoints: tierPoints ?? this.tierPoints,
      currentTier: currentTier ?? this.currentTier,
    );
  }
}

// class HomeInitialState extends HomeState {
//   const HomeInitialState() : super(isLoading: true);
// }

// class HomeLoadingState extends HomeState {
//   const HomeLoadingState() : super(isLoading: true);
// }

// class HomeSuccessState extends HomeState {
//   const HomeSuccessState({required this.message}) : super(message: message);
//   @override
//   final String message;
// }

// class HomeErrorState extends HomeState {
//   const HomeErrorState({required this.message}) : super(message: message);
//   @override
//   final String message;
// }
