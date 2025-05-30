import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:rentmarketplaceadmin/screen/renters%20details.dart';

class Renters extends StatefulWidget {
  const Renters({super.key});

  @override
  State<Renters> createState() => _RentersState();
}

class _RentersState extends State<Renters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the icon color to white
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collectionGroup('Dates').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print("📡 Listening to Dates collection group...");

          if (snapshot.connectionState == ConnectionState.waiting) {
            print("⏳ Waiting for data...");
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("❌ No documents found in Dates collection group.");
            return Center(child: Text("No renters found."));
          }

          // Get all unique renters
          Map<String, List<String>> renters = {};
          snapshot.data!.docs.forEach((doc) {
            String renterId = doc['bookedBy'];
            String postUid = doc['postUid'];
            if (renters.containsKey(renterId)) {
              renters[renterId]!.add(postUid);
            } else {
              renters[renterId] = [postUid];
            }
          });

          print("🔍 Found ${renters.length} unique renters");

          if (renters.isEmpty) {
            return Center(child: Text("No renters found."));
          }

          return ResponsiveRenterList(renters: renters,);
        },
      ),
    );
  }
}

class ResponsiveRenterList extends StatelessWidget {
  final Map<String, List<String>> renters;


  ResponsiveRenterList({required this.renters,});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // Desktop layout
          return Column(
            children: [
          
          Container(
          padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Text('Total Renters: ${renters.length}'),
        // Add more renter data here if needed
        ],
        ),
        ),
              Expanded(
                child: ListView.builder(
                  itemCount: renters.length,
                  itemBuilder: (context, index) {
                    String renterId = renters.keys.elementAt(index);
                  List<String> postUids = renters[renterId]!;
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('Users').doc(renterId).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.exists) {
                          String renterName = snapshot.data!.get('Name') ?? "Unknown";
                          return RenterCard(renterName: renterName, renterId: renterId, postUids: postUids,);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
              )
            ],
          );
        } else {
          // Mobile layout
          return ListView.builder(
            itemCount: renters.length,
            itemBuilder: (context, index) {
              String renterId = renters.keys.elementAt(index);
              List<String> postUids = renters[renterId]!;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('Users').doc(renterId).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    String renterName = snapshot.data!.get('Name') ?? "Unknown";
                    return RenterCard(renterName: renterName, renterId: renterId, postUids: postUids,);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}

class RenterCard extends StatefulWidget {
  final String renterName;
  final String renterId;

  final List<String> postUids;

  RenterCard({required this.renterName, required this.renterId, required this.postUids});

  @override
  _RenterCardState createState() => _RenterCardState();
}

class _RenterCardState extends State<RenterCard> {
  String _status = 'Active';
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
             // flex: 2,
              child: Text(widget.renterName),
            ),

            SizedBox(width: 10,),
            SizedBox(
              width: 150,
              child: DropdownButton<String>(
                underline: SizedBox(),
                value: _status,
                items: ['Active', 'Suspended', 'Banned'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
            ),

            SizedBox(width: 10,),
            SizedBox(
              width: 150,
              child: TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  hintText: 'Note',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10,),
            SizedBox(

              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyPackagesDetailsPage(postUid: widget.postUids.first,

                    );}));
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Check Details',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                    )),
              ),
            ),
            SizedBox(width: 10,),
            SizedBox(

              child: GestureDetector(
                onTap: () {
                  // Save the status and note to Firestore
                  FirebaseFirestore.instance.collection('Users').doc(widget.renterId).update({
                    'status': _status,
                    'note': _noteController.text,
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}