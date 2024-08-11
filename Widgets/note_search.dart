import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteSearch extends SearchDelegate<Map<String, dynamic>> {
  final List<DocumentSnapshot> notesList;

  NoteSearch({required this.notesList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Handle the back button press
        close(context, {});
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    final suggestionList = query.isEmpty
        ? []
        : notesList
            .where((note) =>
                note['note'].toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        DocumentSnapshot document = suggestionList[index];
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        return ListTile(
          title: Text(data['note']),
          subtitle: Text(
            'Price: Rs ${data['price'].toString()}',
            style: TextStyle(color: Colors.black87),
          ),
          leading: data['image_url'] != null
              ? Image.network(
                  data['image_url'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Container(),
          trailing: ElevatedButton(
            onPressed: () {
              // Pass the entire data to the callback
              close(context, data);
            },
            child: Text('Add to Cart'),
          ),
        );
      },
    );
  }
}
