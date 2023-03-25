import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxTw2lDk28d9BTetFiwAZD4ZfmcgEnYzMILpj575tPJMXlFsQYCpSWvHBPmtywLTh3eKQ/exec";

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  FeedbackForm feedbackForm = FeedbackForm(
    action: 'del',
    id: 5,
    name: '1', email: '2', mobileNo: '3', feedback: '4',

  );

  void submitForm(void Function(String) callback) async {
    try {
      final url = Uri.parse(URL);
      await http.post(url, body: feedbackForm.toJson()).then((response) async {
        print(feedbackForm.toJson());
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url as Uri).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<FeedbackForm>> getFeedbackList() async {
    final url = Uri.parse(URL);
    return await http.get(url).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => FeedbackForm.fromJson(json)).toList();
    });
  }
}
