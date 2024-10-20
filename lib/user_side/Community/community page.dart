import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartvolt1/user_side/Community/new_query.dart';
import 'package:smartvolt1/user_side/Community/query_history.dart';
import 'package:smartvolt1/user_side/Community/query_detail.dart';

class QueryListPage extends StatefulWidget {
  @override
  _QueryListPageState createState() => _QueryListPageState();
}

class _QueryListPageState extends State<QueryListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final now = DateTime.now();
    final postTime = timestamp.toDate();
    final difference = now.difference(postTime).inHours;
    return '$difference hours ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Queries'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search queries...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('comments').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var filteredQueries = snapshot.data!.docs.where((query) {
                  var queryText = query['text'].toLowerCase();
                  return queryText.contains(_searchText);
                }).toList();

                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: filteredQueries.length,
                  itemBuilder: (context, index) {
                    var query = filteredQueries[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the QueryDetailPage with comment ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QueryDetailPage(query.id), // Pass the comment ID
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      query['author']?[0] ?? 'U',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    query['author'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

                              // Adjusted Image section
                              if (query['imageURL'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0), // Optional: to add rounded corners
                                  child: Container(
                                    width: double.infinity, // Full width of the card
                                    height: 350, // Specify a fixed height
                                    child: Image.network(
                                      query['imageURL'],
                                      fit: BoxFit.cover, // Scale the image to cover the area
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8),
                              Text(
                                query['text'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Posted ${_formatTimestamp(query['timestamp'] as Timestamp?)}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Status: ${query['status']}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QueryHistoryPage()),
                );
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.history),
            ),
          ),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewQueryPage()),
              );
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
