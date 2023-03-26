class FormTable {
  int id;
  String action;
  String name;
  String email;
  String image;

  FormTable({
    required this.id,
    required this.action,
    required this.name,
    required this.email,
    required this.image});

  static FormTable fromJson(json) =>
      FormTable(
          id: json['id'] as int,
          action: json['action'] as String,
          name: json['name'] as String,
          email: json['email'] as String,
          image: json['image'] as String);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id.toString(),
      'action': action,
      'name': name,
      'email': email,
      'image': image
    };
  }
}
