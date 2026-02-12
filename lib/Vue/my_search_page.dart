import 'package:flutter/material.dart';
import '../Modele/api.dart';
import 'my_app_bar.dart';

enum SearchType {
  tracks,
  albums;

  @override
  String toString() => name;
}

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
  bool isDownloading = false;

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
        selectedResults = searchResults?[selectedType.toString()] ?? [];
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

  void downloadTrack(String title, String trackId, String platforme) async {
    setState(() {
      isDownloading = true;
    });
    try {
      final file = await api.downloadTrack(title, trackId, platforme);
      
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Track downloaded to: ${file.path}')));
      }
    } catch (e) {
      debugPrint('Error downloading track: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error downloading track: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(onSearch: performSearch),
      body: Column(
        children: [
          if (isDownloading) const LinearProgressIndicator(),
          Expanded(child: _buildBody(context)),
        ],
      ),
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
                selectedResults = searchResults?[selectedType.toString()] ?? [];
              });
            },
          ),

          const SizedBox(height: 10),

          selectedResults.isNotEmpty
              ? Column(
                  children: [
                    for (var item in selectedResults)
                      Card(
                        child: ListTile(
                          leading: Icon(
                            selectedType == SearchType.tracks
                                ? Icons.music_note
                                : Icons.album,
                          ),
                          title: Text("${item["title"]}"),
                          trailing: IconButton(
                            onPressed: () => downloadTrack(item["title"], item["id"].toString(), item["platform"]),
                            icon: const Icon(Icons.download),
                          ),
                        ),
                      ),
                  ],
                )
              : const Text('No results found'),
        ],
      ),
    );
  }
}
