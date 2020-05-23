import 'package:flutter/cupertino.dart';
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
  ScrollController _scrollController;
  double offset = 0;

  @override
  void initState() {
    _avatarList = List.generate(7, (index) => _buildCircleAvatar(index));

    _scrollController = ScrollController();

    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.8,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int itemSize = (widget.constraints.maxHeight * 0.15).floor();
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: widget.constraints.maxHeight * 0.15,
//        width: widget.constraints.maxHeight * 0.15,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (!_scrollController.position.outOfRange) {
              if (details.primaryVelocity > 0) {
                offset = _scrollController.offset - itemSize;
              } else if (details.primaryVelocity < 0) {
                offset = _scrollController.offset + itemSize;
              }
              print((widget.constraints.maxWidth/itemSize).floor());
              _scrollController.animateTo(
                offset,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceOut,
              );
            }
          },
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            controller: _scrollController,
            children: _avatarList,
            itemExtent: itemSize*1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAvatar(int i) {
    return Center(
      child: Container(
//        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(8),
        height: widget.constraints.maxHeight * 0.11,
        width: widget.constraints.maxHeight * 0.11,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/user_avatars/${2 * i + 1}.jpg'),
          ),
        ),
      ),
    );
  }
}
