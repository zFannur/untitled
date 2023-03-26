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
    const uri =
        "https://script.google.com/macros/s/AKfycbxNlbz56_uJozTrBB0yju6Bdfjm4UUNPPcF7-Y-yz0enlXL2h9jzdhkOqVu-UT5Y5ovUg/exec";

    return await http.get(Uri.parse(uri)).then((responce) {
      var jsonForm = convert.jsonDecode(responce.body) as List;
      //print(responce.body);
      //print(jsonForm[0]);
      return jsonForm.map((json) => FormTable.fromJson(json)).toList();
    });
  }

  Future<void> postForm(FormTable form) async {
    const uri =
        "https://script.google.com/macros/s/AKfycbxNlbz56_uJozTrBB0yju6Bdfjm4UUNPPcF7-Y-yz0enlXL2h9jzdhkOqVu-UT5Y5ovUg/exec";
    try {
      final url = Uri.parse(uri);

      await http.post(url, body: form.toJson()).then((response) async {
        //print(form.toJson());
        //print(response.statusCode);
        if (response.statusCode == 302) {
          var jsonResponce = convert.jsonDecode(response.body)['status'];
          print(jsonResponce);
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
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'id',
                        ),
                        controller: idController,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final form = FormTable(
                              action: 'del',
                              id: int.parse(idController.text),
                              name: 'name',
                              email: 'email',
                              image: '');
                          await postForm(form);
                          forms = await getForm();
                          setState(() {});
                        },
                        child: Text("del"),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'name',
                        ),
                        controller: nameController,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'email',
                        ),
                        controller: emailController,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final form = FormTable(
                              action: 'put',
                              id: 0,
                              name: nameController.text.toString(),
                              email: emailController.text.toString(),
                              image: 'https://kartinkived.ru/wp-content/uploads/2021/12/avatarka-dlya-vatsapa-panda-v-ochkah.jpg');
                          await postForm(form);
                          forms = await getForm();
                          setState(() {});
                        },
                        child: Text("put"),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          forms = await getForm();
                          setState(() {});
                        },
                        child: Text("get"),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            if (forms.isEmpty)
              CircularProgressIndicator()
            else
              Expanded(child: builForm(forms)),
          ],
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
          trailing: Text('id: ${form.id.toString()}'),
          leading: Image.network(form.image),
          title: Text(form.name),
          subtitle: Text(form.email),
        ),
      );
    });
