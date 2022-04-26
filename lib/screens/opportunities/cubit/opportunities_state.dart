part of 'opportunities_cubit.dart';

enum OpportunitiesStatus { initial, loading, succuss, error }

class OpportunitiesState extends Equatable {
  final List<Opportunity?> opportunities;
  final OpportunitiesStatus status;
  final Failure failure;

  const OpportunitiesState({
    required this.opportunities,
    required this.status,
    required this.failure,
  });

  factory OpportunitiesState.initial() => const OpportunitiesState(
        opportunities: [],
        status: OpportunitiesStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object> get props => [opportunities, status, failure];

  OpportunitiesState copyWith({
    List<Opportunity?>? opportunities,
    OpportunitiesStatus? status,
    Failure? failure,
  }) {
    return OpportunitiesState(
      opportunities: opportunities ?? this.opportunities,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() =>
      'OpportunitiesState(opportunities: $opportunities, status: $status, failure: $failure)';
}
