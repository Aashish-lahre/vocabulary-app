import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchController _searchController;
  bool _isSearchControllerDisposed = false;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isSearchControllerDisposed) {
        _searchController.openView();
      }
    });
  }

  @override
  void dispose() {
    _isSearchControllerDisposed = true;
    _searchController.dispose();
    super.dispose();
  }

  void _handlePop() {
    if (!_isSearchControllerDisposed) {
      _searchController.closeView(null);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 50,
        title: _buildSearchBar(),
      ),
      body: const SizedBox.expand(),
    );
  }

  Widget _buildSearchBar() {
    return SearchAnchor(
      searchController: _searchController,
      viewLeading: IconButton(
        onPressed: _handlePop,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      viewBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      builder: (context, controller) {
        if (_isSearchControllerDisposed) return const SizedBox.shrink();

        return SearchBar(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          controller: controller,
          leading: const Icon(Icons.search),
          hintText: 'Search word',
          backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surfaceContainer),
          trailing: [
            IconButton(
              onPressed: () {
                controller.clear();
                if (controller.isOpen && !_isSearchControllerDisposed) {
                  controller.closeView(null);
                }
              },
              icon: const Icon(Icons.clear),
            )
          ],
          onTap: () {
            if (!_isSearchControllerDisposed) {
              controller.openView();
            }
          },
          onChanged: (_) {
            if (!_isSearchControllerDisposed) {
              controller.openView();
            }
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        if (_isSearchControllerDisposed) return [];

        final query = controller.text;
        final words = all
            .where((word) => word.toLowerCase().startsWith(query))
            .toList();

        return words.map((word) {
          return ListTile(
            leading: const Icon(Icons.search),
            trailing: Transform.rotate(
              angle: -45 * 3.1415926535897932 / 180,
              child: const Icon(Icons.arrow_upward_rounded),
            ),
            title: Text(word),
            onTap: () {
              if (!_isSearchControllerDisposed && context.mounted) {
                controller.closeView(word);
                controller.text = word;
              }
            },
          );
        });
      },
    );
  }
}
