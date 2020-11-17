import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _fetching = true;

  AccessToken _accessToken;
  Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(Duration(seconds: 1));
    _accessToken = await FacebookAuth.instance.isLogged;
    if (_accessToken != null) {
      await _getUserData();
    }

    _fetching = false;
    setState(() {});
  }

  Future<void> _getUserData() async {
    _userData = await FacebookAuth.instance.getUserData(fields: "email,name,picture.width(300),birthday,friends");
  }

  Future<void> _loginWithFacebook() async {
    try {
      setState(() {
        _fetching = true;
      });
      _accessToken = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
          'user_birthday',
          'user_friends',
        ],
      );
      await _getUserData();
      setState(() {
        _fetching = false;
      });
      print(
        _accessToken.toJson(),
      );
    } catch (e, s) {
      setState(() {
        _fetching = false;
      });
      if (e is FacebookAuthException) {
        switch (e.errorCode) {
          case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
            print("FacebookAuthErrorCode.OPERATION_IN_PROGRESS");
            break;
          case FacebookAuthErrorCode.CANCELLED:
            print("FacebookAuthErrorCode.CANCELLED");
            break;

          case FacebookAuthErrorCode.FAILED:
            print("FacebookAuthErrorCode.FAILED");
            break;
        }
      }
    }
  }

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    setState(() {
      _accessToken = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_fetching && _accessToken == null)
                FlatButton(
                  onPressed: _loginWithFacebook,
                  color: Colors.blueAccent,
                  child: Text("LOGIN"),
                ),
              if (_fetching) CircularProgressIndicator(),
              if (_accessToken != null) ...[
                Text("HI ...."),
                Text(prettyPrint(_userData)),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: _logOut,
                  color: Colors.blueAccent,
                  child: Text("LOG OUT"),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
