import '../../domain/entities/envestment_tpye.dart';
import '../../domain/entities/investment_plan.dart';

abstract class InvestmentState {}

class InvestmentSetupState extends InvestmentState {
  final InvestorType investorType;
  InvestmentSetupState({this.investorType = InvestorType.active});
}

class InvestmentLoadingState extends InvestmentState {}

class InvestmentAllocationState extends InvestmentState {
  final InvestmentPlan investmentPlan;
  InvestmentAllocationState({required this.investmentPlan});
}

class InvestmentResultState extends InvestmentState {
  final InvestmentPlan investmentPlan;
  InvestmentResultState({required this.investmentPlan});
}
