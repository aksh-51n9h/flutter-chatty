//import 'package:flutter/material.dart';
//
//class ChatContactListTile extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ListTile(
//      leading: CircleAvatar(
//        child: Container(
//          decoration: BoxDecoration(
//            color: Colors.grey[300],
//            shape: BoxShape.circle,
//            image: DecorationImage(
//              image: AssetImage(
//                  'assets/images/user_avatars/${contact.username.length % 4 *
//                      2 + 1}.jpg'),
//            ),
//          ),
//        ),
//      ),
//      title: Text(contact.username),
//      subtitle: Text(contact.fullname),
//      onTap: () {
//        Navigator.of(context).push(
//          MaterialPageRoute(
//            builder: (ctx) =>
//                MessageScreen(Chat(sender: widget.user, receiver: contact)),
//          ),
//        );
//      },
//    );
//  }
//}
