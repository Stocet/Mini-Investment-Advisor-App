import 'envestment_tpye.dart';

class InvestmentPlan {
  final double initialCapital;
  final double goal;
  final InvestorType investorType;
  final Map<String, Asset> assets;
  final Map<String, double> allocation;

  late final Map<String, double> projectedReturns;
  late final double totalProjectedReturn;
  late final GoalStatus goalStatus;

  InvestmentPlan({
    required this.initialCapital,
    required this.goal,
    required this.investorType,
    required this.assets,
    required this.allocation,
  }) {
    // Perform calculations within the domain entity itself
    projectedReturns = _calculateProjectedReturns();
    totalProjectedReturn = _calculateTotalProjectedReturn();
    goalStatus = _determineGoalStatus();
  }
  Map<String, double> _calculateProjectedReturns() {
    final double stockReturn =
        initialCapital *
        allocation['stock']! *
        (1 + assets['stock']!.annualYield);
    final double bondReturn =
        initialCapital *
        allocation['bond']! *
        (1 + assets['bond']!.annualYield);
    final double cashReturn =
        initialCapital *
        allocation['cash']! *
        (1 + assets['cash']!.annualYield);

    return {'stock': stockReturn, 'bond': bondReturn, 'cash': cashReturn};
  }

  double _calculateTotalProjectedReturn() {
    return projectedReturns.values.fold(0, (sum, item) => sum + item);
  }

  GoalStatus _determineGoalStatus() {
    return totalProjectedReturn >= goal ? GoalStatus.met : GoalStatus.shortfall;
  }
}
