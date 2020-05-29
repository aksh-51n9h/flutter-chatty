// import 'package:animations/animations.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import '../provider/authentication/auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../models/user.dart';
// import '../screens/chat_screen.dart';
// import '../screens/new_chat.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// const double _fabDimension = 56.0;

// class AllChats extends StatefulWidget {
//   AllChats({this.username, this.auth, this.logoutCallback});

//   final String username;
//   final BaseAuth auth;
//   final VoidCallback logoutCallback;
//   @override
//   _AllChatsState createState() => _AllChatsState();
// }

// class _AllChatsState extends State<AllChats> {
//   List<DocumentSnapshot> _allChats;

//   @override
//   Widget build(BuildContext context) {
//     return _buildSliver();
//   }

//   Widget _buildSliver() {
//     return Scaffold(
//       body: SafeArea(
//         child: FutureBuilder<FirebaseUser>(
//           future: FirebaseAuth.instance.currentUser(),
//           builder: (ctx, userData) {
//             if (userData.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }

//             final user = userData.data;

//             final User sender = User(
//               fullname: user.displayName,
//               email: user.email,
//               imageUrl: user.photoUrl,
//               uid: user.uid,
//               username: widget.username,
//             );

//             final String senderID = sender.uid;
//             final Firestore db = Firestore.instance;
//             final CollectionReference chatsListCollectionRef =
//                 db.collection('users/$senderID/chats_list');

//             return StreamBuilder<QuerySnapshot>(
//               stream: chatsListCollectionRef.snapshots(),
//               builder: (ctx, chatsListSnapshot) {
//                 if (chatsListSnapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 var allChats = chatsListSnapshot.data.documents;
//                 _allChats = allChats;

//                 if (allChats.length == 0) {
//                   return Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: <Widget>[
//                         Text(
//                           "Hello ${sender.username} ,\nStart a new chat",
//                           style: Theme.of(context).textTheme.headline4,
//                           textAlign: TextAlign.center,
//                         ),
//                         _buildUserActions(),
//                       ],
//                     ),
//                   );
//                 }

//                 return CustomScrollView(
//                   slivers: <Widget>[
//                     SliverAppBar(
//                       backgroundColor: Colors.black,
//                       pinned: true,
//                       title: Text(widget.username),
//                       actions: <Widget>[
//                         IconButton(
//                           icon: Icon(Icons.search),
//                           onPressed: null,
//                         ),
//                         IconButton(
//                           icon: Icon(
//                             Icons.exit_to_app,
//                             color: Theme.of(context).accentColor,
//                           ),
//                           onPressed: () {
//                             dispose();
//                             widget.auth.signOut();
//                             widget.logoutCallback();
//                           },
//                         ),
//                       ],
//                     ),
//                     SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                           (BuildContext ctx, int index) {
//                         // final DocumentReference chatDocRef =
//                         //     chatsListCollectionRef
//                         //         .document(allChats[index].documentID);

//                         var user = allChats[index];

//                         final User receiver = User(
//                           key: ValueKey(user['receiverID']),
//                           fullname: user['fullname'],
//                           username: user['username'],
//                           uid: user['receiverID'],
//                           email: user['email'],
//                           imageUrl: user['imageUrl'],
//                         );

//                         return OpenContainer(
//                           closedColor: Colors.black,
//                           transitionType: ContainerTransitionType.fade,
//                           closedBuilder: (ctx, openContainer) => ChatListTile(
//                               context: context,
//                               receiver: receiver,
//                               allChats: allChats,
//                               index: index,
//                               sender: sender,
//                               onTap: openContainer),
//                           openBuilder: (ctx, openConatiner) {
//                             return ChatScreen(
//                               sender: sender,
//                               receiver: receiver,
//                               isNewChat: false,
//                             );
//                           },
//                           tappable: false,
//                         );

//                         // return ChatListTile(
//                         //     context: context,
//                         //     receiver: receiver,
//                         //     allChats: allChats,
//                         //     index: index,
//                         //     sender: sender,
//                         //     onTap: () {
//                         //       Navigator.of(context).push(
//                         //         MaterialPageRoute(
//                         //           builder: (_) => ChatScreen(
//                         //             sender: sender,
//                         //             receiver: receiver,
//                         //             isNewChat: false,
//                         //           ),
//                         //         ),
//                         //       );
//                         //     });
//                       }, childCount: allChats.length),
//                     )
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: OpenContainer(
//         transitionType: ContainerTransitionType.fade,
//         openBuilder: (BuildContext context, VoidCallback _) {
//           return NewChat(_allChats);
//         },
//         closedElevation: 6.0,
//         closedShape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(_fabDimension / 2),
//           ),
//         ),
//         closedColor: Theme.of(context).colorScheme.secondary,
//         closedBuilder: (BuildContext context, VoidCallback openContainer) {
//           return SizedBox(
//             height: _fabDimension,
//             width: _fabDimension,
//             child: Center(
//               child: Icon(
//                 Icons.create,
//                 color: Theme.of(context).colorScheme.onSecondary,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildUserActions() {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: <Widget>[
//           FlatButton.icon(
//             icon: Icon(Icons.settings),
//             label: Text('Settings'),
//             onPressed: () {},
//           ),
//           FlatButton.icon(
//             icon: Icon(Icons.exit_to_app),
//             label: Text('Log out'),
//             onPressed: () {
//               dispose();
//               widget.auth.signOut();
//               widget.logoutCallback();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatListTile extends StatelessWidget {
//   const ChatListTile({
//     Key key,
//     @required this.context,
//     @required this.receiver,
//     @required this.allChats,
//     @required this.index,
//     @required this.sender,
//     @required this.onTap,
//   }) : super(key: key);

//   final BuildContext context;
//   final User receiver;
//   final List<DocumentSnapshot> allChats;
//   final int index;
//   final User sender;
//   final GestureTapCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListTile(
//         leading: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Theme.of(context).primaryColor,
//               width: 3,
//             ),
//           ),
//           padding: const EdgeInsets.all(4),
//           child: CircleAvatar(
//             backgroundColor: Colors.blueGrey[900],
//             child: CachedNetworkImage(
//               imageUrl: receiver.imageUrl,
//               imageBuilder: (context, imageProvider) => Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: imageProvider,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               fadeOutDuration: const Duration(seconds: 1),
//               fadeInDuration: const Duration(seconds: 1),
//               placeholder: (context, url) => CircularProgressIndicator(),
//               errorWidget: (context, url, error) => Icon(Icons.error),
//             ),
//           ),
//         ),
//         trailing: IconButton(
//           onPressed: (){},
//           icon: Icon(Icons.panorama_fish_eye),
//         ),
//         title: Text(allChats[index]['username']),
//         subtitle: Text('last message'),
//         onTap: onTap,
//       ),
//     );
//   }
// }
