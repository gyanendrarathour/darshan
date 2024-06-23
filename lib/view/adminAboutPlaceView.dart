import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Adminaboutplaceview extends StatefulWidget {
   String placeName;
  String placeId;
  String? placeImage;
  String stateId;
  Adminaboutplaceview({super.key,
      required this.placeId,
      required this.placeName,
      this.placeImage,
      required this.stateId});

  @override
  State<Adminaboutplaceview> createState() => _AdminaboutplaceviewState();
}

class _AdminaboutplaceviewState extends State<Adminaboutplaceview> {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('states');
  TextEditingController inCityController = TextEditingController();
  TextEditingController aboutPlaceController = TextEditingController();

  Future<void> _addDetails() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TextField(
                  controller: inCityController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "What is in this city"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: aboutPlaceController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter about the place"),
                  maxLines: 5,
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
                        String inCity = inCityController.text;
                        String aboutPlace = aboutPlaceController.text;
                        await _collectionReference
                            .doc(widget.stateId)
                            .collection("places").doc(widget.placeId).collection('about_place')
                            .add({
                          'inCity': inCity,
                          'aboutPlace': aboutPlace
                        });
                        inCityController.text = "";
                        aboutPlaceController.text = "";
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'About the Place has been added successfully...')));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("About ${widget.placeName}"),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: _collectionReference
                .doc(widget.stateId)
                .collection('places')
                .doc(widget.placeId)
                .collection('about_place')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot _placeData = snapshot.data!.docs[index];
                      return GestureDetector(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all()),
                                child: Card(
                                  elevation: 10,
                                  child: Image(
                                      image: NetworkImage(
                                          widget.placeImage.toString())),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(_placeData["inCity"].toString()),
                            ),
                            ListTile(
                              title: Text(_placeData["aboutPlace"].toString()),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
            floatingActionButton: FloatingActionButton(onPressed: () async{
              await _addDetails();
            },
            child: Icon(Icons.add), backgroundColor: Colors.blue,),
      ),
    );
  }
}
