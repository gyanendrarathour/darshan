import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darshan/view/aboutPlaceView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Adminplaceview extends StatefulWidget {
  String stateName;
  String stateId;
  Adminplaceview({super.key, required this.stateId, required this.stateName});

  @override
  State<Adminplaceview> createState() => _AdminplaceviewState();
}

class _AdminplaceviewState extends State<Adminplaceview> {
  final CollectionReference _places =
      FirebaseFirestore.instance.collection("states");

  TextEditingController placeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();

  Future<void> _addPlace() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: placeController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Place Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter City Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: imgUrlController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Image Url"),
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
                        String placeName = placeController.text;
                        String cityName = cityController.text;
                        String imgUrl = imgUrlController.text;
                        bool status = false;
                        await _places.doc(widget.stateId).collection("places").add({
                          'place_name': placeName,
                          'city_name': cityName,
                          'place_image': imgUrl,
                          'status': status
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Place has been added successfully...')));
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
          title: Text('Places in ${widget.stateName}'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream:
                _places.doc(widget.stateId).collection('places').snapshots(),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    _placeData['place_image'].toString()),
                              ),
                              title: Text(
                                  "${_placeData["place_name"].toString()} [ City ]"),
                              subtitle: const Text('Status'),
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
          onPressed: () async{ await _addPlace();},
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
