import '../../domain/entities/envestment_tpye.dart';

class AssetDataSource {
  Future<Map<String, Asset>> fetchAssetData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'stock': Asset(name: 'EthioTelecom', annualYield: 0.20),
      'bond': Asset(name: 'Ethiopian Government Bond', annualYield: 0.10),
      'cash': Asset(name: 'Birr', annualYield: 0.07),
    };
  }

  Future<Map<String, double>> fetchAllocationStrategy(InvestorType type) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (type == InvestorType.active) {
      return {'stock': 0.60, 'bond': 0.30, 'cash': 0.10};
    } else {
      return {'stock': 0.20, 'bond': 0.50, 'cash': 0.30};
    }
  }
}
