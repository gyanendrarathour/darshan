import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AboutPlaceView extends StatefulWidget {
  String placeName;
  String placeId;
  String? placeImage;
  String stateId;
  AboutPlaceView(
      {super.key,
      required this.placeId,
      required this.placeName,
      this.placeImage,
      required this.stateId});

  @override
  State<AboutPlaceView> createState() => _AboutPlaceViewState();
}

class _AboutPlaceViewState extends State<AboutPlaceView> {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('states');

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
                      return Column(
                            children: [
                              Container(
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
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 10,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 8, 93, 241))),
                                      child: const Center(
                                          child: Text(
                                        'TIMINGS',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                      )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      child: ListTile(
                                        title:
                                            Text(_placeData["inCity"].toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 10,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 8, 93, 241))),
                                      child: const Center(
                                          child: Text(
                                        'PUBLIC FACILITIES',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                      )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      child: ListTile(
                                        title:
                                            Text(_placeData["inCity"].toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 10,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 8, 93, 241))),
                                      child: const Center(
                                          child: Text(
                                        'ABOUT THE PLACE',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                      )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      child: ListTile(
                                        title:
                                            Text(_placeData["aboutPlace"].toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
