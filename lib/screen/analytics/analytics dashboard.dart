

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';





class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _ActiveUsersCard()),
                          const SizedBox(width: 16),
                          Expanded(child: PageViewsPerMinuteChart()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _MetricsRow(),
                      const SizedBox(height: 20),
                      const _AlertCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Right side
                 SizedBox(
                  width: 300,
                  height: MediaQuery.of(context).size.height*.90,
                  child: const _TopPagesList(),
                ),
              ],
            )
                : Column(
              children: [
                _ActiveUsersCard(),
                const SizedBox(height: 16),
                PageViewsPerMinuteChart(),
                const SizedBox(height: 20),
                const _MetricsRow(),
                const SizedBox(height: 20),
                const _AlertCard(),
                const SizedBox(height: 20),
                const _TopPagesList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class _ActiveUsersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.indigo[900],
        borderRadius: BorderRadius.circular(12),
      ),
      width: 400,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Active Users', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 10),
          Text('72', style: TextStyle(fontSize: 32, color: Colors.white)),
          SizedBox(height: 10),
          Text('VIEW REFERRALS →', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _TopPagesList extends StatelessWidget {
  const _TopPagesList();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top pages', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Visits', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ...[
            {'page': 'Dispute/Problem Analytics', 'visits': '1000 views'},
            {'page': 'Number of active users', 'visits': '10,000 users'},
            {'page': 'New signups per month', 'visits': '500 signups'},
            {'page': 'Verified users', 'visits': '8,000 users'},
            {'page': 'Number of active rentals', 'visits': '2,000 rentals'},
            {'page': 'Completed rentals', 'visits': '1,500 rentals'},
            {'page': 'Average rental value', 'visits': '\$100'},
          ].map((data) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['page']!,style: TextStyle(fontSize: 11),),
              Text(data['visits']!),
            ],
          )).toList(),
          const SizedBox(height: 100,),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Users',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'New Signups',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    '1.2K',
                    style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Revenue',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(
                    '\$12.5K',
                    style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _MetricCard(title: 'number of active rentals', value: '15K', change: '268%', positive: true),
        _MetricCard(title: 'signups per month', value: '17K', change: '268%', positive: true),
        _MetricCard(title: 'verified users', value: '62.57%', change: '19.6%', positive: false),
        _MetricCard(title: 'Resolution time average', value: '1m 37s', change: '29.7%', positive: false),

        _MetricCard(title: 'Completed Rentals', value: '62.57%', change: '19.6%', positive: false),
        _MetricCard(title: 'Most Popular category', value: '62.57%', change: '19.6%', positive: false),
        _MetricCard(title: 'Protection Plan earnings', value: '62.57%', change: '19.6%', positive: true),
        _MetricCard(title: 'Payout Completed', value: '62.57%', change: '19.6%', positive: true),

        _MetricCard(title: 'Number of dispute opened', value: '62.57%', change: '19.6%', positive: true),
        _MetricCard(title: 'Transaction fees earnings', value: '62.57%', change: '19.6%', positive: true),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool positive;

  const _MetricCard({required this.title, required this.value, required this.change, required this.positive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 11)),
              Text(
                (positive ? '↑' : '↓') + change,
                style: TextStyle(color: positive ? Colors.green : Colors.red),
              ),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),

        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications, color: Colors.amber),
              SizedBox(width: 8),
              Text('No alerts set'),
            ],
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.blue)
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Set alert'),
            ),
          )
         // ElevatedButton(onPressed: () {}, child: const Text('Set alert')),
        ],
      ),
    );
  }
}




class PageViewsPerMinuteChart extends StatelessWidget {
  final List<_PageViewData> chartData = List.generate(
    21,
        (index) => _PageViewData(index.toString(), _randomHeight(index)),
  );

  static double _randomHeight(int i) {
    final values = [
      10, 20, 15, 8, 12, 25, 18, 22, 17, 14, 19,
      23, 21, 9, 7, 5, 6, 4, 3, 2, 1
    ];
    return values[i].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total platform revenue", style: TextStyle(fontWeight: FontWeight.w500)),
         // SizedBox(height: 12),
          SizedBox(
            height: 90,
            width: 400,
            child: SfCartesianChart(

              primaryXAxis: CategoryAxis(isVisible: false),
              primaryYAxis: NumericAxis(isVisible: false),
              plotAreaBorderWidth: 0,
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                ColumnSeries<_PageViewData, String>(
                  dataSource: chartData,
                  xValueMapper: (_PageViewData data, _) => data.minute,
                  yValueMapper: (_PageViewData data, _) => data.views,
                  borderRadius: BorderRadius.circular(4),
                  width: 0.5,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text("VIEW REFERRALS"),
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageViewData {
  final String minute;
  final double views;
  _PageViewData(this.minute, this.views);
}
