import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

enum LoginType { facebook, google, apple }

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
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _fetching = true;
  User get _currentUser => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(Duration(seconds: 1));
    _fetching = false;
    setState(() {});
  }

  void _login(LoginType type) async {
    setState(() {
      _fetching = true;
    });
    OAuthCredential credential;
    if (type == LoginType.facebook) {
      credential = await _loginWithFacebook();
    } else if (type == LoginType.google) {
      credential = await _loginWithGoogle();
    }

    if (credential != null) {
      await _auth.signInWithCredential(credential);
    }

    setState(() {
      _fetching = false;
    });
  }

  Future<FacebookAuthCredential> _loginWithFacebook() async {
    try {
      final AccessToken accessToken = await FacebookAuth.instance.login();
      return FacebookAuthProvider.credential(
        accessToken.token,
      );
    } on FacebookAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<GoogleAuthCredential> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount account = await GoogleSignIn(scopes: ['email']).signIn();
      if (account != null) {
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await account.authentication;
        return GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _logOut() async {
    final List<UserInfo> data = _currentUser.providerData;
    String providerId = "firebase";
    for (final item in data) {
      if (item.providerId != "firebase") {
        providerId = item.providerId;
        break;
      }
    }
    await _auth.signOut();
    setState(() {});
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
              if (!_fetching && _currentUser == null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () => _login(LoginType.facebook),
                      color: Colors.blueAccent,
                      child: Text("FACEBOOK"),
                    ),
                    SizedBox(width: 10),
                    FlatButton(
                      onPressed: () => _login(LoginType.google),
                      color: Colors.redAccent,
                      child: Text("GOOGLE"),
                    ),
                  ],
                ),
              if (_fetching) CircularProgressIndicator(),
              if (_currentUser != null) ...[
                Text("HI ...."),
                Text(_currentUser.displayName),
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
