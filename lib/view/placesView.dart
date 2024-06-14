import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darshan/view/aboutPlaceView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlacesView extends StatefulWidget {
  // int id;
  String stateName;
  String stateId;
  PlacesView({super.key, required this.stateName, required this.stateId});

  @override
  State<PlacesView> createState() => _PlacesViewState();
}

class _PlacesViewState extends State<PlacesView> {
  final CollectionReference _places =
      FirebaseFirestore.instance.collection("states");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places in ${widget.stateName}'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _places.doc(widget.stateId).collection('places').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot _placeData = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contaxt) => AboutPlaceView(
                                stateId: widget.stateId,
                                placeId: _placeData.id.toString(),
                                placeName:
                                        _placeData["place_name"].toString(),
                                placeImage:
                                        _placeData["place_image"].toString(),
                                  ))),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              _placeData['place_image'].toString()),
                        ),
                        title: Text(_placeData["place_name"].toString()),
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
