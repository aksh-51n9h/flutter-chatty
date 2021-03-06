import 'package:flutter/material.dart';

enum SearchState { RESULTS, NO_RESULTS, NOT_DETERMINED }

class SearchEmptyStateUI extends StatefulWidget {
  final SearchState searchState;

  SearchEmptyStateUI(this.searchState);

  @override
  _SearchEmptyStateUIState createState() => _SearchEmptyStateUIState();
}

class _SearchEmptyStateUIState extends State<SearchEmptyStateUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            widget.searchState == SearchState.NOT_DETERMINED
                ? Icons.search
                : Icons.error_outline,
            size: 64,
            color: Theme.of(context).disabledColor,
          ),
          Text(
            widget.searchState == SearchState.NOT_DETERMINED
                ? "Search Contacts"
                : "No Results",
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }
}
