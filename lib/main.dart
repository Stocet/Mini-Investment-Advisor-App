import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_investment_advisor_app/data/repositories/investment_repo_impl.dart';
import 'package:mini_investment_advisor_app/presentation/bloc/bloc.dart';
import 'package:mini_investment_advisor_app/presentation/pages/home_page.dart';

void main() {
  // Use BlocProvider to provide the BLoC to the entire app
  runApp(
    BlocProvider(
      create:
          (context) => InvestmentBloc(repository: InvestmentRepositoryImpl()),
      child: const MyApp(),
    ),
  );
}
