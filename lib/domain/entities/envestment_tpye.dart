enum InvestorType { active, passive }

enum GoalStatus { met, shortfall }

/// A domain model for an investment asset.
class Asset {
  final String name;
  final double annualYield;

  Asset({required this.name, required this.annualYield});
}
