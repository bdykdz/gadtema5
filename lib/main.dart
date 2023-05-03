import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'key.dart';
import 'picture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


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
  static String apikey = API_KEY_UNSPLASH;
  final TextEditingController _searchImageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  String searchTerm = 'Travis Scott';
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final List<Picture> _images = <Picture>[];

  @override
  void initState() {
    super.initState();
    getImages(page: _page);
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Google Pictures'),
        actions: <Widget>[
          if (_isLoading)
            const Center(
                child: FittedBox(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))),
        ],
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
                    getImages(search: searchTerm, page: _page);
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
                    controller: _controller,
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Picture picture = _images[index];

                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          GridTile(
                              child: Image.network(
                            picture.urls.regular,
                            fit: BoxFit.cover,
                          )),
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

  Future<void> getImages({String? search, required int page}) async {
    setState(() => _isLoading = true);
    if (page == 1) {
      _images.clear();
    }

    final String query = search ?? searchTerm;
    final http.Client client = http.Client();
    final Uri uri = Uri.parse('https://api.unsplash.com/search/photos?query=$query&per_page=30&page=$page');
    final http.Response response =
        await client.get(uri, headers: <String, String>{'Authorization': 'Client-ID $apikey'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> imageResults = result['results'] as List<dynamic>;
      _hasMore = result['total_pages'] as int < _page;
      setState(() {
        _images.addAll(imageResults
            .cast<Map<dynamic, dynamic>>()
            .map((dynamic json) => Picture.fromJson(json as Map<String, dynamic>)));
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    final double height = MediaQuery.of(context).size.height;
    final double offset = _controller.position.pixels;
    final double maxScrollExtent = _controller.position.maxScrollExtent;

    if (_hasMore && !_isLoading && maxScrollExtent - offset < 3 * height) {
      _page++;
      getImages(page: _page);
    }
  }
}
