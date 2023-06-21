import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatelessWidget {
  final List<String> list;
  final String value;
  final String text;
  final Function(String? value) onChanged;

  const DropdownButtonWidget({
    super.key,
    required this.list,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        SizedBox(
          width: 100,
          height: 35,
          child: DropdownButton<String>(
            isExpanded: true,
            iconSize: 20,
            alignment: Alignment.center,
            value: value,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.green, fontSize: 18),
            underline: Container(
              height: 2,
              color: Colors.lightGreen,
            ),
            onChanged: onChanged,
            //     (String? value) {
            //   switch (type) {
            //     case OperationModelFormType.date:
            //       statisticBloc.add(ChangeStatisticEvent(selectedDate: value!));
            //       break;
            //     case OperationModelFormType.type:
            //       statisticBloc.add(ChangeStatisticEvent(selectedType: value!));
            //       break;
            //     case OperationModelFormType.form:
            //       statisticBloc.add(ChangeStatisticEvent(selectedForm: value!));
            //       break;
            //     case OperationModelFormType.note:
            //       statisticBloc.add(ChangeStatisticEvent(selectedNote: value!));
            //       break;
            //   }
            // },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
