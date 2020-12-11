import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'widgets/banner.dart';
import 'widgets/link.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Facebook Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyBanner(),
              SizedBox(height: 20),
              Center(
                child: Wrap(
                  spacing: 5,
                  children: [
                    Link(
                      child: Image.network(
                        "https://img.shields.io/pub/v/flutter_facebook_auth?color=%2300b0ff&label=flutter_facebook_auth&style=flat-square",
                      ),
                      url: "https://pub.dev/packages/flutter_facebook_auth",
                    ),
                    Image.network(
                      "https://img.shields.io/github/last-commit/the-meedu-app/flutter-facebook-auth?color=%23ffa000&style=flat-square",
                    ),
                    Image.network(
                      "https://img.shields.io/github/license/the-meedu-app/flutter-facebook-auth?style=flat-square",
                    ),
                    Image.network(
                      "https://img.shields.io/github/stars/the-meedu-app/flutter-facebook-auth?style=social",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Link(
                    url: "https://www.buymeacoffee.com/meedu",
                    child: Image.network(
                      "https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png",
                      width: 200,
                    ),
                  ),
                  SizedBox(width: 4),
                  Link(
                    url: "https://www.paypal.com/paypalme/meeduapp",
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Donate with PayPal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
