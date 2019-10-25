import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:api_client/api_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Spec spec = Spec(endpoints: {
    "get_pet": {
      "url": "{{api_url}}/{{version}}/pet/{{pet_id}}",
      "method": "get"
    }
  }, parameters: {
    "api_url": "https://petstore.swagger.io",
    "version": "v2",
  }, onSend: (Request request) {
    request.set("start_time", DateTime.now().millisecondsSinceEpoch);
  }, onReceive: (Request request, Response response) {
    int startTime = request.get("start_time");
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Request ${response.httpResponse.request.url.toString()} is completed in ${endTime - startTime} (ms)");
  });
  Map<String, dynamic> pets = Map();

  @override
  void initState() {
    super.initState();
    spec.call("get_pet", parameters: {
      "pet_id": "3"
    }).then((Response response) {
      if (response.statusCode == 200) {
        setState(() {
          pets = json.decode(utf8.decode(response.bodyBytes));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              pets.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
