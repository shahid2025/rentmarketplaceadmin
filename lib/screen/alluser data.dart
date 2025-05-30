import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'admin_dashboard.dart';

class AllUsersData extends StatefulWidget {
  const AllUsersData({super.key});

  @override
  State<AllUsersData> createState() => _AllUsersDataState();
}

class _AllUsersDataState extends State<AllUsersData> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Users').get();
      final data = snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        _users = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() => _isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users Data'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(child: Text('No users found'))
          : LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 20,
                  columns: const [
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Radius', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Verified', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Referral Code', style: TextStyle(fontWeight: FontWeight.bold))),
                   // DataColumn(label: Text('FCM Token', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Location', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: _users.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user['Name'] ?? '')),
                      DataCell(Text(user['Email'] ?? '')),
                      DataCell(Text(user['Wallet']?.toString() ?? '0')),
                      DataCell(Text(user['Radius']?.toString() ?? '')),
                      DataCell(Text(user['isVerified'] == true ? 'Yes' : 'No')),
                      DataCell(Text(user['referralCode'] ?? '')),

                    DataCell(
                    FutureBuilder<String>(
                    future: UserData.getAddressFromCoordinates(user['Location']),
                    builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                    } else if (snapshot.hasError) {
                    return const Text('Error');
                    } else {
                    return Text(snapshot.data ?? 'N/A');
                    }
                    },
                    ),)
                     // DataCell(Text(user['customerId'] ?? '')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// class UserData {
//   static Future<String> getAddressFromCoordinates(Map<String, dynamic> location) async {
//     try {
//       final lat = location['Lat'];
//       final long = location['Long'];
//
//       final placemarks = await placemarkFromCoordinates(lat, long);
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//       }
//     } catch (e) {
//       print("Error getting address: $e");
//     }
//     return "Unknown";
//   }
// }
