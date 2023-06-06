part of 'statistic_bloc.dart';

abstract class StatisticEvent extends Equatable {
  const StatisticEvent();
}

class ChangeStatisticEvent extends StatisticEvent {
  final String? selectedDate;
  final String? selectedType;
  final String? selectedForm;
  final String? selectedNote;

  const ChangeStatisticEvent({
    this.selectedDate,
    this.selectedType,
    this.selectedForm,
    this.selectedNote,
  });

  @override
  List<Object?> get props =>
      [selectedDate, selectedType, selectedForm, selectedNote];
}
