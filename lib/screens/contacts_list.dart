import 'package:chatty/screens/account_settings.dart';

import '../blocs/contacts_bloc.dart';
import '../models/chat.dart';
import '../models/contact.dart';
import '../models/user.dart';
import '../provider/authentication/auth.dart';
import '../screens/msg_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  ContactList(this.user, this.auth, this.logOutCallback);

  final User user;
  final Auth auth;
  final VoidCallback logOutCallback;

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  ContactsBloc _contactsBloc;

  @override
  void initState() {
    _contactsBloc = ContactsBloc(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Contact>>(
          stream: _contactsBloc.contactsStream,
          builder: (ctx, snapshot) {
            // ignore: missing_return
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text('Chats'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          showSearch(context: context, delegate: null);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () {
                          widget.auth.signOut();
                          widget.logOutCallback();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (ctx) {
                              return AccountSettings(widget.user);
                            },
                          );
                        },
                      )
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      print(snapshot.data[index].receiverID);
                      return _buildContactListTile(snapshot.data[index]);
                    }, childCount: snapshot.data.length),
                  ),
                ],
              );
            }

            return Text('error');
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {},
      ),
    );
  }

  Widget _buildContactListTile(Contact contact) {
    return ListTile(
      leading: CircleAvatar(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/user_avatars/${contact.username.length % 4 * 2 + 1}.jpg'),
            ),
          ),
        ),
      ),
      title: Text(contact.username),
      subtitle: Text(contact.fullname),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => MessageScreen(
                Chat(sender: widget.user.uid, receiver: contact.receiverID)),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _contactsBloc.dispose();
    super.dispose();
  }
}
