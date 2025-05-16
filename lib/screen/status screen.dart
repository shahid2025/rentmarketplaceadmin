import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminPaymentDashboard extends StatefulWidget {
  const AdminPaymentDashboard({Key? key}) : super(key: key);

  @override
  _AdminPaymentDashboardState createState() => _AdminPaymentDashboardState();
}

class _AdminPaymentDashboardState extends State<AdminPaymentDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isProcessing = false;
  final TextEditingController _disputeController = TextEditingController();

  Future<void> _updatePaymentStatus(
      String paymentId,
      String status, {
        String? disputeReason,
      }) async {
    setState(() => _isProcessing = true);
    try {
      final updateData = {
        'status': status,
        'updatedAt': Timestamp.now(),
        'updatedBy': FirebaseAuth.instance.currentUser?.uid,
      };

      if (status == 'disputed' && disputeReason != null) {
        updateData['disputeReason'] = disputeReason;
        updateData['disputeReportedAt'] = Timestamp.now();
      }

      if (status == 'released') {
        updateData['releasedAt'] = Timestamp.now();
      }

      await _firestore.collection('held_payments').doc(paymentId).update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment status updated to $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _showDisputeDialog(String paymentId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Mark as Disputed"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter dispute reason:"),
              const SizedBox(height: 10),
              TextField(
                controller: _disputeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Reason for dispute...",
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_disputeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter dispute reason')),
                  );
                  return;
                }
                _updatePaymentStatus(
                  paymentId,
                  'disputed',
                  disputeReason: _disputeController.text,
                );
                Navigator.pop(context);
                _disputeController.clear();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'hold': return Colors.orange;
      case 'released': return Colors.green;
      case 'disputed': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildStatusBadge(String status, String paymentId) {
    return GestureDetector(
      onTap: () {
        if (status == 'hold') {
          _updatePaymentStatus(paymentId, 'released');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(status),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          status.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disputeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Admin Payment Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('held_payments')
            .orderBy('holdStartTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columnSpacing: 20,
                horizontalMargin: 10,
                headingRowColor: MaterialStateProperty.all(Colors.blue.shade700),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                columns: const [
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Renter")),
                  DataColumn(label: Text("Owner")),
                  DataColumn(label: Text("Amount"), numeric: true),
                  DataColumn(label: Text("Currency")),
                  DataColumn(label: Text("Held Since")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Actions")),
                ],
                rows: snapshot.data!.docs.map((doc) {
                  final payment = doc.data() as Map<String, dynamic>;
                  final status = payment['status'];
                  final amount = (payment['amount'] / 100).toStringAsFixed(2);
                  final currency = payment['currency'];
                  final holdStart = (payment['holdStartTime'] as Timestamp).toDate();
                  final renterUid = payment['renterUid'] ?? 'Unknown';
                  final ownerUid = payment['ownerUid'] ?? 'Unknown';

                  return DataRow(
                    cells: [
                      DataCell(Text(doc.id.substring(0, 6))),
                      DataCell(Text(renterUid.substring(0, 6))),
                      DataCell(Text(ownerUid.substring(0, 6))),
                      DataCell(Text(amount)),
                      DataCell(Text(currency.toUpperCase())),
                      DataCell(Text(DateFormat('MMM d, y').format(holdStart))),
                      DataCell(_buildStatusBadge(status, doc.id)),
                      DataCell(
                        Row(
                          children: [
                            if (status == 'hold') ...[
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () => _updatePaymentStatus(doc.id, 'released'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.pause, color: Colors.orange),
                                onPressed: () => _updatePaymentStatus(doc.id, 'hold'),
                              ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.warning, color: Colors.red),
                              onPressed: () => _showDisputeDialog(doc.id),
                            ),
                            if (status == 'disputed') ...[
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () => _updatePaymentStatus(doc.id, 'released'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}