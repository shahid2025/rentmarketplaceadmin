import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:rentmarketplaceadmin/screen/listof%20ads.dart';



class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  var address = '';
  String _selectedType = 'Data';
  String _selectedTypeoflikedrawer = 'Ads Request';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> getUserName(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(
        uid).get();
    return userDoc.get(
        'Name'); // Assuming the user name is stored in the 'name' field
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            color: Colors.blue.shade900,
            child: Column(
              children: [
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue,
                  child: const Text(
                    'Rent Market Place',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      GestureDetector(
                          onTap:(){
    setState(() {
    _selectedTypeoflikedrawer = 'Ads Request';
    });

    print('anthhing');
                          },
                          child: buildMenuItem(Icons.request_page, "Ads Request", _selectedTypeoflikedrawer == 'Ads Request' ? Colors.yellow : Colors.white,)),
                      GestureDetector(
                          onTap: (){
    setState(() {
    _selectedTypeoflikedrawer = 'Users';
    });
    print('anything');

                          },
                          child: buildMenuItem(Icons.person, "Users", _selectedTypeoflikedrawer == 'Users' ? Colors.yellow : Colors.white,)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.blue,
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10, top: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedTypeoflikedrawer == 'Ads Request' ?"Authentication":'User Data', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(icon: const Icon(Icons.help_outline, color: Colors.white), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
                                IconButton(icon: const Icon(Icons.account_circle, color: Colors.white), onPressed: () {}),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 23,),
                        _selectedTypeoflikedrawer == 'Ads Request' ?
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedType = 'Data';
                                });
                              },
                              child: Text('Data', style: TextStyle(color: _selectedType == 'Data' ? Colors.yellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                            ),
                            const SizedBox(width: 15,),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedType = 'Approved Data';
                                });
                              },
                              child: Text('Approved Data', style: TextStyle(color: _selectedType == 'Approved Data' ? Colors.yellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                            ),
                          ],
                        ):
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('User Type', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data Table',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Card(
                            elevation: 5, // Add a subtle shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // Add rounded corners
                            ),
                            color: Colors.white, // Set the card background to white
                            child:  _selectedTypeoflikedrawer == 'Ads Request'

                            ?
                            (_selectedType == 'Data'?
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9, // Take 60% of the screen height
                              width: MediaQuery.of(context).size.width * 0.8, // Take 80% of the screen width
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.80,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.08,
                                            child: const Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.08,
                                            child: const Text('Title', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.07,
                                            child: const Text('Protection', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.08,
                                            child: const Text('Images', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.07,
                                            child: const Text('Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.11,
                                            child: const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.11,
                                            child: const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          const Expanded(
                                            flex: 2,
                                            child: Text('Actions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                      const SizedBox(height: 5,),
                                      const Divider(),
                                      const SizedBox(height: 10,),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.8, // Take 40% of the screen height
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: _firestore.collection('Posts').snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(child: CircularProgressIndicator());
                                            }


                                            var docs = snapshot.data!.docs;

                                            if (docs.isEmpty) {
                                              return const Center(child: Text('No data available'));
                                            }

                                            return ListView.builder(
                                              itemCount: docs.length,
                                              itemBuilder: (context, index) {
                                                var doc = docs[index];
                                                List<dynamic> images = doc['Pictures_Url'] ?? [];
                                                int currentIndex = 0;

                                                return FutureBuilder(
                                                  future: Future.wait([
                                                  getUserName(doc['Uid']),
                                                    UserData.getAddressFromCoordinates(doc['Location']),
                                                ]),

                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {

                                                      final userName = snapshot.data![0];
                                                      final address = snapshot.data![1];
                                                      return Padding(
                                                        padding: const EdgeInsets.only(left: 2.0,right: 4,top: 4,bottom: 4),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start ,
                                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.08,
                                                              child: Text(userName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.08,
                                                              child: Text(doc['Title'], style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.065,
                                                              child: Text(doc['Insurance'], style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) {
                                                                    return StatefulBuilder(
                                                                      builder: (context, setState) {
                                                                        return AlertDialog(
                                                                          content: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  IconButton(
                                                                                    icon: const Icon(Icons.arrow_back_ios, size: 35),
                                                                                    onPressed: currentIndex > 0
                                                                                        ? () {
                                                                                      setState(() {
                                                                                        currentIndex--;
                                                                                      });
                                                                                    }
                                                                                        : null,
                                                                                  ),
                                                                                  Image.network(
                                                                                    images[currentIndex], // Directly using the URL
                                                                                    height: 300,
                                                                                    width: 500,
                                                                                    fit: BoxFit.contain,
                                                                                    loadingBuilder: (context, child, loadingProgress) {
                                                                                      print(images[currentIndex]);
                                                                                      if (loadingProgress == null) return child;
                                                                                      return const Center(child: CircularProgressIndicator());
                                                                                    },
                                                                                    errorBuilder: (context, error, stackTrace) {
                                                                                      return const Center(child: Text('Image failed to load', style: TextStyle(color: Colors.red)));
                                                                                    },
                                                                                  ),

                                                                                  IconButton(
                                                                                    icon: const Icon(Icons.arrow_forward_ios, size: 35),
                                                                                    onPressed: currentIndex < images.length - 1
                                                                                        ? () {
                                                                                      setState(() {
                                                                                        currentIndex++;
                                                                                      });
                                                                                    }
                                                                                        : null,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.08,
                                                                child: const Text(
                                                                  'View Images',
                                                                  style: TextStyle(fontSize: 12, color: Colors.blue),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 3.0),
                                                              child: SizedBox(
                                                                  width: MediaQuery.of(context).size.width * 0.06,
                                                                  child: Text(doc['Price'])),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.11,
                                                                child: Text(address,style: const TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,)), // Display the address here
                                                            SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.11,
                                                                child: Text(doc['Description'],style: const TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,)),
                                                            Expanded(
                                                              flex:3,

                                                              child: Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      var data = doc.data();

                                                                      if (data is Map<String, dynamic>) {
                                                                        _approveData(doc.id, data);
                                                                      } else {
                                                                        print("Data is not in the expected format");
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      height: 25,
                                                                      width: 70,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.blue,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: const Text(
                                                                        'Approve',
                                                                        style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 20,),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      var data = doc.data();
                                                                      if (data is Map<String, dynamic>) {
                                                                        _showDeleteReasonDialog(context, doc.id, data);
                                                                      }
                                                                     // _deleteDataFromPost(doc.id);
                                                                    },
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      height: 25,
                                                                      width: 70,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.red,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: const Text(
                                                                        'Delete',
                                                                        style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      return const Center(child: CircularProgressIndicator());
                                                    }
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ):
                                SizedBox(
                                  height: 200,
                                  width:double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.80,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.08,
                                                child: const Text('Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.08,
                                                child: const Text('Title', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.07,
                                                child: const Text('Protection', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.08,
                                                child: const Text('Images', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.07,
                                                child: const Text('Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ),

                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.15,
                                                child: const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.15,
                                                child: const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        const Divider(),
                                        const SizedBox(height: 10,),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.5,
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: _firestore.collection('approvedCollection').snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(child: CircularProgressIndicator());
                                              }

                                              var docs = snapshot.data!.docs;

                                              if (docs.isEmpty) {
                                                return const Center(child: Text('No data available'));
                                              }

                                              return ListView.builder(
                                                itemCount: docs.length,
                                                itemBuilder: (context, index) {
                                                  var doc = docs[index];

                                                  List<dynamic> images = doc['Pictures_Url'] ?? [];
                                                  int currentIndex = 0;

                                                  return FutureBuilder(
                                                    future: Future.wait([
                                                      getUserName(doc['Uid']),
                                                      UserData.getAddressFromCoordinates(doc['Location']),
                                                    ]),

                                                    builder: (context, snapshot) {
                                                      if (snapshot.hasData) {

                                                        final userName = snapshot.data![0];
                                                        final address = snapshot.data![1];
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 2.0,right: 4,top: 4,bottom: 4),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start ,
                                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.08,
                                                                child: Text(userName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.08,
                                                                child: Text(doc['Title'], style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.065,
                                                                child: Text(doc['Insurance'], style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (context) {
                                                                      return StatefulBuilder(
                                                                        builder: (context, setState) {
                                                                          return AlertDialog(
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    IconButton(
                                                                                      icon: const Icon(Icons.arrow_back_ios, size: 35),
                                                                                      onPressed: currentIndex > 0
                                                                                          ? () {
                                                                                        setState(() {
                                                                                          currentIndex--;
                                                                                        });
                                                                                      }
                                                                                          : null,
                                                                                    ),
                                                                                    Image.network(
                                                                                      images[currentIndex], // Directly using the URL
                                                                                      height: 300,
                                                                                      width: 500,
                                                                                      fit: BoxFit.contain,
                                                                                      loadingBuilder: (context, child, loadingProgress) {
                                                                                        print(images[currentIndex]);
                                                                                        if (loadingProgress == null) return child;
                                                                                        return const Center(child: CircularProgressIndicator());
                                                                                      },
                                                                                      errorBuilder: (context, error, stackTrace) {
                                                                                        return const Center(child: Text('Image failed to load', style: TextStyle(color: Colors.red)));
                                                                                      },
                                                                                    ),

                                                                                    IconButton(
                                                                                      icon: const Icon(Icons.arrow_forward_ios, size: 35),
                                                                                      onPressed: currentIndex < images.length - 1
                                                                                          ? () {
                                                                                        setState(() {
                                                                                          currentIndex++;
                                                                                        });
                                                                                      }
                                                                                          : null,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(context).size.width * 0.08,
                                                                  child: const Text(
                                                                    'View Images',
                                                                    style: TextStyle(fontSize: 12, color: Colors.blue),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 3.0),
                                                                child: SizedBox(
                                                                    width: MediaQuery.of(context).size.width * 0.06,
                                                                    child: Text(doc['Price'])),
                                                              ),
                                                            SizedBox(
                                                                  width: MediaQuery.of(context).size.width * 0.15,
                                                                  child: Text(doc['Description'],style: const TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,)),
                                                              SizedBox(
                                                                  width: MediaQuery.of(context).size.width * 0.15,
                                                                  child: Text(address,style: const TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,)), // Display the address here

                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return const Center(child: CircularProgressIndicator());
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        )


                                      ],
                                    ),
                                  ),
                                ))
                                :
                         UserData(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title,Color color1) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: color1, fontSize: 16)),

    );
  }
  void _showDeleteReasonDialog(BuildContext context, String postId, Map<String, dynamic> data) {
    final TextEditingController _reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reject Ad"),
          content: TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: "Enter reason for rejection",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String reason = _reasonController.text.trim();

                if (reason.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please enter a reason",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                data['status'] = 'rejected';
                data['rejectionReason'] = reason;

                try {
                  await _firestore.collection('rejectedCollection').doc(postId).set(data);
                  await _firestore.collection('Posts').doc(postId).delete();

                  Fluttertoast.showToast(
                    msg: "Ad rejected and deleted",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  Navigator.of(context).pop(); // Close dialog
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Error deleting ad",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }


  void _approveData(String id, Map<String, dynamic> data) {
    data['status'] = 'approved';
    data['rejectionReason'] = '';

    _firestore.collection('approvedCollection').doc(id).set(data).then((_) {
      Fluttertoast.showToast(
        msg: "Data approved successfully.",
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
      _deleteDataFromPost(id);
    }).catchError((error) {
      print("Error approving data: $error");
    });
  }

  void _deleteData(String id) {
    _firestore.collection('approvedCollection').doc(id).delete();
  }
  void _deleteDataFromPost(String id) {
    _firestore.collection('Posts').doc(id).delete().then((_) {
      print("Data deleted successfully from Posts.");
      Fluttertoast.showToast(msg: "Data deleted successfully from Posts.",
          backgroundColor: Colors.blue,textColor: Colors.white);
    }).catchError((error) {
      print("Error deleting data: $error");
    });
  }

  // void _approveData(String id, Map<String, dynamic> data) {
  //   print("Approving data with ID: $id"); // Debugging line
  //
  //   _firestore.collection('approvedCollection').doc(id).set(data).then((_) {
  //     print("Data approved successfully."); // Debugging line
  //     Fluttertoast.showToast(msg: "Data approved successfully.",
  //         backgroundColor: Colors.blue,textColor: Colors.white);
  //    _deleteDataFromPost(id);
  //   }).catchError((error) {
  //     print("Error approving data: $error");
  //   });
  // }

}




class UserData extends StatelessWidget {
  UserData({super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   static String googleMapsApiKey = "AIzaSyAr7RoP6zWVDZaW6CF-aFUU9xmaYn9-dbY";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.72, // Take 70% of the screen width
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
                 // SizedBox(width: .2,),
                  Text('Address', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
                // SizedBox(width: 1,),
                  Text('Description', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('Totals ads', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('Images', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('Ads', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('Price', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('Protection plan', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5,),
          const Divider(),
          const SizedBox(height: 10,),
          SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.8, // Take 40% of the screen height
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('approvedCollection').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    List<dynamic> images = doc['Pictures_Url'] ?? [];
                    int currentIndex = 0;

                    return FutureBuilder(
                      future: Future.wait([
                        getUserName(doc['Uid']),
                        getAddressFromCoordinates(doc['Location']),
                      ]),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final userName = snapshot.data![0];
                        final address = snapshot.data![1];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2, // Adjust flex values for better spacing
                                child: Text(userName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                              ),
                              Expanded(
                                flex: 2, // More space for address
                                child: Text(
                                  address,
                                  style: const TextStyle(fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 30,),

                              Expanded(
                                flex: 2,
                                child: Text(doc['Description'], style: const TextStyle(fontSize: 12)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(docs.length.toString(), style: const TextStyle(fontSize: 12)),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.arrow_back_ios, size: 35),
                                                      onPressed: currentIndex > 0
                                                          ? () {
                                                        setState(() {
                                                          currentIndex--;
                                                        });
                                                      }
                                                          : null,
                                                    ),
                                                    Image.network(
                                                      images[currentIndex], // Directly using the URL
                                                      height: 300,
                                                      width: 500,
                                                      fit: BoxFit.contain,
                                                      loadingBuilder: (context, child, loadingProgress) {
                                                        print(images[currentIndex]);
                                                        if (loadingProgress == null) return child;
                                                        return const Center(child: CircularProgressIndicator());
                                                      },
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Center(child: Text('Image failed to load', style: TextStyle(color: Colors.red)));
                                                      },
                                                    ),

                                                    IconButton(
                                                      icon: const Icon(Icons.arrow_forward_ios, size: 35),
                                                      onPressed: currentIndex < images.length - 1
                                                          ? () {
                                                        setState(() {
                                                          currentIndex++;
                                                        });
                                                      }
                                                          : null,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.08,
                                  child: const Text(
                                    'View Images',
                                    style: TextStyle(fontSize: 12, color: Colors.blue),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ListOfAds(uid: doc['Uid'])),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12)
                                            ,color: Colors.blue,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(doc['Title'], style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white)),
                                      )),
                                ),
                              ),
                                SizedBox(width: MediaQuery.of(context).size.height*.15,),

                              Expanded(
                                flex: 2,
                                child: Text('\$${doc['Price']}', style: const TextStyle(fontSize: 12)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(doc['Insurance'], style: const TextStyle(fontSize: 12)),
                              ),
                              const SizedBox(width: 10,)
                            ],
                          )

                        );
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<String> getUserName(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(
        uid).get();
    return userDoc.get(
        'Name'); // Assuming the user name is stored in the 'name' field
  }





  static Future<String> getAddressFromCoordinates(Map<String, dynamic>? location) async {
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


