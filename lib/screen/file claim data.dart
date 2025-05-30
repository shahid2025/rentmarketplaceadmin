import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FileClaimData extends StatefulWidget {
  const FileClaimData({super.key});

  @override
  State<FileClaimData> createState() => _FileClaimDataState();
}

class _FileClaimDataState extends State<FileClaimData> {
  void _showImagesDialog(List<String> checkIn, List<String> checkOut, List<String> damage) {
    List<String> allImages = [...checkIn, ...checkOut, ...damage];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Claim Images'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: allImages.isEmpty
              ? const Center(child: Text("No images available"))
              : GridView.builder(
            itemCount: allImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Image.network(allImages[index], fit: BoxFit.cover);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the icon color to white
        ),
        backgroundColor: Colors.blue,
        title: const Text("Filed Claims",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20,color: Colors.white,),),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('claims').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No filed claims found."));
          }

          final claims = snapshot.data!.docs;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text("Full Name", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Email", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Phone", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Renty Username", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Item Name", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Item ID", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Start Date", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("End Date", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Owner", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Renter", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Issue Type", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Description", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Discovered Date", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Police Filed", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Claim Date", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Images", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Approved", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Denied", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Request Info", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                        DataColumn(label: Text("Mark as Paid", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                      ],
                      rows: List.generate(claims.length, (index) {
                        final doc = claims[index];
                        final data = doc.data() as Map<String, dynamic>;

                        final checkInPhotos = List<String>.from(data['checkInPhotos'] ?? []);
                        final checkOutPhotos = List<String>.from(data['checkOutPhotos'] ?? []);
                        final additionalDamagePhotos = List<String>.from(data['additionalDamagePhotos'] ?? []);

                        // Define a list of colors for alternating row colors
                        final rowColors = [
                          Colors.blue.shade300,
                          Colors.green.shade300,
                          Colors.orange.shade300,
                          Colors.purple.shade300,
                          Colors.yellow.shade300
                        ];

                        final rowColor = rowColors[index % rowColors.length];

                        return DataRow(
                          color: MaterialStateProperty.all(rowColor),
                          cells: [
                            DataCell(Text(data['fullName'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['email'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['phoneNumber'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['rentyCityUsername'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['itemName'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['itemId'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['rentalStartDate'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['rentalEndDate'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['ownerName'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['renterName'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['typeOfIssue'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['damageDescription'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['dateAndTimeIssueDiscovered'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['policeReportFiled'] == true ? "Yes" : "No", style: const TextStyle(color: Colors.white))),
                            DataCell(Text(data['date'] ?? 'N/A', style: const TextStyle(color: Colors.white))),
                            DataCell(
                              InkWell(
                                onTap: () {
                                  _showImagesDialog(checkInPhotos, checkOutPhotos, additionalDamagePhotos);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "View Images",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                                InkWell(
                                  onTap: () async {
                                    // Open text field for admin to enter approval message
                                    final approvalMessageController = TextEditingController();
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Enter Approval Message'),
                                        content: TextField(
                                          controller: approvalMessageController,
                                          decoration: const InputDecoration(hintText: 'Enter message'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Submit'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result != null && result) {
                                      final claimRef = FirebaseFirestore.instance.collection('claims').doc(doc.id);
                                      await claimRef.update({'status': 'approved'});

                                      // Add claim history
                                      final claimHistoryRef = FirebaseFirestore.instance.collection('claims').doc(doc.id).collection('claimHistory').doc();
                                      await claimHistoryRef.set({
                                        'action': 'approved',
                                        'timestamp': FieldValue.serverTimestamp(),
                                        'adminId': 'adminId', // Replace with actual admin ID
                                        'adminName': 'Admin Name', // Replace with actual admin name
                                        'message': approvalMessageController.text,
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Approved",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            DataCell(
                              // Denied claim
                                InkWell(
                                  onTap: () async {
                                    // Open text field for admin to enter denial message
                                    final denialMessageController = TextEditingController();
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Enter Denial Message'),
                                        content: TextField(
                                          controller: denialMessageController,
                                          decoration: const InputDecoration(hintText: 'Enter message'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Submit'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result != null && result) {
                                      final claimRef = FirebaseFirestore.instance.collection('claims').doc(doc.id);
                                      await claimRef.update({'status': 'denied'});

                                      // Add claim history
                                      final claimHistoryRef = FirebaseFirestore.instance.collection('claims').doc(doc.id).collection('claimHistory').doc();
                                      await claimHistoryRef.set({
                                        'action': 'denied',
                                        'timestamp': FieldValue.serverTimestamp(),
                                        'adminId': 'adminId', // Replace with actual admin ID
                                        'adminName': 'Admin Name', // Replace with actual admin name
                                        'message': denialMessageController.text,
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Denied",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )

                            ),
                            DataCell(
                              // Request info
                                InkWell(
                                  onTap: () async {
                                    // Open text field for admin to enter request message
                                    final requestMessageController = TextEditingController();
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Enter Request Message'),
                                        content: TextField(
                                          controller: requestMessageController,
                                          decoration: const InputDecoration(hintText: 'Enter message'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Submit'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result != null && result) {
                                      // Add claim history
                                      final claimHistoryRef = FirebaseFirestore.instance.collection('claims').doc(doc.id).collection('claimHistory').doc();
                                      await claimHistoryRef.set({
                                        'action': 'requestInfo',
                                        'timestamp': FieldValue.serverTimestamp(),
                                        'adminId': 'adminId', // Replace with actual admin ID
                                        'adminName': 'Admin Name', // Replace with actual admin name
                                        'message': requestMessageController.text,
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Request Info",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            DataCell(
                              // Mark as paid
                                InkWell(
                                  onTap: () async {
                                    // Open text field for admin to enter payment message
                                    final paymentMessageController = TextEditingController();
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Enter Payment Message'),
                                        content: TextField(
                                          controller: paymentMessageController,
                                          decoration: const InputDecoration(hintText: 'Enter message'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Submit'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (result != null && result) {
                                      final claimRef = FirebaseFirestore.instance.collection('claims').doc(doc.id);
                                      await claimRef.update({'status': 'paid'});

                                      // Add claim history
                                      final claimHistoryRef = FirebaseFirestore.instance.collection('claims').doc(doc.id).collection('claimHistory').doc();
                                      await claimHistoryRef.set({
                                        'action': 'paid',
                                        'timestamp': FieldValue.serverTimestamp(),
                                        'adminId': 'adminId', // Replace with actual admin ID
                                        'adminName': 'Admin Name', // Replace with actual admin name
                                        'message': paymentMessageController.text,
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Mark as Paid",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }
}
