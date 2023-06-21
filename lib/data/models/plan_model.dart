class PlanModel {
  final String id;
  final String date;
  final String name;
  final int sum;

  PlanModel({
    this.id = '',
    this.date = '',
    this.name = '',
    this.sum = 0,
  });

  static PlanModel fromJson(json) => PlanModel(
    id: json['id'] as String,
    date: json['date'] as String,
    name: json['name'] as String,
    sum: json['sum'] as int,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'name': name,
      'sum': sum.toString(),
    };
  }
}