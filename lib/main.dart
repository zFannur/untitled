import 'package:flutter/material.dart';

import 'api.dart';
import 'form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final post = FormController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
              ElevatedButton(
                onPressed: () {
                  post.submitForm(
                        (String response) {
                          print("Response: $response");
                          if (response == FormController.STATUS_SUCCESS) {
                            // Feedback is saved succesfully in Google Sheets.
                            print("Feedback Submitted");
                          } else {
                            // Error Occurred while saving data in Google Sheets.
                            print("Error Occurred!");
                          }
                        });
                }, child: Text('post'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ListForm()));
              }, child: Text('get'),
            ),
          ],
        ),
      ),
    );
  }
}


class ListForm extends StatefulWidget {
  const ListForm({Key? key}) : super(key: key);

  @override
  State<ListForm> createState() => _ListFormState();
}

class _ListFormState extends State<ListForm> {
  List<FeedbackForm> feedbackItems = [];

  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();

    FormController().getFeedbackList().then((feedbackItems) {
      setState(() {
        this.feedbackItems = feedbackItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: feedbackItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.person),
                  Expanded(
                    child: Text(
                        "${feedbackItems[index].name} (${feedbackItems[index].email})"),
                  )
                ],
              ),
              subtitle: Row(
                children: <Widget>[
                  Icon(Icons.message),
                  Expanded(
                    child: Text(feedbackItems[index].feedback),
                  )
                ],
              ),
            );
          },
      ),
    );
  }
}

