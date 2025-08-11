import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_investment_advisor_app/domain/repository/investment_repo.dart';
import 'package:mini_investment_advisor_app/domain/usecase/investment_usecase.dart';
import 'package:mini_investment_advisor_app/presentation/bloc/event_bloc.dart';
import 'package:mini_investment_advisor_app/presentation/bloc/state_bloc.dart';

class InvestmentBloc extends Bloc<InvestmentEvent, InvestmentState> {
  final InvestmentRepository _repository;
  final CreateInvestmentPlanUseCase _createPlanUseCase;

  InvestmentBloc({required InvestmentRepository repository})
    : _repository = repository,
      _createPlanUseCase = CreateInvestmentPlanUseCase(repository),
      super(InvestmentSetupState()) {
    on<CreatePlanEvent>(_onCreatePlanEvent);
    on<UpdateInvestorTypeEvent>(_onUpdateInvestorTypeEvent);
    on<NavigateToNextScreenEvent>(_onNavigateToNextScreenEvent);
    on<NavigateToPreviousScreenEvent>(_onNavigateToPreviousScreenEvent);
    on<ResetAppEvent>(_onResetAppEvent);
  }

  void _onCreatePlanEvent(
    CreatePlanEvent event,
    Emitter<InvestmentState> emit,
  ) async {
    emit(InvestmentLoadingState());
    // Await the use case to perform the business logic
    final investmentPlan = _createPlanUseCase(
      initialCapital: event.initialCapital,
      goal: event.goal,
      investorType: event.investorType,
    );
    emit(InvestmentAllocationState(investmentPlan: await investmentPlan));
  }

  void _onUpdateInvestorTypeEvent(
    UpdateInvestorTypeEvent event,
    Emitter<InvestmentState> emit,
  ) {
    if (state is InvestmentSetupState) {
      emit(InvestmentSetupState(investorType: event.type));
    } else if (state is InvestmentAllocationState) {
      emit(
        InvestmentResultState(
          investmentPlan: (state as InvestmentAllocationState).investmentPlan,
        ),
      );
    }
  }

  void _onNavigateToNextScreenEvent(
    NavigateToNextScreenEvent event,
    Emitter<InvestmentState> emit,
  ) {
    if (state is InvestmentSetupState) {
      emit(InvestmentSetupState());
      // Logic for moving from setup to allocation is now handled by the CreatePlanEvent
      // This event is now primarily for navigating between the allocation and result screens
    } else if (state is InvestmentAllocationState) {
      emit(
        InvestmentResultState(
          investmentPlan: (state as InvestmentAllocationState).investmentPlan,
        ),
      );
    }
  }

  void _onNavigateToPreviousScreenEvent(
    NavigateToPreviousScreenEvent event,
    Emitter<InvestmentState> emit,
  ) {
    if (state is InvestmentAllocationState) {
      emit(InvestmentSetupState());
    } else if (state is InvestmentResultState) {
      emit(
        InvestmentAllocationState(
          investmentPlan: (state as InvestmentResultState).investmentPlan,
        ),
      );
    }
  }

  void _onResetAppEvent(ResetAppEvent event, Emitter<InvestmentState> emit) {
    emit(InvestmentSetupState());
  }
}
