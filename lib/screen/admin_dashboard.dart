import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:rentmarketplaceadmin/screen/alluser%20data.dart';
import 'package:rentmarketplaceadmin/screen/file%20claim%20data.dart';
import 'package:rentmarketplaceadmin/screen/listof%20ads.dart';
import 'package:rentmarketplaceadmin/screen/renters.dart';
import 'package:rentmarketplaceadmin/screen/status%20screen.dart';

import 'analytics/analytics dashboard.dart';



class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  var address = '';
  String _selectedType = 'Data';
  String _selectedTypeUser = 'User Type';
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
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FileClaimData()),
                            );
    // setState(() {
    // _selectedTypeoflikedrawer = 'File Claim';
    // });
    // print('anything');

                          },
                          child: buildMenuItem(Icons.person, "File Claim", _selectedTypeoflikedrawer == 'File Claim' ? Colors.yellow : Colors.white,)),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Renters()),
                            );},
                          child: buildMenuItem(Icons.remove_shopping_cart, "Renters", _selectedTypeoflikedrawer == 'Renters' ? Colors.yellow : Colors.white,)),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminPaymentDashboard()),
                            );},
                          child: buildMenuItem(Icons.dashboard, "PaymentStatusScreen", _selectedTypeoflikedrawer == 'PaymentStatusScreen' ? Colors.yellow : Colors.white,)),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DashboardScreen()),
                            );},
                          child: buildMenuItem(Icons.dashboard, "DashboardScreen", _selectedTypeoflikedrawer == 'DashboardScreen' ? Colors.yellow : Colors.white,)),
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
                        Row(
                          children: [
                             GestureDetector(
                               onTap:(){
                                 setState(() {
                                   _selectedTypeUser = 'Owner';
                                 });
                  },
                               child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Owner', style: TextStyle(color: _selectedTypeUser == 'Owner' ? Colors.yellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                             ),
                            const SizedBox(width: 15,),
                             GestureDetector(
                               onTap: (){
                                 setState(() {
                                   _selectedTypeUser = 'unapproved ads';
                                 });
                               },
                               child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('unapproved ads', style: TextStyle(color:_selectedTypeUser == 'unapproved ads' ? Colors.yellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                             ),
                            const SizedBox(width: 15,),
                             GestureDetector(
                               onTap: (){
                                 setState(() {
                                   _selectedTypeUser = 'All Users';
                                 });
                               },
                               child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('All Users', style: TextStyle(color:_selectedTypeUser == 'All Users' ? Colors.yellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                             ),
                          ],
                        )
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
                        // const Text(
                        //   'Data Table',
                        //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(height: 16),
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
                                            width: MediaQuery.of(context).size.width * 0.16,
                                            child: const Text('Address', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.11,
                                            child: const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                          ),
                                          const Expanded(
                                            flex: 1,
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

                                            return   ListView.builder(
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

                                                      // Safe access to IsPaymentApproved
                                                      final data = doc.data() as Map<String, dynamic>;
                                                      bool isPaymentApproved = data.containsKey('IsPaymentApproved') ? data['IsPaymentApproved'] : false;

                                                      return Padding(
                                                        padding: const EdgeInsets.all(4.0),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
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

                                                            // View Images
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
                                                                                    images[currentIndex],
                                                                                    height: 300,
                                                                                    width: 500,
                                                                                    fit: BoxFit.contain,
                                                                                    loadingBuilder: (context, child, loadingProgress) {
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
                                                                width: MediaQuery.of(context).size.width * 0.05,
                                                                child: Text(doc['Price']),
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              width: MediaQuery.of(context).size.width * 0.15,
                                                              child: Text(address, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
                                                            ),

                                                            Container(
                                                              alignment:Alignment.center,
                                                              width: MediaQuery.of(context).size.width * 0.10,
                                                              child: Text(doc['Description'], style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
                                                            ),

                                                            Expanded(
                                                              flex: 3,
                                                              child: Row(
                                                                children: [
                                                                  // Approve if no insurance
                                                                    InkWell(
                                                                      onTap: () {
                                                                        if (data is Map<String, dynamic>) {
                                                                          _approveData(doc.id, data);
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        height: 20,
                                                                        width: 50,
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.blue,
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        child: const Text(
                                                                          'Approve',
                                                                          style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
SizedBox(width: 2,),

                                                                  // Payment verification if insurance is yes and not approved
                                                                  if (doc['Insurance'] == 'Yes' && !isPaymentApproved) ...[
                                                                    InkWell(
                                                                      onTap: () {
                                                                        _approvePayment(doc.id);
                                                                      },
                                                                      child: Container(
                                                                        alignment: Alignment.center,
                                                                        height: 20,
                                                                        width: 70,
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.green,
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        child: const Text(
                                                                          'Payment Verify',
                                                                          style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],

                                                                 const SizedBox(width: 2),

                                                                  // Delete button
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (data is Map<String, dynamic>) {
                                                                        _showDeleteReasonDialog(context, doc.id, data, 'Posts');
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      height: 20,
                                                                      width: 47,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.red,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: const Text(
                                                                        'Delete',
                                                                        style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
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
                              height: 600, // Adjust as needed
                              child: StreamBuilder<QuerySnapshot>(
                                stream: _firestore.collection('approvedCollection').snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  final docs = snapshot.data!.docs;

                                  if (docs.isEmpty) {
                                    return const Center(child: Text('No data available'));
                                  }

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('Title')),
                                        DataColumn(label: Text('Protection')),
                                        DataColumn(label: Text('Images')),
                                        DataColumn(label: Text('Price')),
                                        DataColumn(label: Text('Market Value')),
                                        DataColumn(label: Text('Description')),
                                        DataColumn(label: Text('Delete')),
                                        DataColumn(label: Text('Location')),
                                      ],
                                      rows: docs.map((doc) {
                                        final images = doc['Pictures_Url'] ?? [];

                                        return DataRow(
                                          cells: [
                                            DataCell(FutureBuilder(
                                              future: getUserName(doc['Uid']),
                                              builder: (context, snapshot) {
                                                return Text(snapshot.data?.toString() ?? 'Loading...');
                                              },
                                            )),
                                            DataCell(Text(doc['Title'].toString())),
                                            DataCell(Text(doc['Insurance'].toString())),
                                            DataCell(
                                              InkWell(
                                                onTap: () {
                                                  int currentIndex = 0;
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
                                                                      icon: const Icon(Icons.arrow_back_ios),
                                                                      onPressed: currentIndex > 0
                                                                          ? () => setState(() => currentIndex--)
                                                                          : null,
                                                                    ),
                                                                    Image.network(
                                                                      images[currentIndex],
                                                                      height: 300,
                                                                      width: 500,
                                                                      fit: BoxFit.contain,
                                                                      loadingBuilder: (context, child, progress) =>
                                                                      progress == null ? child : const CircularProgressIndicator(),
                                                                      errorBuilder: (context, error, stackTrace) =>
                                                                      const Text('Image failed to load', style: TextStyle(color: Colors.red)),
                                                                    ),
                                                                    IconButton(
                                                                      icon: const Icon(Icons.arrow_forward_ios),
                                                                      onPressed: currentIndex < images.length - 1
                                                                          ? () => setState(() => currentIndex++)
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
                                                child: const Text(
                                                  'View Images',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(Text('\$${doc['Price']}/${doc['Duration']}')),
                                            DataCell(Text(doc['Market Value'].toString())),
                                            DataCell(
                                              SizedBox(
                                                width:200,
                                                child: Text(
                                                  doc['Description'].toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                ),
                                                onPressed: () {
                                                  final data = doc.data();
                                                  if (data is Map<String, dynamic>) {
                                                    _showDeleteReasonDialog(context, doc.id, data, 'approvedCollection');
                                                  }
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(fontSize: 10, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              FutureBuilder(
                                                future: UserData.getAddressFromCoordinates(doc['Location']),
                                                builder: (context, snapshot) {
                                                  return Text(snapshot.data?.toString() ?? 'Loading...');
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            )


                            )
                                :(_selectedTypeUser=='Owner'?UserData()
                                :_selectedTypeUser=='unapproved ads'?unapprovedAds():
                                _selectedTypeUser=='All Users'  ? AllUsersData():
                                Container(child: Center(child: Text("No Data")))
                            )
                            // (_selectedTypeUser=='User Type'
                            // ? UserData() : unapprovedAds())
                         //UserData(),
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
  Widget _headerCell(String title, double width) {
    return SizedBox(
      width: width,
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _dataCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _linkCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.blue),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title,Color color1) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: color1, fontSize: 16)),

    );
  }
  void _showDeleteReasonDialog(
      BuildContext context, String postId, Map<String, dynamic> data,
      String sourceCollection,
      ) {
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
                  await _firestore.collection(sourceCollection).doc(postId).delete();

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
    // if (data['Insurance'] == 'Yes') {
    //   data['paymentStatusMessage'] = 'Your payment is remaining';
    //
    //   _firestore.collection('pendingPaymentVerificationCollection').doc(id).set(data).then((_) {
    //     Fluttertoast.showToast(
    //       msg: "Data moved to pending payment verification.",
    //       backgroundColor: Colors.orange,
    //       textColor: Colors.white,
    //     );
    //   }).catchError((error) {
    //     print("Error moving data to pending payment verification: $error");
    //   });
    //   return;
    // }
    //
    // // Proceed with approval if insurance is not "Yes"
    // data['status'] = 'approved';
    // data['rejectionReason'] = ''; // Clear rejection reason if it is exists

    _firestore.collection('approvedCollection').doc(id).set(data, SetOptions(merge: true)).then((_) {
      print("Data successfully approved and moved to approvedCollection!");
      Fluttertoast.showToast(
                msg: "Data moved to pending payment verification.",
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              );
      // ✅ Delete from Posts after moving
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
  Future<void> _approvePayment(String postId) async {
    try {
      await   _firestore.collection('Posts').doc(postId).update({
        'IsPaymentApproved': true,  // Set the payment status to true
        'Status': 'Approved',      // Mark the post as approved
      });

      Fluttertoast.showToast(
        msg: "Payment Verified, Post is now live",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error verifying payment: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }




}




class UserData extends StatefulWidget {
  UserData({super.key});

   static String googleMapsApiKey = "AIzaSyAr7RoP6zWVDZaW6CF-aFUU9xmaYn9-dbY";

  @override
  State<UserData> createState() => _UserDataState();

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

class _UserDataState extends State<UserData> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedUserUid;

  String searchQuery = "";
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> allUsers = [];
  List<DocumentSnapshot> filteredUsers = [];



  List<DocumentSnapshot> filteredDocs = [];
  Future<List<DocumentSnapshot>>? docsFuture;


  @override
  void initState() {
    super.initState();
    fetchUsers();
    _searchController.addListener(() {
      _filterUsers(_searchController.text);
    });
  }
  Future<List<DocumentSnapshot>> _filterDocs(List<DocumentSnapshot> docs, String query) async {
    List<DocumentSnapshot> filteredDocs = [];

    for (var doc in docs) {
      final title = doc['Title'].toString().toLowerCase();
      final protectionPlan = doc['Insurance'].toString().toLowerCase();

      final userName = await getUserName(doc['Uid']); // Assuming getUserName is a function that fetches the username
      final userNameLower = userName.toLowerCase();

      if (title.contains(query.toLowerCase()) ||
          userNameLower.contains(query.toLowerCase()) ||
          protectionPlan.contains(query.toLowerCase())) {
        filteredDocs.add(doc);
      }
    }

    return filteredDocs;
  }

  void fetchUsers() async {
    var snapshot = await FirebaseFirestore.instance.collection('Users').orderBy('Name').get();
    setState(() {
      allUsers = snapshot.docs;
      filteredUsers = allUsers; // Initial load
    });
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        final name = user['Name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.26,
              height: MediaQuery.of(context).size.height * 0.07,
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('approvedCollection').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FutureBuilder(
                  future: _filterDocs(snapshot.data!.docs, _searchController.text),
                  builder: (context, futureSnapshot) {
                    if (!futureSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var docs = futureSnapshot.data!;
                    if (docs.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Total Ads', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Images', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Ads', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Protection Plan', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: docs.map((doc) {
                          List<dynamic> images = doc['Pictures_Url'] ?? [];
                          int currentIndex = 0;

                          return DataRow(
                            cells: [
                              DataCell(FutureBuilder(
                                future: getUserName(doc['Uid']),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return const Text('Loading...');
                                  return Text(snapshot.data!);
                                },
                              )),
                              DataCell(
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.1, // 10% of screen width
                                  child: Text(
                                    doc['Description'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),

                              DataCell(Text(docs.length.toString())),
                              DataCell(
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
                                                        images[currentIndex],
                                                        height: 300,
                                                        width: 500,
                                                        fit: BoxFit.contain,
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return const Center(child: CircularProgressIndicator());
                                                        },
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return const Text('Image failed to load', style: TextStyle(color: Colors.red));
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
                                  child: const Text('View Images', style: TextStyle(color: Colors.blue)),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ListOfAds(uid: doc['Uid'])),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      doc['Title'],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text('\$${doc['Price']}/${doc['Duration']}')),
                              DataCell(Text(doc['Insurance'].toString())),
                              DataCell(FutureBuilder(
                                future: UserData.getAddressFromCoordinates(doc['Location']),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return const Text('Loading...');
                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
}


class unapprovedAds extends StatefulWidget {
  const unapprovedAds({super.key});

  @override
  State<unapprovedAds> createState() => _unapprovedAdsState();
}

class _unapprovedAdsState extends State<unapprovedAds> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedUserUid;

  String searchQuery = "";
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> allUsers = [];
  List<DocumentSnapshot> filteredUsers = [];



  List<DocumentSnapshot> filteredDocs = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _searchController.addListener(() {
      _filterUsers(_searchController.text);
    });
  }
  List<DocumentSnapshot> _filterDocs(List<DocumentSnapshot> docs, String query) {
    return docs.where((doc) {
      final title = doc['Title'].toString().toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();
  }

  void fetchUsers() async {
    var snapshot = await FirebaseFirestore.instance.collection('Users').orderBy('Name').get();
    setState(() {
      allUsers = snapshot.docs;
      filteredUsers = allUsers; // Initial load
    });
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        final name = user['Name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.26,
              height:   MediaQuery.of(context).size.height * 0.07,
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
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
              stream: _firestore.collection('rejectedCollection').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var docs = _filterDocs(snapshot.data!.docs, _searchController.text);

                //  var docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return ListView.builder(
                  itemCount:docs.length,
                  itemBuilder: (context, index) {
                    // var doc = filteredDocs[index];
                    var doc = docs[index];
                    List<dynamic> images = doc['Pictures_Url'] ?? [];
                    int currentIndex = 0;

                    return FutureBuilder(
                      future: Future.wait([
                        getUserName(doc['Uid']),
                        UserData.getAddressFromCoordinates(doc['Location']),
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
                                  child: Text('\$${doc['Price']}/${doc['Duration']}', style: const TextStyle(fontSize: 12)),
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
}