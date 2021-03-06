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
  ///[ScrollController] that controls the swipe movement of the avatar list.
  ScrollController _scrollController;

  ///The offset of the list. Default value is '0.0'.
  double _offset = 0;

  ///Check whether first list item is slected. Default value is 'true'.
  bool _isAtFirst = true;

  ///Check whether last list item is slected. Default value is 'false'.
  bool _isAtLast = false;

  ///The current selction of the list item, where '0' is the default.
  int _currentSelection = 0;

  @override
  void initState() {
    ///Initializing scroll controller with [initialScrollOffset = _offset], where default value of [_offset] is '0.0'
    _scrollController = ScrollController(
      initialScrollOffset: _offset,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///The number of list items that will be visible on the screen.
    const int numberOfItemsOnScreen = 3;

    ///The total number of avatars.
    const int totalAvatars = 4;

    ///Dimensions of one list item.
    final double itemSize =
        (widget.constraints.maxHeight * 0.15).floorToDouble();

    ///The number of blank list item required to adjust the total number of avatars.
    final int numberOfSpaces = (numberOfItemsOnScreen / 2).floor();

    return Center(
      child: Container(
        height: itemSize,
        width: numberOfItemsOnScreen * itemSize,
        child: GestureDetector(
          ///[details] stores the drag deatils and distinguish between left swipe or right swipe.
          onHorizontalDragEnd: (details) {
            ///Checks whether list further can be scrolled or not using [_scrollController.position.maxScrollExtent].
            if (_offset <= _scrollController.position.maxScrollExtent) {
              ///If [_isAtFirst] value is 'false' i.e. the first list item is not selected then allow left swipe.
              if (!_isAtFirst && details.primaryVelocity > 1e-12) {
                _offset = _scrollController.offset - itemSize;
              }

              ///If [_isAtLast] value is 'false' i.e. the last list item is not selected then allow right swipe.
              else if (!_isAtLast && details.primaryVelocity < 1e-12) {
                _offset = _scrollController.offset + itemSize;
              }

              ///[_scrollController] moves the list with the new value of [_offset].
              _scrollController.animateTo(
                _offset,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceOut,
              );

              ///Update the [_currentSelection], [_isAtFirst] and [_isAtLast].
              setState(() {
                _currentSelection = (_offset / itemSize).floor();
                _isAtFirst = _offset == 0.0;
                _isAtLast =
                    _offset >= _scrollController.position.maxScrollExtent;
              });
            }
          },

          ///[ListView.builder] is used to build list items.
          ///[NeverScrollableScrollPhysics] is used so that list can be controlled using [GestureDetector]
          ///[itemExtent] is equal to the [itemSize]
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              if (index < numberOfSpaces) {
                return Blank(
                  height: itemSize,
                  width: itemSize,
                );
              }

              if (index >= totalAvatars + numberOfSpaces) {
                return Blank(
                  height: itemSize,
                  width: itemSize,
                );
              }

              return UserAvatar(
                ///Decides whether the current item is selected or not.
                isSelected: _currentSelection == (index-numberOfSpaces),
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
