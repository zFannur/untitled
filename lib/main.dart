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
        "https://script.google.com/macros/s/AKfycbySJsChZ2hhhjSqc5V_MPdic2rSMzhBIqs1MFSHsOi_Gpxl5UKR_t-pIPHlZHSF1EQrhg/exec";

    return await http.get(Uri.parse(uri)).then((response) {
      var jsonForm = convert.jsonDecode(response.body) as List;
      //print(responce.body);
      //print(jsonForm[0]);
      return jsonForm.map((json) => FormTable.fromJson(json)).toList();
    });
  }

  Future<void> postForm(FormTable form) async {
    const uri =
        "https://script.google.com/macros/s/AKfycbySJsChZ2hhhjSqc5V_MPdic2rSMzhBIqs1MFSHsOi_Gpxl5UKR_t-pIPHlZHSF1EQrhg/exec";
    try {
      final url = Uri.parse(uri);

      await http.post(url, body: form.toJson()).then((response) async {
        //print(response.statusCode);
        if (response.statusCode == 302) {
          var urlr = Uri.parse(response.headers['location']!);
          await http.get(urlr).then((response) {
            print(convert.jsonDecode(response.body)['status']);
          });
        } else {}
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final idController = TextEditingController();
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Row(
                 children: [
                //   Expanded(
                //       child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       TextField(
                //         decoration: const InputDecoration(
                //           border: OutlineInputBorder(),
                //           labelText: 'id',
                //         ),
                //         controller: idController,
                //       ),
                //       ElevatedButton(
                //         onPressed: () async {
                //           final form = FormTable(
                //               action: 'del',
                //               id: int.parse(idController.text),
                //               name: 'name',
                //               email: 'email',
                //               image: '');
                //           await postForm(form);
                //           forms = await getForm();
                //           setState(() {});
                //         },
                //         child: Text("del"),
                //       ),
                //     ],
                //   )),
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
                              image:
                                  'https://kartinkived.ru/wp-content/uploads/2021/12/avatarka-dlya-vatsapa-panda-v-ochkah.jpg');
                          await postForm(form);
                          forms = await getForm();
                          setState(() {});
                        },
                        child: Text('put'),
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
              Expanded(
                child: ListView.builder(
                    itemCount: forms.length,
                    itemBuilder: (context, index) {
                      final form = forms[index];
                      return Card(
                        child: ListTile(
                          trailing: IconButton(
                            onPressed: () async {
                              final formDel = FormTable(
                                  action: 'del',
                                  id: form.id,
                                  name: 'name',
                                  email: 'email',
                                  image: '');
                              await postForm(formDel);
                              forms = await getForm();
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          leading: Image.network(form.image),
                          title: Text(form.name),
                          subtitle: Text(form.email),
                        ),
                      );
                    }),
              ),
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
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          leading: Image.network(form.image),
          title: Text(form.name),
          subtitle: Text(form.email),
        ),
      );
    });
