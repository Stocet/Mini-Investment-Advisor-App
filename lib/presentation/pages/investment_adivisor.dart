import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_investment_advisor_app/domain/entities/envestment_tpye.dart';
import 'package:mini_investment_advisor_app/domain/entities/investment_plan.dart';
import 'package:mini_investment_advisor_app/presentation/bloc/bloc.dart';
import 'package:mini_investment_advisor_app/presentation/bloc/event_bloc.dart';
import 'package:mini_investment_advisor_app/presentation/bloc/state_bloc.dart';
import 'package:mini_investment_advisor_app/presentation/widgets/peichar.dart';

class InvestmentAdvisorHome extends StatefulWidget {
  const InvestmentAdvisorHome({super.key});

  @override
  State<InvestmentAdvisorHome> createState() => _InvestmentAdvisorHomeState();
}

class _InvestmentAdvisorHomeState extends State<InvestmentAdvisorHome> {
  final TextEditingController _initialCapitalController =
      TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  @override
  void dispose() {
    _initialCapitalController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Investment Advisor'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              // Use BlocBuilder to rebuild the UI when the state changes
              child: BlocBuilder<InvestmentBloc, InvestmentState>(
                builder: (context, state) {
                  if (state is InvestmentSetupState) {
                    return _buildSetupScreen(context, state.investorType);
                  } else if (state is InvestmentLoadingState) {
                    // Show a loading indicator while the data is being fetched
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is InvestmentAllocationState) {
                    return _buildAllocationScreen(
                      context,
                      state.investmentPlan,
                    );
                  } else if (state is InvestmentResultState) {
                    return _buildResultScreen(context, state.investmentPlan);
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Screen 1: Setup ---
  Widget _buildSetupScreen(BuildContext context, InvestorType investorType) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Investment Setup',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'This plan is for a fixed duration of 1 year.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _initialCapitalController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Initial Capital (in Birr)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _goalController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Investment Goal (in Birr)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Investor Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        () => BlocProvider.of<InvestmentBloc>(
                          context,
                        ).add(UpdateInvestorTypeEvent(InvestorType.active)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          investorType == InvestorType.active
                              ? Colors.white
                              : Colors.black,
                      backgroundColor:
                          investorType == InvestorType.active
                              ? Colors.blue
                              : Colors.grey[200],
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Active'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        () => BlocProvider.of<InvestmentBloc>(
                          context,
                        ).add(UpdateInvestorTypeEvent(InvestorType.passive)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          investorType == InvestorType.passive
                              ? Colors.white
                              : Colors.black,
                      backgroundColor:
                          investorType == InvestorType.passive
                              ? Colors.blue
                              : Colors.grey[200],
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Passive'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  (_initialCapitalController.text.isNotEmpty &&
                          _goalController.text.isNotEmpty)
                      ? () => BlocProvider.of<InvestmentBloc>(context).add(
                        CreatePlanEvent(
                          initialCapital:
                              double.tryParse(_initialCapitalController.text) ??
                              0,
                          goal: double.tryParse(_goalController.text) ?? 0,
                          investorType: investorType,
                        ),
                      )
                      : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Screen 2: Allocation ---
  Widget _buildAllocationScreen(
    BuildContext context,
    InvestmentPlan investmentPlan,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Investment Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildAllocationItem(
              'Stocks',
              investmentPlan.allocation['stock']!,
              investmentPlan.assets['stock']!.name,
              investmentPlan.assets['stock']!.annualYield,
            ),
            const SizedBox(height: 16),
            _buildAllocationItem(
              'Bonds',
              investmentPlan.allocation['bond']!,
              investmentPlan.assets['bond']!.name,
              investmentPlan.assets['bond']!.annualYield,
            ),
            const SizedBox(height: 16),
            _buildAllocationItem(
              'Cash',
              investmentPlan.allocation['cash']!,
              investmentPlan.assets['cash']!.name,
              investmentPlan.assets['cash']!.annualYield,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        () => BlocProvider.of<InvestmentBloc>(
                          context,
                        ).add(NavigateToPreviousScreenEvent()),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => BlocProvider.of<InvestmentBloc>(
                          context,
                        ).add(NavigateToNextScreenEvent()),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllocationItem(
    String title,
    double percentage,
    String assetName,
    double annualYield,
  ) {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Allocation:'),
                Text(
                  '${(percentage * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Asset:'),
                Text(
                  assetName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Expected Return:'),
                Text(
                  '${(annualYield * 100).round()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Screen 3: Result ---
  Widget _buildResultScreen(
    BuildContext context,
    InvestmentPlan investmentPlan,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Investment Results',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: PieChartPainter(
                  percentages: {
                    'stock': investmentPlan.allocation['stock']!,
                    'bond': investmentPlan.allocation['bond']!,
                    'cash': investmentPlan.allocation['cash']!,
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.green, 'Stocks'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.blue, 'Bonds'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.yellow, 'Cash'),
              ],
            ),
            const SizedBox(height: 24),
            _buildReturnSummary(investmentPlan),
            const SizedBox(height: 16),
            _buildGoalStatus(investmentPlan),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        () => BlocProvider.of<InvestmentBloc>(
                          context,
                        ).add(NavigateToPreviousScreenEvent()),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        () => BlocProvider.of<InvestmentBloc>(
                          context,
                        ).add(ResetAppEvent()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Start Over'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildReturnSummary(InvestmentPlan investmentPlan) {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Projected Returns',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildReturnItem(
              'Stocks',
              investmentPlan.projectedReturns['stock']!,
            ),
            _buildReturnItem('Bonds', investmentPlan.projectedReturns['bond']!),
            _buildReturnItem('Cash', investmentPlan.projectedReturns['cash']!),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${investmentPlan.totalProjectedReturn.toStringAsFixed(2)} Birr',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnItem(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:'),
          Text(
            '${value.toStringAsFixed(2)} Birr',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalStatus(InvestmentPlan investmentPlan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            investmentPlan.goalStatus == GoalStatus.met
                ? Colors.green[50]
                : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              investmentPlan.goalStatus == GoalStatus.met
                  ? Colors.green
                  : Colors.red,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Goal Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            investmentPlan.goalStatus == GoalStatus.met
                ? 'Congratulations! Your goal of ${investmentPlan.goal.toStringAsFixed(2)} Birr was met!'
                : 'Unfortunately, your goal of ${investmentPlan.goal.toStringAsFixed(2)} Birr was not met.',
            style: TextStyle(
              color:
                  investmentPlan.goalStatus == GoalStatus.met
                      ? Colors.green[800]
                      : Colors.red[800],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
