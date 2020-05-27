import 'package:chatty/blocs/contacts_bloc.dart';
import 'package:chatty/models/chat.dart';
import 'package:chatty/models/contact.dart';
import 'package:chatty/provider/authentication/auth.dart';
import 'package:chatty/screens/msg_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  ContactList(this.uid, this.auth, this.logOutCallback);

  final String uid;
  final Auth auth;
  final VoidCallback logOutCallback;

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    print('rebuilding contact list...');
    final _contactsBloc = ContactsBloc(widget.uid);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
                      )
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, index) {
                      return _buildContactListTile(
                        Contact.fromJson(snapshot.data.documents[index].data),
                      );
                    }, childCount: snapshot.data.documents.length),
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
                Chat(sender: widget.uid, receiver: contact.receiverID)),
          ),
        );
      },
    );
  }
}
