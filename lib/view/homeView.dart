import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  final CollectionReference _states = FirebaseFirestore.instance.collection('states');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select State"), centerTitle: true,),
      body: StreamBuilder(
        stream: _states.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasData){
            return ListView.builder(itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              final DocumentSnapshot _stateData = snapshot.data!.docs[index];
              return ListTile(
                title: Text(_stateData["state_name"].toString()),
              );
            });
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }),
    );
  }
}