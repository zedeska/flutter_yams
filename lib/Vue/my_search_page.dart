import 'package:flutter/material.dart';
import '../Modele/api.dart';
import 'my_app_bar.dart';

enum SearchType { tracks, albums }

class MySearchPage extends StatefulWidget {
  final String? initialQuery;
  const MySearchPage({super.key, this.initialQuery});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {

  final Api api = Api();
  Map<String, dynamic>? searchResults;
  bool isLoading = false;

  SearchType selectedType = SearchType.tracks;
  List selectedResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      // Start loading immediately to show spinner
      isLoading = true;
      // Schedule the search to run after the first frame to avoid context errors
      WidgetsBinding.instance.addPostFrameCallback((_) {
        performSearch(widget.initialQuery!);
      });
    }
  }

  void performSearch(String query) async {
    if (query.isEmpty) return;

    // Close keyboard if context is available
    if (mounted) {
      FocusScope.of(context).unfocus();
    }

    setState(() {
      isLoading = true;
    });

    try {
      final results = await api.search(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      debugPrint('Error performing search: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(onSearch: performSearch),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchResults == null) {
      return const Center(child: Text('Enter a search term to begin'));
    }

    // Pass the searchResults around or display them in a list
    // This part depends on the structure of your API response.
    return SingleChildScrollView(
      child: Column(
        children: [
          SegmentedButton<SearchType>(
            segments: const <ButtonSegment<SearchType>>[
              ButtonSegment<SearchType>(
                value: SearchType.tracks,
                label: Text("Songs"),
                icon: Icon(Icons.music_note),
              ),
              ButtonSegment<SearchType>(
                value: SearchType.albums,
                label: Text("Albums"),
                icon: Icon(Icons.album),
              ),
            ],
            selected: <SearchType>{selectedType},
            onSelectionChanged: (Set<SearchType> newSelection) { 
              setState(() { 
                selectedType = newSelection.first;
              });
            },
          ),

          const SizedBox(height: 10),

          Column(
            children: [
              Text('${searchResults?[selectedType.toString()]} :'),
              Row(
                children: [
                  searchResults?[selectedType.toString()].value is List
                      ? Expanded(
                          child: Column(
                            children: [
                              for (var item in entry.value)
                                Text('- ${item['title']}'),
                            ],
                          ),
                        )
                      : Text('${entry.value}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
