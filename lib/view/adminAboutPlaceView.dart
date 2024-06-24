import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Adminaboutplaceview extends StatefulWidget {
  String placeName;
  String placeId;
  String? placeImage;
  String stateId;
  Adminaboutplaceview(
      {super.key,
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
  TextEditingController timingsController = TextEditingController();
  TextEditingController publicFacilitiesController = TextEditingController();
  TextEditingController aboutPlaceController = TextEditingController();
  bool isContent = false;

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
                TextFormField(
                  controller: timingsController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter the timings of this place"),
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: publicFacilitiesController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          "Enter the facilites of this place like bus, train, flight, hotels..."),
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
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
                        String timings = timingsController.text;
                        String publicFacilities =
                            publicFacilitiesController.text;
                        String aboutPlace = aboutPlaceController.text;
                        await _collectionReference
                            .doc(widget.stateId)
                            .collection("places")
                            .doc(widget.placeId)
                            .collection('about_place')
                            .add({
                          'timings': timings,
                          'publicFacilities': publicFacilities,
                          'aboutPlace': aboutPlace
                        });
                        timingsController.text = "";
                        publicFacilitiesController.text = "";
                        aboutPlaceController.text = "";
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
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
                        DocumentSnapshot _placeData =
                            snapshot.data!.docs[index];
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
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                      title: Text(
                                          _placeData["timings"].toString()),
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
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                      title: Text(
                                          _placeData["publicFacilities"].toString()),
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
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                      title: Text(
                                          _placeData["aboutPlace"].toString()),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _addDetails();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
