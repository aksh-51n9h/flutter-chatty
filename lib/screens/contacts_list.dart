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
  @override
  Widget build(BuildContext context) {
    final _contactsBloc = ContactsBloc(widget.user);

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
                      ),
                      IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: null,
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
                Chat(sender: widget.user.uid, receiver: contact.receiverID)),
          ),
        );
      },
    );
  }
}
