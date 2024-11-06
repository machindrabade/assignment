import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

import 'login/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _imageUrls = [];
  int _currentPage = 1;
  final int _perPage = 10;
  bool _isLoading = false;
  final _searchController = TextEditingController();
  List<String> _searchHistory = [];

  Future<void> _fetchImages({String query = ''}) async {
    setState(() {
      _isLoading = true;
    });

    final String apiUrl = query.isEmpty
        ? 'https://api.unsplash.com/photos?page=$_currentPage&per_page=$_perPage'
        : 'https://api.unsplash.com/search/photos?page=$_currentPage&per_page=$_perPage&query=$query';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Client-ID vCyZH4TK9nAyoijYgXBIekB8Z0S8RMRPZb6MoRD5sXc',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        if (query.isEmpty) {
          _imageUrls.addAll(List<String>.from(data.map((item) => item['urls']['small'])));
        } else {
          _imageUrls = List<String>.from(data['results'].map((item) => item['urls']['small']));
        }
        _isLoading = false;
        _currentPage++;
      });

      if (query.isNotEmpty) {
        // Store query in Firestore
        await FirebaseFirestore.instance.collection('searchHistory').add({
          'query': query,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _loadSearchHistory();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load images')),
      );
    }
  }

  Future<void> _loadSearchHistory() async {
    // Fetch search history from Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('searchHistory')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    setState(() {
      _searchHistory = snapshot.docs.map((doc) => doc['query'] as String).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((_) {
      _fetchImages();
      _loadSearchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unsplash Image Carousel'),
        leading: BackButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen())); // Navigate back to the login page
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search images...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _currentPage = 1;
                        _fetchImages(query: _searchController.text);
                      },
                    ),
                  ),
                ),
                if (_searchHistory.isNotEmpty)
                  DropdownButton<String>(
                    hint: Text('Select from search history'),
                    items: _searchHistory.map((query) {
                      return DropdownMenuItem<String>(
                        value: query,
                        child: Text(query),
                      );
                    }).toList(),
                    onChanged: (selectedQuery) {
                      if (selectedQuery != null) {
                        _searchController.text = selectedQuery;
                        _currentPage = 1;
                        _fetchImages(query: selectedQuery);
                      }
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(_imageUrls[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
