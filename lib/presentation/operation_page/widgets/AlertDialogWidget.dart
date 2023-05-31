import 'package:flutter/material.dart';

class AlertDialogWidget extends StatefulWidget {
  final List<String> filter;
  final String text;
  final TextEditingController controller;
  final List<String> operationsItems;

  const AlertDialogWidget({
    Key? key,
    required this.filter,
    required this.operationsItems,
    required this.controller,
    required this.text,
  }) : super(key: key);

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 500,
        width: 300,
        child: Column(
          children: [
            const Text('Type'),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                widget.filter.clear();
                if (value.isEmpty) {
                  widget.filter.clear();
                  widget.filter.addAll(widget.operationsItems);
                }
                for (final item in widget.operationsItems) {
                  if (item.toLowerCase().contains(value.toLowerCase())) {
                    widget.filter.add(item);
                  }
                }

                setState(() {});
              },
              keyboardType: TextInputType.text,
              controller: widget.controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              height: 4,
              color: Colors.black,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.filter.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(widget.filter[index]),
                        onTap: () =>
                            Navigator.of(context).pop(widget.filter[index]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('close'),
          onPressed: () {
            Navigator.of(context).pop(widget.text);
          },
        ),
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () {
            Navigator.of(context).pop(widget.controller.text);
          },
        ),
      ],
    );
  }
}