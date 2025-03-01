import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String activeTab = "overview";

  final List<Map<String, dynamic>> features = [
    {"icon": Iconsax.card, "label": "Cards", "color": Colors.blue.shade100},
    {
      "icon": Iconsax.arrow_right,
      "label": "Transfer",
      "color": Colors.red.shade100
    },
    {
      "icon": Iconsax.dollar_circle,
      "label": "Pay bills",
      "color": Colors.green.shade100
    },
    {"icon": Iconsax.add, "label": "Top up", "color": Colors.yellow.shade100},
    {
      "icon": Iconsax.trend_up,
      "label": "Investments",
      "color": Colors.purple.shade100
    },
    {
      "icon": Iconsax.search_normal,
      "label": "Statistics",
      "color": Colors.indigo.shade100
    },
  ];

  final List<Map<String, dynamic>> transactions = [
    {"description": "Amazon.com", "amount": -79.99, "date": "2023-06-15"},
    {"description": "Salary Deposit", "amount": 3500.00, "date": "2023-06-01"},
    {"description": "Uber Ride", "amount": -24.50, "date": "2023-06-10"},
    {
      "description": "Netflix Subscription",
      "amount": -13.99,
      "date": "2023-06-05"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi, John Smith",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          Text("Welcome back!",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  Icon(Iconsax.notification, size: 28),
                ],
              ),
              SizedBox(height: 20),

              // Card Balance
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Balance",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text("\$3,469.52",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("**** **** **** 1076",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Feature Buttons
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: feature["color"],
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(feature["icon"], size: 28),
                        ),
                        SizedBox(height: 6),
                        Text(feature["label"], style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tabButton("Overview", activeTab == "overview"),
                  _tabButton("Transactions", activeTab == "transactions"),
                ],
              ),
              SizedBox(height: 10),

              // Content
              Expanded(
                child: activeTab == "overview"
                    ? _overviewContent()
                    : _transactionsContent(),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.search_normal), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Iconsax.message), label: "Mail"),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.setting), label: "Settings"),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = label.toLowerCase();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.blue : Colors.black)),
      ),
    );
  }

  Widget _overviewContent() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text("Placeholder for account overview charts",
            style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _transactionsContent() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            title: Text(transaction["description"],
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(transaction["date"],
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            trailing: Text(
              "\$${transaction["amount"].toStringAsFixed(2)}",
              style: TextStyle(
                  color: transaction["amount"] < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
