
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FromOwnerSideCheckIn extends StatefulWidget {
  const FromOwnerSideCheckIn({super.key});

  @override
  State<FromOwnerSideCheckIn> createState() => _FromOwnerSideCheckInState();
}

class _FromOwnerSideCheckInState extends State<FromOwnerSideCheckIn> {
  final CollectionReference reportsRef = FirebaseFirestore.instance.collection('check_in_reports');
  //final CollectionReference reviewsRef = FirebaseFirestore.instance.collection('Dates');
  final Query reviewsRef = FirebaseFirestore.instance.collectionGroup('Dates');

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Check-In Reports'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: reportsRef.orderBy('timestamp', descending: true).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text('Error loading check-in reports.'));

          final reportDocs = snapshot.data?.docs ?? [];
          if (reportDocs.isEmpty) return const Center(child: Text('No check-in reports found.'));

          return ListView.builder(
            itemCount: reportDocs.length,
            itemBuilder: (context, index) {
              final reportData = reportDocs[index].data() as Map<String, dynamic>;
              final title = reportData['title'] ?? 'No title';
              final desc = reportData['description'] ?? 'No description';
              final imageUrls = List<String>.from(reportData['imageUrls'] ?? []);
              final timestamp = reportData['timestamp'] != null ? (reportData['timestamp'] as Timestamp).toDate() : null;
              final postUid = reportData['postUid']; // <-- Used for filtering Dates

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    /// First: Owner side report card
                    SizedBox(
                      width: 600,
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('From Owner Side', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text("Title: $title", style: const TextStyle(fontSize: 16)),
                              Text("Description: $desc", style: const TextStyle(fontSize: 16)),
                              if (timestamp != null)
                                Text("Submitted: ${DateFormat.yMMMd().add_jm().format(timestamp)}", style: const TextStyle(color: Colors.grey)),
                              TextButton(
                                onPressed: () => _showImages(context, imageUrls),
                                child: const Text('View Images', style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Second: Renter side report matching postUid
                    SizedBox(
                      width: isWideScreen ? 600 : MediaQuery.of(context).size.width - 32,
                      child: FutureBuilder<QuerySnapshot>(
                        future: reviewsRef.where('postUid', isEqualTo: postUid).get(),
                        builder: (context, reviewSnap) {
                          if (reviewSnap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                          if (reviewSnap.hasError) return const Text('Error loading renter data');

                          final reviewDocs = reviewSnap.data?.docs ?? [];
                          if (reviewDocs.isEmpty) {
                            print('No matching Dates entry for postUid: $postUid');
                            return const Text('No matching renter record found.');
                          }

                          final data = reviewDocs.first.data() as Map<String, dynamic>;

                          final owner = data['owner'] ?? 'Unknown';
                          final renter = data['bookedBy'] ?? 'Unknown';
                          final start = data['start'] != null ? (data['start'] as Timestamp).toDate() : null;
                          final end = data['end'] != null ? (data['end'] as Timestamp).toDate() : null;

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Renter Booking Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text("Owner UID: $owner"),
                                  Text("Booked By (Renter): $renter"),
                                  if (start != null) Text("Start Date: ${DateFormat.yMMMd().format(start)}"),
                                  if (end != null) Text("End Date: ${DateFormat.yMMMd().format(end)}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  void _showImages(BuildContext context, List<String> imageUrls) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: imageUrls.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    url,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          )


      ),
      ),
    );
  }
}

