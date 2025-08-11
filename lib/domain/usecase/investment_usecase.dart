import 'package:mini_investment_advisor_app/domain/entities/envestment_tpye.dart';
import 'package:mini_investment_advisor_app/domain/entities/investment_plan.dart';
import 'package:mini_investment_advisor_app/domain/repository/investment_repo.dart';

class CreateInvestmentPlanUseCase {
  final InvestmentRepository _repository;

  CreateInvestmentPlanUseCase(this._repository);

  Future<InvestmentPlan> call({
    required double initialCapital,
    required double goal,
    required InvestorType investorType,
  }) async {
    final Map<String, Asset> assets = await _repository.getAssetData();
    final Map<String, double> allocationStrategy = await _repository
        .getAllocationStrategy(investorType);

    return InvestmentPlan(
      initialCapital: initialCapital,
      goal: goal,
      investorType: investorType,
      assets: assets,
      allocation: allocationStrategy,
    );
  }
}
