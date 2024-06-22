import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darshan/view/adminView.dart';
import 'package:darshan/view/placesView.dart';
import 'package:flutter/material.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  final CollectionReference _states =
      FirebaseFirestore.instance.collection('states');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select State"),
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AdminVew())),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.person),
                ))
          ],
        ),
        body: StreamBuilder(
            stream: _states.where('status', isEqualTo: true).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot _stateData =
                          snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          String stateId = _stateData.id.toString();
                          String stateName =
                              _stateData["state_name"].toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacesView(
                                        stateId: stateId.toString(),
                                        stateName: stateName,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Card(
                            elevation: 10,
                            child: Center(
                                child: Center(
                                  child: Text(
                                    _stateData["state_name"].toString(),
                                    style: const TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                )),
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
      ),
    );
  }
}
