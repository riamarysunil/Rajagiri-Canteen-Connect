import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/pages/cart_page.dart';
import 'package:project/widgets/cart.dart';
import 'package:project/widgets/drawer.dart';
import 'package:project/widgets/note_search.dart';
import 'package:provider/provider.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  late List<DocumentSnapshot> filteredNotesList;

  @override
  void initState() {
    super.initState();
    filteredNotesList = [];
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              QuerySnapshot? snapshot =
                  await FirebaseFirestore.instance.collection('notes').get();

              var result = await showSearch(
                context: context,
                delegate: NoteSearch(notesList: snapshot.docs),
              );

              if (result != null && result.isNotEmpty) {
                Map<String, dynamic> data = result as Map<String, dynamic>;
                int availableQuantity = data['quantity'] ?? 0;

                if (availableQuantity > 0) {
                  cart.addItem(
                    CartItem(
                      itemName: data['note'],
                      price: data['price'],
                      availableQuantity: availableQuantity,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to Cart: ${data['note']}'),
                    ),
                  );
                } else {
                  _showUnavailableMessage(context);
                }
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = filteredNotesList.isNotEmpty
                ? filteredNotesList
                : snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                String? imageUrl = data['image_url'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(noteText),
                    subtitle: Text(
                      'Price: Rs ${data['price'].toString()}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    leading: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                    trailing: ElevatedButton(
                      onPressed: () {
                        int availableQuantity = data['quantity'] ?? 0;

                        if (availableQuantity > 0) {
                          cart.addItem(
                            CartItem(
                              itemName: noteText,
                              price: data['price'],
                              availableQuantity: availableQuantity,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to Cart: $noteText'),
                            ),
                          );
                        } else {
                          _showUnavailableMessage(context);
                        }
                      },
                      child: Text('Add to Cart'),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
      drawer: DrawerWidget(),
    );
  }

  void _showUnavailableMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item is not available.'),
      ),
    );
  }
}
