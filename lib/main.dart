import 'dart:convert';
import 'key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'picture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String API_KEY = API_KEY_UNSPLASH;
  final TextEditingController _searchImageController = TextEditingController();
  String searchTerm = 'Travis Scott';
  final List<Picture> _images = <Picture>[];

  @override
  void initState() {
    super.initState();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
        title: const Text('Google Pictures'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                    controller: _searchImageController,
                    decoration: const InputDecoration(
                      label: Text("Don't be evil ( ͡° ͜ʖ ͡°)"),
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.lightBlue,
                    )),
              ),
              TextButton(
                  onPressed: () {
                    searchTerm = _searchImageController.text;
                    if (searchTerm.isEmpty) {
                      searchTerm = 'random';
                    }
                    getImages(search: searchTerm);
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
                  child: const Text('Search'))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: _images.isEmpty
                ? const Center(
                    child: Text(
                      'No Images Found',
                      style: TextStyle(fontSize: 50),
                    ),
                  )
                : GridView.builder(
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Picture picture = _images[index];

                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          GridTile(child:
                       Image.network(picture.urls.regular,
                      fit: BoxFit.cover ,)),
                      // Align
                      // (
                      //   alignment: AlignmentDirectional.bottomEnd,
                      //   child: ListTile(
                      //     title: Text(picture.user.name),
                      //     trailing: CircleAvatar(backgroundImage: NetworkImage(picture.user.profileImage.small)),
                      //   )
                      // )
                        ],
                      );
                    },
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> getImages({String? search}) async {
    _images.clear();
    final String query = search ?? searchTerm;
    final http.Client client = http.Client();
    final Uri uri = Uri.parse('https://api.unsplash.com/search/photos?query=$query');
    final http.Response response =
        await client.get(uri, headers: <String, String>{'Authorization': 'Client-ID $API_KEY'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> imageResults = result['results'] as List<dynamic>;
      setState(() {
        _images.addAll(imageResults.cast<Map<dynamic, dynamic>>().map((json) => Picture.fromJson(json as Map<String, dynamic>)));
      });
    }
  }
}