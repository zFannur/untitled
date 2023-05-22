import 'package:hive/hive.dart';
part 'operation_hive.g.dart';

@HiveType(typeId: 0)
class OperationHive {
  @HiveField(0)
  int id;
  @HiveField(1)
  String action;
  @HiveField(2)
  String date;
  @HiveField(3)
  String type;
  @HiveField(4)
  String form;
  @HiveField(5)
  int sum;
  @HiveField(6)
  String note;

  OperationHive(
      {required this.id,
      required this.action,
      required this.date,
      required this.type,
      required this.form,
      required this.sum,
      required this.note});
}
