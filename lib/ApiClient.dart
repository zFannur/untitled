import 'dart:convert';
import 'package:http/http.dart' as http;

import 'form.dart';

const String URL =
    "https://script.google.com/macros/s/AKfycbxNlbz56_uJozTrBB0yju6Bdfjm4UUNPPcF7-Y-yz0enlXL2h9jzdhkOqVu-UT5Y5ovUg/exec";


class ApiClient {
  Future<FormTable> getForm() async {
    final response = await http
        .get(Uri.parse(URL));

    if (response.statusCode == 302) {
      return FormTable.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
