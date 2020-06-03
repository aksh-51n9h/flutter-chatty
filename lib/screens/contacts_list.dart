import 'package:chatty/widgets/route/custom_page_route.dart';
import 'package:flutter/material.dart';

import './account_settings.dart';
import '../blocs/contacts_bloc.dart';
import '../models/chat.dart';
import '../models/contact.dart';
import '../models/user.dart';
import '../provider/authentication/auth.dart';
import '../provider/search/contacts_search_delegate.dart';
import '../screens/msg_screen.dart';
import '../widgets/extras/waiting.dart';

///This widget shows user all chats.
class ContactList extends StatefulWidget {
  ContactList(this.user, this.auth, this.logOutCallback);

  ///Holds an instance of user information.
  final User user;

  ///Holds an instance of authentication module.
  final Auth auth;

  ///This function is called whenever user logouts.
  final VoidCallback logOutCallback;

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  ///This holds an instance of [ContactsBloc].
  ContactsBloc _contactsBloc;

  @override
  void initState() {
    ///Instantiate [_contactsBloc].
    _contactsBloc = ContactsBloc(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Contact>>(
          stream: _contactsBloc.contactsStream,
          builder: (ctx, snapshot) {
            ///Checks whether the stream is waiting for data.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Waiting();
            }

            ///Display data when it is available.
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text('Chats'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: ContactsSearchDelegate(_contactsBloc),
                          );
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
                      ),
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
        onPressed: () {
          //TODO: Implementaion of new chat.
        },
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
        openChat(contact);
      },
    );
  }

  void openChat(Contact contact) {
    Navigator.of(context).push(
      CustomPageRoute(
        child: MessageScreen(Chat(sender: widget.user, receiver: contact)),
      ),
    );
  }

  @override
  void dispose() {
    _contactsBloc.dispose();
    super.dispose();
  }
}
