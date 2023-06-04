part of 'statistic_bloc.dart';

class StatisticState extends Equatable {
  final String dropdownValue;

  const StatisticState({
    this.dropdownValue = '1',
  });

  StatisticState copyWith({
    String? dropdownValue,
  }) {
    return StatisticState(
      dropdownValue: dropdownValue ?? this.dropdownValue,
    );
  }

  @override
// TODO: implement props
  List<Object?> get props => [dropdownValue];
}
