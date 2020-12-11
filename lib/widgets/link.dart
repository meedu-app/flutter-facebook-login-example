import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends StatelessWidget {
  final Widget child;
  final String url;
  const Link({Key key, @required this.child, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: child,
      onTap: () async {
        if (await canLaunch(url)) {
          launch(url);
        }
      },
    );
  }
}
