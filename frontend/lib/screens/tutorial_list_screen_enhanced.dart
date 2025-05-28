import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:tutorial_management_app/services/api_service.dart';
import 'package:tutorial_management_app/screens/tutorial_detail_screen.dart';
import 'package:tutorial_management_app/screens/add_tutorial_screen.dart';
import 'package:tutorial_management_app/widgets/tutorial_card.dart';
import 'package:tutorial_management_app/widgets/dashboard_header.dart';
import 'package:tutorial_management_app/widgets/search_filter_bar.dart';
import 'package:tutorial_management_app/widgets/loading_states.dart';

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
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  bool _showPublishedOnly = false;
  String? _selectedCategory;
  List<String> _categories = [];
  bool _isRefreshing = false;

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
    if (_isRefreshing) return;
    
    setState(() {
      _isLoading = _tutorials.isEmpty;
      _isRefreshing = _tutorials.isNotEmpty;
      _error = null;
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
        _filterTutorials();
        _categories = categorySet.toList()..sort();
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  void _filterTutorials() {
    final String searchTerm = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredTutorials = _tutorials.where((tutorial) {
        final titleMatch = tutorial.title.toLowerCase().contains(searchTerm);
        final descriptionMatch = tutorial.description.toLowerCase().contains(searchTerm);
        final publishedMatch = _showPublishedOnly ? tutorial.published : true;
        final categoryMatch = _selectedCategory != null 
            ? tutorial.category == _selectedCategory
            : true;
        
        return (titleMatch || descriptionMatch) && publishedMatch && categoryMatch;
      }).toList();
    });
  }

  void _togglePublishedFilter(bool value) {
    setState(() {
      _showPublishedOnly = value;
      _filterTutorials();
    });
  }
  
  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
      _filterTutorials();
    });
  }

  void _navigateToAddTutorial() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTutorialScreen()),
    );
    
    if (result == true) {
      _loadTutorials();
    }
  }
  
  void _navigateToTutorialDetail(Tutorial tutorial) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TutorialDetailScreen(tutorial: tutorial),
      ),
    );
    
    if (result == true) {
      _loadTutorials();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadTutorials,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Tutorial Management'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade800, Colors.blue.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(_showPublishedOnly ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => _togglePublishedFilter(!_showPublishedOnly),
                  tooltip: _showPublishedOnly ? 'Show All' : 'Show Published Only',
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadTutorials,
                ),
              ],
            ),
            
            // Dashboard Header
            SliverToBoxAdapter(
              child: DashboardHeader(
                tutorials: _tutorials,
                onAdd: _navigateToAddTutorial,
                isLoading: _isLoading,
              ),
            ),
            
            // Search & Filter Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SearchFilterBar(
                  searchController: _searchController,
                  showPublishedOnly: _showPublishedOnly,
                  onTogglePublished: _togglePublishedFilter,
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: _onCategoryChanged,
                ),
              ),
            ),
            
            // Loading State
            if (_isLoading)
              const SliverFillRemaining(
                child: LoadingIndicator(message: 'Loading tutorials...'),
              )
            // Error State
            else if (_error != null)
              SliverFillRemaining(
                child: ErrorStateWidget(
                  message: _error!,
                  onAction: _loadTutorials,
                ),
              )
            // Empty State
            else if (_filteredTutorials.isEmpty)
              SliverFillRemaining(
                child: EmptyStateWidget(
                  message: _tutorials.isEmpty 
                      ? 'No tutorials available.\nTap the + button to add your first tutorial!'
                      : 'No tutorials match your search criteria.',
                  icon: Icons.school_outlined,
                  actionLabel: _tutorials.isEmpty ? 'Add Tutorial' : 'Clear Filters',
                  onAction: _tutorials.isEmpty 
                      ? _navigateToAddTutorial
                      : () {
                          _searchController.clear();
                          _selectedCategory = null;
                          _showPublishedOnly = false;
                          _filterTutorials();
                        },
                ),
              )
            // Tutorial List
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tutorial = _filteredTutorials[index];
                      return TutorialCard(
                        tutorial: tutorial,
                        onTap: () => _navigateToTutorialDetail(tutorial),
                        onEdit: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorialDetailScreen(
                                tutorial: tutorial,
                              ),
                            ),
                          );
                          if (result == true) _loadTutorials();
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Tutorial'),
                              content: Text('Are you sure you want to delete "${tutorial.title}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: Text('DELETE'),
                                ),
                              ],
                            ),
                          );
                          
                          if (confirm == true) {
                            try {
                              await _apiService.deleteTutorial(tutorial.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Tutorial deleted'))
                              );
                              _loadTutorials();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete tutorial: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                )
                              );
                            }
                          }
                        },
                      );
                    },
                    childCount: _filteredTutorials.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTutorial,
        tooltip: 'Add Tutorial',
        child: Icon(Icons.add),
      ),
    );
  }
}
