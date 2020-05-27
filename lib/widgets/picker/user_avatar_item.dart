import 'package:flutter/material.dart';

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
