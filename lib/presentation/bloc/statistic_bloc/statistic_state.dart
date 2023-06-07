part of 'statistic_bloc.dart';

class StatisticState extends Equatable {
  final String selectedDate;
  final String selectedType;
  final String selectedNote;

  const StatisticState({
    this.selectedDate = 'пусто',
    this.selectedType = 'Расход',
    this.selectedNote = 'пусто',
  });

  StatisticState copyWith({
    String? selectedDate,
    String? selectedType,
    String? selectedForm,
    String? selectedNote,
    List<String>? uniqueDate,
  }) {
    return StatisticState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedType: selectedType ?? this.selectedType,
      selectedNote: selectedNote ?? this.selectedNote,
    );
  }

  @override
  List<Object?> get props => [selectedDate, selectedType, selectedNote];
}
