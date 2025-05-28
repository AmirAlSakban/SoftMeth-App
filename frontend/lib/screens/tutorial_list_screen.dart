import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:tutorial_management_app/services/api_service.dart';
import 'package:tutorial_management_app/screens/tutorial_detail_screen.dart';
import 'package:tutorial_management_app/screens/add_tutorial_screen.dart';
import 'package:tutorial_management_app/screens/edit_tutorial_screen.dart';

class TutorialListScreen extends StatefulWidget {
  const TutorialListScreen({super.key});

  @override
  _TutorialListScreenState createState() => _TutorialListScreenState();
}

class _TutorialListScreenState extends State<TutorialListScreen> {
  final ApiService _apiService = ApiService();
  List<Tutorial> _tutorials = [];
  List<Tutorial> _filteredTutorials = [];
  bool _isLoading = true;
  String _error = '';
  final TextEditingController _searchController = TextEditingController();
  bool _showPublishedOnly = false;
  String? _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadTutorials();
    _searchController.addListener(_filterTutorials);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTutorials() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      List<Tutorial> tutorials;
      if (_showPublishedOnly) {
        tutorials = await _apiService.getPublishedTutorials();
      } else {
        tutorials = await _apiService.getAllTutorials();
      }
      
      // Extract unique categories
      Set<String> categorySet = {};
      for (var tutorial in tutorials) {
        if (tutorial.category != null && tutorial.category!.isNotEmpty) {
          categorySet.add(tutorial.category!);
        }
      }
      
      setState(() {
        _tutorials = tutorials;
        _filteredTutorials = tutorials;
        _categories = categorySet.toList()..sort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterTutorials() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTutorials = _tutorials.where((tutorial) {
        return tutorial.title.toLowerCase().contains(query) ||
               tutorial.description.toLowerCase().contains(query) ||
               (tutorial.category?.toLowerCase().contains(query) ?? false) ||
               (tutorial.author?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void _togglePublishedFilter() {
    setState(() {
      _showPublishedOnly = !_showPublishedOnly;
    });
    _loadTutorials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial Management'),
        actions: [
          IconButton(
            icon: Icon(_showPublishedOnly ? Icons.visibility : Icons.visibility_off),
            onPressed: _togglePublishedFilter,
            tooltip: _showPublishedOnly ? 'Show All' : 'Show Published Only',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTutorials,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tutorials...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error: $_error', textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadTutorials,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _filteredTutorials.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  _tutorials.isEmpty 
                                      ? 'No tutorials available.\nTap + to add your first tutorial!'
                                      : 'No tutorials match your search.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredTutorials.length,
                            itemBuilder: (context, index) {
                              return _buildTutorialCard(_filteredTutorials[index]);
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTutorialScreen()),
          );
          if (result != null) {
            _loadTutorials();
          }
        },
        tooltip: 'Add Tutorial',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTutorialCard(Tutorial tutorial) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorialDetailScreen(tutorial: tutorial),
            ),
          );
          if (result == true) {
            _loadTutorials();
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tutorial.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (tutorial.featured)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tutorial.published ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tutorial.published ? 'PUBLISHED' : 'DRAFT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTutorialScreen(tutorial: tutorial),
                        ),
                      );
                      if (result != null) {
                        _loadTutorials();
                      }
                    },
                    tooltip: 'Edit Tutorial',
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tutorial.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (tutorial.category != null) ...[
                    Icon(Icons.category, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      tutorial.category!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (tutorial.author != null) ...[
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      tutorial.author!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (tutorial.durationMinutes != null) ...[
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${tutorial.durationMinutes} min',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
