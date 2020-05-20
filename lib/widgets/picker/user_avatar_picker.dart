import 'package:flutter/material.dart';

class UserAvatarPicker extends StatefulWidget {
  UserAvatarPicker(this.constraints);

  final BoxConstraints constraints;

  @override
  _UserAvatarPickerState createState() => _UserAvatarPickerState();
}

class _UserAvatarPickerState extends State<UserAvatarPicker> {
  List<Widget> _avatarList;
  PageController _pageController;

  @override
  void initState() {
    _avatarList = List.generate(
        10, (index) => buildCircleAvatar(Colors.primaries[index]));

    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.8,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: widget.constraints.maxHeight * 0.15,
        width: widget.constraints.maxHeight * 0.15,
        child: PageView(
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          children: _avatarList,
        ),
      ),
    );
  }

  Widget buildCircleAvatar(Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CircleAvatar(
        backgroundColor: color,
        child: Icon(
          Icons.person,
          size: widget.constraints.maxHeight * 0.07,
          color: Colors.white30,
        ),
      ),
    );
  }
}
