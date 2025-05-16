import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class MyPackagesDetailsPage extends StatefulWidget {
  final String postUid;

  const MyPackagesDetailsPage({Key? key, required this.postUid}) : super(key: key);

  @override
  State<MyPackagesDetailsPage> createState() => _MyPackagesDetailsPageState();
}

class _MyPackagesDetailsPageState extends State<MyPackagesDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> _getPostData() {
    return _firestore.collection('approvedCollection').doc(widget.postUid).get();
  }
  Future<String> getAddressFromLatLong(dynamic location) async {
    if (location == null || location['Lat'] == null || location['Long'] == null) {
      return "Location information is incomplete";
    }
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location['Lat'], location['Long']);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return "${placemark.street}, ${placemark.locality}, ${placemark.country}";
      }
      return "Unknown location";
    } catch (e) {
      print("Error in geocoding: $e");
      return "Location not found";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Ad Details',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _getPostData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No details found for this post.'));
          }

          final data = snapshot.data!.data()!;
          final List<dynamic> images = data['Pictures_Url'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                images.isNotEmpty
                    ? SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(child: Text('No Images')),
                ),
                const SizedBox(height: 20),
                _detailRow("Title", data['Title']),
                _detailRow("Description", data['Description']),
                _detailRow("Insurance", data['Insurance']),
                _detailRow("Price", data['Price']),
                _detailRow("Phone", data['Phone']),
                _detailRow("Status", data['Status'] ?? 'Approved'),
                _detailRow("Condition", data['Condition'] ),
                _detailRow("City", data['City'] ),
                _detailRow("Category", data['Category'] ),
                FutureBuilder<String>(
                  future: getAddressFromLatLong(data['Location']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _detailRow("Location", "Unable to fetch address");
                    }
                    return _detailRow("Location", snapshot.data);
                  },
                ),

              ],
            ),
          );
        },
      ),
    );
  }
  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Set a fixed width for label
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }


}
