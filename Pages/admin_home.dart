import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/services/firestore.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                hintText: 'e.g., images/biriyani.jpg',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addNote(
                  textController.text,
                  imageUrlController.text,
                  double.parse(priceController.text),
                  int.parse(quantityController.text),
                );
              } else {
                Map<String, dynamic> updatedFields = {};

                if (textController.text.isNotEmpty) {
                  updatedFields['note'] = textController.text;
                }

                if (imageUrlController.text.isNotEmpty) {
                  updatedFields['image_url'] = imageUrlController.text;
                }

                if (priceController.text.isNotEmpty) {
                  updatedFields['price'] = double.parse(priceController.text);
                }

                if (quantityController.text.isNotEmpty) {
                  updatedFields['quantity'] =
                      int.parse(quantityController.text);
                }

                firestoreService.updateNoteFields(docID, updatedFields);
              }

              textController.clear();
              imageUrlController.clear();
              priceController.clear();
              quantityController.clear();

              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Items')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                String imageUrl = data['image_url'];
                double price = data['price'];
                int quantity = data['quantity'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(noteText),
                    // ignore: unnecessary_null_comparison
                    leading: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'images/placeholder.jpg', // Add a placeholder image
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price: Rs ${price.toStringAsFixed(2)}'),
                        Text('Quantity: $quantity'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteNote(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text("No Notes..");
          }
        },
      ),
    );
  }
}
