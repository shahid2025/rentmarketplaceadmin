

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({Key? key}) : super(key: key);

  @override
  _PaymentStatusScreenState createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isProcessing = false;

  Future<void> _releasePaymentNow(String paymentIntentId) async {
    setState(() => _isProcessing = true);
    try {
      await _firestore.collection('held_payments')
          .doc(paymentIntentId)
          .update({
        'status': 'released',
        'releasedAt': Timestamp.now(),
        'releasedManually': true,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment released successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: \${e.toString()}')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Widget _buildPaymentCard(String docId, Map<String, dynamic> payment) {
    final status = payment['status'];
   // final isAdmin = FirebaseAuth.instance.currentUser?.uid == 'admin_uid';
    final amount = (payment['amount'] / 100).toStringAsFixed(2);
    final currency = payment['currency'];

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Amount: $amount $currency", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Status: ${status.toUpperCase()}", style: TextStyle(color: _getStatusColor(status))),
            const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _releasePaymentNow(docId),
                    child: const Text("Release"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Hold"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Dispute"),
                  ),
                ],
              ),
            ],

        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Admin Payment Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('held_payments').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.blue),  // Background color for header row
                headingTextStyle: const TextStyle(
                  color: Colors.white,           // Text color for header
                  fontWeight: FontWeight.bold,
                ),
               // headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey[200]),
                columns: const [
                  DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Currency", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: snapshot.data!.docs.map((doc) {
                  final payment = doc.data() as Map<String, dynamic>;
                  final status = payment['status'];
                  final amount = (payment['amount'] / 100).toStringAsFixed(2);
                  final currency = payment['currency'];
             print('doc${doc.id}');

                  return DataRow(cells: [
                    DataCell(Text(payment['renterUid'] ?? 'Unknown')),
                    DataCell(Text(amount)),
                    DataCell(Text(currency.toUpperCase())),
                    DataCell(
                      GestureDetector(
                        onTap: (){
                          print('click');
                          _releasePaymentNow(doc.id);
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
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          if (status == 'hold') ...[
                            ElevatedButton(
                              onPressed: (){
                                print('click');
                                _releasePaymentNow(doc.id);
                                },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              ),
                              child: const Text("Release"),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            status == 'released' ? "Completed" : "Not Completed",
                            style: TextStyle(
                              color: status == 'released' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

