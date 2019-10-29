import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';

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
  final Spec spec = Spec(
      endpoints: {
        "get_pet": get("{{api_url}}/{{version}}/pet/{{pet_id}}"),
        "create_pet": post("{{api_url}}/{{version}}/pet"),
      },
      parameters: {
        "api_url": "https://petstore.swagger.io",
        "version": "v2",
      },
      onSend: (Request request) {
        JsonRequestMiddleware(request);
        request.set("start_time", DateTime.now().millisecondsSinceEpoch);
      },
      onReceive: (Request request, Response response) {
        int startTime = request.get("start_time");
        int endTime = DateTime.now().millisecondsSinceEpoch;
        print(
            "Request ${response.httpResponse.request.url.toString()} is completed in ${endTime - startTime} (ms)");
      });
  Map<String, dynamic> pet = Map();

  @override
  void initState() {
    super.initState();
    createPet("LaLa").then((responseOne) {
      if (responseOne.statusCode == 200) {
        Map data = json.decode(utf8.decode(responseOne.bodyBytes));
        getPet(data["id"]).then((responseTwo) {
          if (responseTwo.statusCode == 200) {
            setState(() {
              pet = json.decode(utf8.decode(responseTwo.bodyBytes));
            });
          }
        });
      }
    });
  }

  Future<Response> createPet(String name) {
    return spec.call("create_pet", onSend: (Request request) {
      request.headers.putIfAbsent("accept", () => "application/json");
      request.body = {"name": name, "status": "available"};
    });
  }

  Future<Response> getPet(int id) {
    return spec.call("get_pet", parameters: {"pet_id": "$id"});
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
              pet.toString(),
            ),
          ],
        ),
      ),
    );
  }
}
