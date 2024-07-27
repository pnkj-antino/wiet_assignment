import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiet_assignment/pages/home/domain/home_cubit.dart';
import 'package:wiet_assignment/pages/home/repository/home_repository.dart';

class HomeBlocInjection extends StatelessWidget {
  final Widget child;
  const HomeBlocInjection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => HomeRepository(),
      child: BlocProvider(
        create: (context) => HomeCubit(
            homeRepository: RepositoryProvider.of<HomeRepository>(context)),
        child: child,
      ),
    );
  }
}
