import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
