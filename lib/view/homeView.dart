import 'package:cloud_firestore/cloud_firestore.dart';
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
        ),
        body: StreamBuilder(
            stream: _states.snapshots(),
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
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blue),
                            child: Center(
                                child: Text(
                              _stateData["state_name"].toString(),
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.white),
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
