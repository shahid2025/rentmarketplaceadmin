
import 'package:flutter/material.dart';
class AdsRequests extends StatefulWidget {
  const AdsRequests({super.key});

  @override
  State<AdsRequests> createState() => _AdsRequestsState();
}

class _AdsRequestsState extends State<AdsRequests> {
  String _selectedType = 'Data';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                      Text("Authentication", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(icon: Icon(Icons.help_outline, color: Colors.white), onPressed: () {}),
                          IconButton(icon: Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
                          IconButton(icon: Icon(Icons.account_circle, color: Colors.white), onPressed: () {}),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 23,),
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
                      SizedBox(width: 15,),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedType = 'Approved Data';
                          });
                        },
                        child: Text('Approved Data', style: TextStyle(color: _selectedType == 'Approved Data' ? Colors.yellow : Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Table',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      elevation: 5, // Add a subtle shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Add rounded corners
                      ),
                      color: Colors.white, // Set the card background to white
                      child: _selectedType == 'Data'
                          ? DataTable(
                        columnSpacing: 200,
                        columns: const [
                          DataColumn(label: Text('Title')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Images')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: const [
                          DataRow(cells: [
                            DataCell(Text('Data 1')),
                            DataCell(Text('Description 1')),
                            DataCell(Text('Images 1')),
                            DataCell(Text('Actions 1')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Data 2')),
                            DataCell(Text('Description 2')),
                            DataCell(Text('Images 2')),
                            DataCell(Text('Actions 2')),
                          ]),
                        ],
                      )
                          : DataTable(
                        columnSpacing: 200,
                        columns: const [
                          DataColumn(label: Text('Title')),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Images')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: const [
                          DataRow(cells: [
                            DataCell(Text('Approved Data 1')),
                            DataCell(Text('Description 1')),
                            DataCell(Text('Images 1')),
                            DataCell(Text('Actions 1')),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Approved Data 2')),
                            DataCell(Text('Description 2')),
                            DataCell(Text('Images 2')),
                            DataCell(Text('Actions 2')),
                          ]),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
