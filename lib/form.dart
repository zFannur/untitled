class FeedbackForm {
  String action;
  int id;
  String name;
  String email;
  String mobileNo;
  String feedback;

  FeedbackForm({required this.action,
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.feedback});

  factory FeedbackForm.fromJson(Map<String, dynamic> json) {
    return FeedbackForm(
      action: json['action'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      mobileNo: json['mobileNo'] as String,
      feedback: json['feedback'] as String,
    );
  }

  Map<String, dynamic> _toJson(FeedbackForm instance) =>
      <String, dynamic>{
        'action': instance.action,
        'id': instance.id,
        'name': instance.name,
        'email': instance.email,
        'mobileNo': instance.mobileNo,
        'feedback': instance.feedback,
      };
