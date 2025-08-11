import '../datasources/asset_datasource.dart';
import '../../domain/entities/envestment_tpye.dart';
import '../../domain/repository/investment_repo.dart';

class InvestmentRepositoryImpl implements InvestmentRepository {
  final AssetDataSource _dataSource = AssetDataSource();

  @override
  Future<Map<String, Asset>> getAssetData() async {
    return await _dataSource.fetchAssetData();
  }

  @override
  Future<Map<String, double>> getAllocationStrategy(InvestorType type) async {
    return await _dataSource.fetchAllocationStrategy(type);
  }
}
