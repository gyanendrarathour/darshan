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
    return Scaffold(
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
                            title: Text(_placeData["stations"].toString()),
                          ),
                          ListTile(
                            title: Text(_placeData["about"].toString()),
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
    );
  }
}
