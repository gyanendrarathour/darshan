import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darshan/view/aboutPlaceView.dart';
import 'package:darshan/view/adminAboutPlaceView.dart';
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
        isScrollControlled: true,
        useSafeArea: true,
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
                        await _places
                            .doc(widget.stateId)
                            .collection("places")
                            .add({
                          'place_name': placeName,
                          'city_name': cityName,
                          'place_image': imgUrl,
                          'status': status
                        });
                        placeController.text = "";
                        cityController.text = "";
                        imgUrlController.text = "";
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
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

  Future<void> _deletePlace(DocumentSnapshot placeData) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert !!!'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('Are you sure to delete the place?')],
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
                await _places
                    .doc(widget.stateId)
                    .collection("places")
                    .doc(placeData.id)
                    .delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text('Selected Place has been deleted successfully.')));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePlace(DocumentSnapshot placeData) async {
    placeController.text = placeData['place_name'];
    cityController.text = placeData['city_name'];
    imgUrlController.text = placeData['place_image'];
    bool isSwitch = placeData['status'];

    await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
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
                          await _places
                              .doc(widget.stateId)
                              .collection("places")
                              .doc(placeData.id)
                              .update({
                            "place_name": placeController.text,
                            "city_name": cityController.text,
                            "place_image": imgUrlController.text,
                            "status": isSwitch
                          });
                          placeController.text = "";
                          cityController.text = "";
                          imgUrlController.text = "";
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
                                builder: (contaxt) => Adminaboutplaceview(
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
                                  "${_placeData["place_name"].toString()} [ ${_placeData["city_name"].toString()} ]"),
                              subtitle: _placeData["status"]
                                  ? const Text(
                                      'Active',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    )
                                  : const Text('Inactive', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        await _updatePlace(_placeData);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () async {
                                        await _deletePlace(_placeData);
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
          onPressed: () async {
            await _addPlace();
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
