import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  AccountSettings(this.user);
  final User user;
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(widget.user.uid)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final settings = snapshot.data.data;

          return Container(
            margin: const EdgeInsets.all(16),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text('Username'),
                    subtitle: Text(settings['username']),
                  );
                },
                separatorBuilder: (ctx, index) => SizedBox(),
                itemCount: 3),
          );
        });
  }
}
