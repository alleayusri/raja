import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isToggleActive = false;
  TextEditingController _searchController = TextEditingController();

  List<String> user = [
    "Chan Saw Lin",
    "Lee Saw Loy",
    "Khaw Tong Lin",
    "Lim Kok Lin",
    "Low Jun Wei",
    "Yong Weng Kai",
    "Jayden Lee",
    "Kong Kah Yan",
    "Jasmine Lau",
    "Chan Saw Lin",
  ];

  List<String> phone = [
    "0152131113",
    "0161231346",
    "0158398109",
    "0168279101",
    "0112731912",
    "0172332743",
    "0191236439",
    "0111931233",
    "0162879190",
    "016783239",
  ];

  List<String> datestrings = [
    "2020-06-30 16:10:05",
    "2020-07-11 15:39:59",
    "2020-08-19 11:10:18",
    "2020-08-19 11:11:35",
    "2020-08-15 13:00:05",
    "2020-07-31 18:10:11",
    "2020-08-22 08:10:38",
    "2020-07-11 12:00:00",
    "2020-08-01 12:00:00",
    "2020-08-23 12:10:05",
  ];

  List<int> _searchResults = [];

  String formatDateTime(int index) {
    if (_isToggleActive) {
      return DateFormat('dd MMM yyyy, h:mm a').format(DateTime.parse(datestrings[index]));
    } else {
      return timeago.format(DateTime.parse(datestrings[index]), locale: 'en_short');
    }
  }

  void _addNewRecord(BuildContext context) {
    setState(() {
      user.add("New User");
      phone.add("0123456789");
      datestrings.add("2023-10-15 10:00:00");
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('New record added successfully!'),
    ));
  }

  _loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isToggleActive = prefs.getBool('isToggleActive') ?? false;
    });
  }

  _saveToggleState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isToggleActive', value);
  }

  void _performSearch(String query) {
    _searchResults.clear();
    if (query.isNotEmpty) {
      for (int i = 0; i < user.length; i++) {
        if (user[i].toLowerCase().contains(query.toLowerCase()) ||
            phone[i].contains(query)) {
          _searchResults.add(i);
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadToggleState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List View of Attendance Record"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.format_align_left),
            onPressed: () {
              setState(() {
                _isToggleActive = !_isToggleActive;
                _saveToggleState(_isToggleActive);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Enter keyword...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                int originalIndex = _searchResults[index];
                return ListTile(
                  title: Text(user[originalIndex]),
                  subtitle: Text(phone[originalIndex]),
                  trailing: Text(formatDateTime(originalIndex)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          userName: user[originalIndex],
                          phoneNumber: phone[originalIndex],
                          formattedDate: formatDateTime(originalIndex),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewRecord(context),
        tooltip: 'Add New Record',
        child: Icon(Icons.add),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String userName;
  final String phoneNumber;
  final String formattedDate;

  DetailsPage({required this.userName, required this.phoneNumber, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('User: $userName', style: TextStyle(fontSize: 18)),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 18)),
            Text('Date: $formattedDate', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
