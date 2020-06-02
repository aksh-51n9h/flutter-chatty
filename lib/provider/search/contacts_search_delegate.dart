import 'package:chatty/blocs/contacts_bloc.dart';
import 'package:chatty/screens/empty_state_ui.dart';
import 'package:flutter/material.dart';

class ContactsSearchDelegate extends SearchDelegate {
  final ContactsBloc contactsBloc;

  ContactsSearchDelegate(this.contactsBloc);

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 1) {
      return EmptyStateUI();
    }

    List searchResult = contactsBloc.searchContact(query);

    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(searchResult[index].fullname),
          );
        },
        itemCount: searchResult.length,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length < 1) {
      return EmptyStateUI();
    }

    List searchResult = contactsBloc.searchContact(query);
    return Container(
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(searchResult[index].fullname),
            onTap: () {},
          );
        },
        itemCount: searchResult.length,
      ),
    );
  }


}
