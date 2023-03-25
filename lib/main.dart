import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'form.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   List<FormTable> forms = [];

  static Future<List<FormTable>> getForm() async {

    const uri = "https://script.google.com/macros/s/AKfycbxNlbz56_uJozTrBB0yju6Bdfjm4UUNPPcF7-Y-yz0enlXL2h9jzdhkOqVu-UT5Y5ovUg/exec";

    return await http.get(Uri.parse(uri)).then((responce) {
      var jsonForm = convert.jsonDecode(responce.body) as List;
      return jsonForm.map((json) => FormTable.fromJson(json)).toList();
    });
  }

   void postForm(FormTable form) async {

     const uri = "https://script.google.com/macros/s/AKfycbxNlbz56_uJozTrBB0yju6Bdfjm4UUNPPcF7-Y-yz0enlXL2h9jzdhkOqVu-UT5Y5ovUg/exec";
     try {
      final url = Uri.parse(uri);

      await http.post(url, body: form.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url as Uri).then((response) {
            //print(convert.jsonDecode(response.body)['status']);
          });
        } else {
          //print(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
   }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  forms = await getForm();
                  setState((){});

                },
                child: Text("get"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final form = FormTable(name: 'name', email: 'email');
                  postForm(form);
                  setState((){});

                },
                child: Text("post"),
              ),
              if (forms.isEmpty)
                CircularProgressIndicator()
              else
                Container(
                  width: 400,
                  height: 400,
                    child: builForm(forms)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget builForm(List<FormTable> forms) => ListView.builder(
  itemCount: forms.length,
    itemBuilder: (context, index) {
  final form = forms[index];
  return Card(
    child: ListTile(
      title: Text(form.name),
      subtitle: Text(form.email),
    ),
  );
});
