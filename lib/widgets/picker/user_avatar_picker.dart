import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatarPicker extends StatefulWidget {
  UserAvatarPicker(this.constraints);

  final BoxConstraints constraints;

  @override
  _UserAvatarPickerState createState() => _UserAvatarPickerState();
}

class _UserAvatarPickerState extends State<UserAvatarPicker> {
  ScrollController _scrollController;
  double offset = 0;
  bool isAtFirst = true;
  bool isAtLast = false;

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
    final int itemSize = (widget.constraints.maxHeight * 0.15).floor();
    final int numberOfItemsOnScreen =
        (widget.constraints.maxWidth / itemSize).floor();
    final int numberOfSpaces = (numberOfItemsOnScreen / 2).floor();
    final int totalAvatars = 5;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: widget.constraints.maxHeight * 0.15,
        width: numberOfItemsOnScreen * itemSize.toDouble(),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (offset <= _scrollController.position.maxScrollExtent) {
              if (!isAtFirst && details.primaryVelocity > 1e-12) {
                offset = _scrollController.offset - itemSize;
              } else if (!isAtLast && details.primaryVelocity < 1e-12) {
                offset = _scrollController.offset + itemSize;
              }

              _scrollController.animateTo(
                offset,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceOut,
              );

              setState(() {
                currentSelection = (offset / itemSize).floor();
                isAtFirst = offset == 0.0;
                isAtLast = offset >= _scrollController.position.maxScrollExtent;
              });
            }
          },
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              if (index < numberOfSpaces) {
                return _buildSpace();
              }
              if (index >= totalAvatars + numberOfSpaces) {
                return _buildSpace();
              }
              return _buildCircleAvatar(index - numberOfSpaces);
            },
            itemCount: totalAvatars + (2 * numberOfSpaces),
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            controller: _scrollController,
            itemExtent: itemSize.toDouble(),
          ),
        ),
      ),
    );
  }

  Widget _buildSpace() {
    return Container(
      margin: const EdgeInsets.all(8),
    );
  }

  Widget _buildCircleAvatar(int i) {
    bool isSelected = currentSelection == i;
    final double containerSize = isSelected
        ? widget.constraints.maxHeight * 0.11
        : widget.constraints.maxHeight * 0.07;
    return Center(
      child: Container(
//        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(8),
        height: containerSize,
        width: containerSize,
        foregroundDecoration: !isSelected
            ? BoxDecoration(
                color: Colors.black.withAlpha(98),
                shape: BoxShape.circle,
              )
            : null,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/images/user_avatars/${i + 1}.jpg'),
          ),
        ),
      ),
    );
  }
}

class ListItem<T> {
  bool isSelected = false;
  final T data;

  ListItem({@required this.data});
}
