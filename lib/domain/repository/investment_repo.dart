import '../entities/envestment_tpye.dart';

abstract class InvestmentRepository {
  Future<Map<String, Asset>> getAssetData();
  Future<Map<String, double>> getAllocationStrategy(InvestorType type);
}
