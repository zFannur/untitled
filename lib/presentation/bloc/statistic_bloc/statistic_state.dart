part of 'statistic_bloc.dart';

class StatisticState extends Equatable {
  final String selectedDate;
  final String selectedType;
  final String selectedForm;
  final String selectedNote;

  const StatisticState({
    this.selectedDate = '1',
    this.selectedType = 'Расход',
    this.selectedForm = '1',
    this.selectedNote = '1',
  });

  StatisticState copyWith({
    String? selectedDate,
    String? selectedType,
    String? selectedForm,
    String? selectedNote,
  }) {
    return StatisticState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedType: selectedType ?? this.selectedType,
      selectedForm: selectedForm ?? this.selectedForm,
      selectedNote: selectedNote ?? this.selectedNote,
    );
  }

  @override
  List<Object?> get props => [selectedDate, selectedType, selectedForm, selectedNote];
}
