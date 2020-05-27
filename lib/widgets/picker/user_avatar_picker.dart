import 'package:chatty/widgets/extras/blank.dart';
import 'package:chatty/widgets/picker/user_avatar_item.dart';
import 'package:flutter/material.dart';

class UserAvatarPicker extends StatefulWidget {
  UserAvatarPicker(this.constraints);

  final BoxConstraints constraints;

  @override
  _UserAvatarPickerState createState() => _UserAvatarPickerState();
}

class _UserAvatarPickerState extends State<UserAvatarPicker> {
  ScrollController _scrollController;
  double _offset = 0;
  bool _isAtFirst = true;
  bool _isAtLast = false;

  int currentSelection = 0;

  @override
  void initState() {
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const int numberOfItemsOnScreen = 3;
    const int totalAvatars = 5;
    final double itemSize =
        (widget.constraints.maxHeight * 0.15).floorToDouble();
    final int numberOfSpaces = (numberOfItemsOnScreen / 2).floor();

    return Center(
      child: Container(
        height: itemSize,
        width: numberOfItemsOnScreen * itemSize,
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (_offset <= _scrollController.position.maxScrollExtent) {
              if (!_isAtFirst && details.primaryVelocity > 1e-12) {
                _offset = _scrollController.offset - itemSize;
              } else if (!_isAtLast && details.primaryVelocity < 1e-12) {
                _offset = _scrollController.offset + itemSize;
              }

              _scrollController.animateTo(
                _offset,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceOut,
              );

              setState(() {
                currentSelection = (_offset / itemSize).floor();
                _isAtFirst = _offset == 0.0;
                _isAtLast = _offset >= _scrollController.position.maxScrollExtent;
              });
            }
          },
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              if (index < numberOfSpaces ||
                  index >= totalAvatars + numberOfSpaces) {
                return Blank(
                  height: itemSize,
                  width: itemSize,
                );
              }
              return UserAvatar(
                isSelected: currentSelection == index,
                constraints: widget.constraints,
                assetPath: 'assets/images/user_avatars/${index + 1}.jpg',
              );
            },
            itemCount: totalAvatars + (2 * numberOfSpaces),
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            controller: _scrollController,
            itemExtent: itemSize,
          ),
        ),
      ),
    );
  }
}
