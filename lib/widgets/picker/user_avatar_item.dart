import 'package:flutter/material.dart';

///This widget is used to create user avatar with assets.
///[isSelected] decides whether the cuurent item is selected or not.
///[constraints] are required to shape the item.
///[assetPath] is required to provide user avatar image.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.isSelected,
    @required this.constraints,
    @required this.assetPath,
  }) : super(key: key);

  final bool isSelected;
  final BoxConstraints constraints;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    ///If [isSelected] value is 'true' i.e. current item is selected then [containerSize] should be bigger otherwise it should be smaller.
    final double containerSize = isSelected
        ? constraints.maxHeight * 0.11
        : constraints.maxHeight * 0.07;

        
    return Center(
      child: Container(
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
            image: AssetImage(assetPath),
          ),
        ),
      ),
    );
  }
}
