import 'package:flutter/material.dart';
import 'package:myapp/widget/news_tile.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool isSelectionMode = false; // Tracks whether selection mode is active
  final List<int> selectedBookmarks = []; // Tracks selected bookmarks' indices

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSelectionMode
            ? Text('${selectedBookmarks.length} selected')
            : const Text('Bookmarked Articles'),
        actions: [
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  isSelectionMode = true; // Enable selection mode
                });
              },
            ),
          if (isSelectionMode)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _deleteSelectedBookmarks, // Trigger deletion
            ),
        ],
      ),
      body: bookmarkedArticles.isEmpty
          ? Center(
              child: Text(
                'No articles bookmarked yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                final isSelected = selectedBookmarks.contains(index);
                return GestureDetector(
                  onTap: () {
                    if (isSelectionMode) {
                      _toggleSelection(index); // Toggle selection
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 5,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (article['imageUrl'] ?? '').isNotEmpty
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(10.0)),
                                    child: Image.network(
                                      article['imageUrl']!,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title'] ?? 'Untitled',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    article['description'] ??
                                        'No description available.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  if (article['shortname'] != null &&
                                      article['shortname']!.isNotEmpty)
                                    Text(
                                      'Shortname: ${article['shortname']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  if (!isSelectionMode)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () =>
                                              _showEditShortnameDialog(
                                                  context, article, index),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () =>
                                              _showDeleteConfirmationDialog(
                                                  context, index),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (isSelectionMode)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                _toggleSelection(index);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Toggle the selection of a bookmark
  void _toggleSelection(int index) {
    setState(() {
      if (selectedBookmarks.contains(index)) {
        selectedBookmarks.remove(index);
      } else {
        selectedBookmarks.add(index);
      }
    });
  }

  // Delete selected bookmarks
  void _deleteSelectedBookmarks() {
    setState(() {
      selectedBookmarks
          .sort((a, b) => b.compareTo(a)); // Sort indices in reverse
      for (int index in selectedBookmarks) {
        bookmarkedArticles.removeAt(index);
      }
      selectedBookmarks.clear();
      isSelectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected bookmarks deleted.')),
    );
  }

  // Show dialog to edit shortname
  void _showEditShortnameDialog(
      BuildContext context, Map<String, String> article, int index) {
    final shortnameController =
        TextEditingController(text: article['shortname'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Shortname'),
          content: TextField(
            controller: shortnameController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Shortname'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  bookmarkedArticles[index]['shortname'] =
                      shortnameController.text;
                });
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                        content: Text('Shortname updated successfully!')),
                  );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog for deleting shortname
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Shortname'),
          content: const Text(
              'Are you sure you want to delete this shortname? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  bookmarkedArticles[index].remove('shortname');
                });
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(content: Text('Shortname deleted.')),
                  );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
