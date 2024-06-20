import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminStateView extends StatefulWidget {
  const AdminStateView({super.key});

  @override
  State<AdminStateView> createState() => _AdminStateViewState();
}

class _AdminStateViewState extends State<AdminStateView> {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('states');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('States'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _collectionReference.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot _documentReference =
                        snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          leading: Text(
                            "${index + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          title: Text(_documentReference['state_name']),
                          subtitle: const Text('Active'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
