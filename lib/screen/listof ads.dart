
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
class ListOfAds extends StatefulWidget {
  final String uid;
  const ListOfAds({super.key, required this.uid});

  @override
  State<ListOfAds> createState() => _ListOfAdsState();
}

class _ListOfAdsState extends State<ListOfAds> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String googleMapsApiKey = "AIzaSyAr7RoP6zWVDZaW6CF-aFUU9xmaYn9-dbY";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUserName(widget.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text("Loading...")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userName = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "$userName's Ads",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('approvedCollection')
                .where('Uid', isEqualTo: widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return Center(child: Text('No ads available'));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var doc = docs[index];

                  return FutureBuilder<String>(
                    future: getAddressFromCoordinates(doc['Location']),
                    builder: (context, addressSnapshot) {
                      if (!addressSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final address = addressSnapshot.data!;

                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(doc['Title'], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Table(
                                columnWidths: {
                                  0: FixedColumnWidth(100), // Label column
                                  1: FlexColumnWidth(),     // Value column
                                },
                                children: [
                                  _buildTableRow("Brand:", doc['Brand']),
                                  _buildTableRow("Category:", doc['Category']),
                                  _buildTableRow("City:", doc['City']),
                                  _buildTableRow("Condition:", doc['Condition']),
                                  _buildTableRow("Duration:", doc['Duration']),
                                  _buildTableRow("Description:", doc['Description']),
                                  _buildTableRow("Insurance:", doc['Insurance']),
                                  _buildTableRow("Address:", address),
                                ],
                              ),

                              // Text("Brand: ${doc['Brand']}"),
                              // Text("Category: ${doc['Category']}"),
                              // Text("City: ${doc['City']}"),
                              // Text("Condition: ${doc['Condition']}"),
                              // Text("Duration: ${doc['Duration']}"),
                              // Text("Address: $address"),
                              // Text("Description: ${doc['Description']}"),
                              // Text("Insurance: ${doc['Insurance']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
  // Future<String> getUserName(String uid) async {
  //   final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   if (userDoc.exists) {
  //     return userDoc.data()?['name'] ?? 'Unknown User';
  //   } else {
  //     return 'Unknown User';
  //   }
  // }
  Future<String> getUserName(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userDoc.get('Name');
  }
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            value,
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }


  Future<String> getAddressFromCoordinates(Map<String, dynamic>? location) async {
    if (location == null) {
      return 'Location not available';
    }

    final lat = location['Lat'];
    final long = location['Long'];

    if (lat == null || long == null) {
      return 'Latitude or longitude not available';
    }

    try {
      double latitude = lat is String ? double.parse(lat) : lat;
      double longitude = long is String ? double.parse(long) : long;
      String url = "https://maps.googleapis.com/maps/api/geocode/json?"
          "latlng=$latitude,$longitude&key=$googleMapsApiKey";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          String address = data['results'][0]['formatted_address'];
          return address;
        } else {
          return 'No address found for these coordinates';
        }
      } else {
        return 'Error fetching address';
      }
    } catch (e) {
      return 'Error getting address';
    }
  }

}

