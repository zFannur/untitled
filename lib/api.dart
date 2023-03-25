import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxNlbz56_uJozTrBB0yju6Bdfjm4UUNPPcF7-Y-yz0enlXL2h9jzdhkOqVu-UT5Y5ovUg/exec";

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  // FormTable feedbackForm = FormTable(
  //   name: '1', email: '2'
  //
  // );

//   void submitForm(void Function(String) callback) async {
//     try {
//       final url = Uri.parse(URL);
//
//       await http.post(url, body: feedbackForm.toJson().toString()).then((response) async {
//         print(feedbackForm.toJson());
//         print(response.statusCode);
//         if (response.statusCode == 302) {
//           var url = response.headers['location'];
//           await http.get(url as Uri).then((response) {
//             callback(convert.jsonDecode(response.body)['status']);
//           });
//         } else {
//           callback(convert.jsonDecode(response.body)['status']);
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<List<FormTable>> getFeedbackList() async {
//     final url = Uri.parse(URL);
//     return await http.get(url).then((response) {
//       var jsonFeedback = convert.jsonDecode(response.body) as List;
//       return jsonFeedback.map((json) => FormTable.fromJson(json)).toList();
//     });
//   }
 }
