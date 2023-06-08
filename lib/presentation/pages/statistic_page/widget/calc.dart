import 'package:easy_localization/easy_localization.dart';

import '../../../../domain/entity/operation.dart';
import '../../../bloc/statistic_bloc/statistic_bloc.dart';

class Calc {
  static List<Operation> sumNote({
    required List<Operation> operations,
    required StatisticBloc statisticBloc,
    required String form,
  }) {
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
    List<Operation> filteredOperations = [];

    for (int i = 0; i < operations.length; i++) {
      if (statisticBloc.state.selectedNote == 'пусто') {
        if (statisticBloc.state.selectedDate == 'пусто') {
          if (operations[i].form == form &&
              operations[i].type == statisticBloc.state.selectedType) {
            filteredOperations.add(operations[i]);
          }
        } else {
          if (operations[i].form == form &&
              statisticBloc.state.selectedDate ==
                  dateFormat.parse(operations[i].date).month.toString() &&
              operations[i].type == statisticBloc.state.selectedType) {
            filteredOperations.add(operations[i]);
          }
        }
      } else {
        if (statisticBloc.state.selectedDate == 'пусто') {
          if (operations[i].form == form &&
              operations[i].type == statisticBloc.state.selectedType &&
              operations[i].note == statisticBloc.state.selectedNote) {
            filteredOperations.add(operations[i]);
          }
        } else {
          if (operations[i].form == form &&
              statisticBloc.state.selectedDate ==
                  dateFormat.parse(operations[i].date).month.toString() &&
              operations[i].type == statisticBloc.state.selectedType &&
              operations[i].note == statisticBloc.state.selectedNote) {
            filteredOperations.add(operations[i]);
          }
        }
      }
    }

    return filteredOperations;
  }

  static List<FilteredOperations> sumType(
      List<Operation> operations, StatisticBloc statisticBloc) {
    List<String> filter = [];
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
    List<FilteredOperations> filteredOperations = [];
    int sum = 0;

    var uniquesNames = <String, bool>{};
    for (var s in operations) {
      uniquesNames[s.form] = true;
    }
    for (var key in uniquesNames.keys) {
      filter.add(key);
    }

    for (int i = 0; i < filter.length; i++) {
      sum = 0;
      for (int j = 0; j < operations.length; j++) {
        if (statisticBloc.state.selectedDate == 'пусто') {
          if (filter[i] == operations[j].form &&
              operations[j].type == statisticBloc.state.selectedType) {
            sum += operations[j].sum;
          }
        } else {
          if (filter[i] == operations[j].form &&
              statisticBloc.state.selectedDate ==
                  dateFormat.parse(operations[j].date).month.toString() &&
              operations[j].type == statisticBloc.state.selectedType) {
            sum += operations[j].sum;
          }
        }
      }
      filteredOperations.add(FilteredOperations(summa: sum, form: filter[i]));
    }
    return filteredOperations;
  }

  static String getSumAll(List<FilteredOperations> filteredOperations) {
    int sum = 0;
    for (int i = 0; i < filteredOperations.length; i++) {
      sum += filteredOperations[i].summa;
    }

    return sum.toString();
  }

  static String getSumOpeartions(List<Operation> filteredOperations) {
    int sum = 0;
    for (int i = 0; i < filteredOperations.length; i++) {
      sum += filteredOperations[i].sum;
    }

    return sum.toString();
  }

  static List<String> getUniValuesFromList(
      List<Operation> operations, OperationModelFormType type) {
    List<String> filter = [];
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
    var uniquesNames = <String, bool>{};
    for (var s in operations) {
      switch (type) {
        case OperationModelFormType.date:
          uniquesNames[dateFormat.parse(s.date).month.toString()] = true;
          break;
        case OperationModelFormType.type:
          uniquesNames[s.type] = true;
          break;
        case OperationModelFormType.form:
          uniquesNames[s.form] = true;
          break;
        case OperationModelFormType.note:
          uniquesNames[s.note] = true;
          break;
      }
    }
    for (var key in uniquesNames.keys) {
      filter.add(key);
    }

    return filter;
  }
}
