import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darshan/view/adminPlaceView.dart';
import 'package:flutter/material.dart';

class AdminStateView extends StatefulWidget {
  const AdminStateView({super.key});

  @override
  State<AdminStateView> createState() => _AdminStateViewState();
}

class _AdminStateViewState extends State<AdminStateView> {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('states');

  TextEditingController stateController = TextEditingController();

  Future<void> _addState() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: stateController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter State Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ElevatedButton(
                      onPressed: () async {
                        String stateName = stateController.text;
                        bool status = false;
                        await _collectionReference
                            .add({'state_name': stateName, 'status': status});
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'State name has been added successfully...')));
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteState(DocumentSnapshot stateData) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert !!!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Are you sure to delete the state?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await _collectionReference.doc(stateData.id).delete();
                stateController.text = "";
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Selected State has been deleted successfully.')));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateState(DocumentSnapshot stateData) async {
    stateController.text = stateData['state_name'];
    bool isSwitch = stateData['status'];

    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: stateController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter State Name"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Switch(
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = !isSwitch;
                        });
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ElevatedButton(
                        onPressed: () async {
                          // bool status = true;
                          await _collectionReference.doc(stateData.id).update({
                            'state_name': stateController.text,
                            'status': isSwitch
                          });
                          stateController.text = "";
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'State name has been updated successfully...')));
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 20),
                        )),
                  )
                ],
              ),
            );
          });
        });
  }

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
                      child: GestureDetector(
                        onTap: () {
                          String stateName = _documentReference['state_name'];
                          String stateId = _documentReference.id;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Adminplaceview(
                                      stateId: stateId, stateName: stateName)));
                        },
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            leading: Text(
                              "${index + 1}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            title: Text(
                              _documentReference['state_name'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: _documentReference['status']
                                ? const Text(
                                    'Active',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                                : const Text(
                                    'Inactive',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await _updateState(_documentReference);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () async {
                                      await _deleteState(_documentReference);
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
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
        onPressed: () {
          _addState();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
