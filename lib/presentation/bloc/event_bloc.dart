import '../../domain/entities/envestment_tpye.dart';

abstract class InvestmentEvent {}

class CreatePlanEvent extends InvestmentEvent {
  final double initialCapital;
  final double goal;
  final InvestorType investorType;

  CreatePlanEvent({
    required this.initialCapital,
    required this.goal,
    required this.investorType,
  });
}

class NavigateToNextScreenEvent extends InvestmentEvent {}

class NavigateToPreviousScreenEvent extends InvestmentEvent {}

class ResetAppEvent extends InvestmentEvent {}

class UpdateInvestorTypeEvent extends InvestmentEvent {
  final InvestorType type;
  UpdateInvestorTypeEvent(this.type);
}
