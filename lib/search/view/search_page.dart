import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage._();
  // const SearchPage();

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const SearchPage._());
        // return MaterialPageRoute(builder: (_) => const SearchPage());

  }
  // final  route = MaterialPageRoute(builder: (_) => const SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();

  String get _text => _textController.text;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Search')),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Word',
                  hintText: 'Hello',
                ),
              ),
            ),
          ),
          IconButton(
            key: const Key('searchPage_search_iconButton'),
            icon: const Icon(Icons.search, semanticLabel: 'Submit'),
            onPressed: () => Navigator.of(context).pop(_text),
          ),
        ],
      ),
    );
  }
}