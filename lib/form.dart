class FormTable {
  //int id;
  String name;
  String email;

  FormTable({
    //required this.id,
    required this.name,
    required this.email});

  static FormTable fromJson(json) =>
      FormTable(
          //id: json['id'] as int,
          name: json['name'] as String,
          email: json['email'] as String);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      //'id': id,
      'name': name,
      'email': email
    };
  }
}
