part of 'statistic_bloc.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();
}

class ChangeStatisticEvent extends StatisticEvent {
  final String? dropdownValue;
  const ChangeStatisticEvent({this.dropdownValue});

  @override
  List<Object?> get props => [];

}
