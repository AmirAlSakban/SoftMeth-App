import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:tutorial_management_app/services/api_service.dart';
import 'package:tutorial_management_app/screens/edit_tutorial_screen.dart';
import 'package:tutorial_management_app/widgets/loading_states.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class TutorialDetailScreen extends StatefulWidget {
  final Tutorial tutorial;
  final int initialTab;

  const TutorialDetailScreen({
    super.key, 
    required this.tutorial,
    this.initialTab = 0,
  });

  @override
  _TutorialDetailScreenState createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  final ApiService _apiService = ApiService();
  late Tutorial _tutorial;
  bool _isLoading = false;
  String? _error;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tutorial = widget.tutorial;
  }

  Future<void> _deleteTutorial() async {
    final bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tutorial'),
        content: Text('Are you sure you want to delete "${_tutorial.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('DELETE'),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      try {
        await _apiService.deleteTutorial(_tutorial.id!);
        Navigator.pop(context, true); // Return true to trigger refresh
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete tutorial: $_error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _togglePublished() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final updatedTutorial = Tutorial(
        id: _tutorial.id,
        title: _tutorial.title,
        description: _tutorial.description,
        published: !_tutorial.published,
        category: _tutorial.category,
        author: _tutorial.author,
        difficultyLevel: _tutorial.difficultyLevel,
        durationMinutes: _tutorial.durationMinutes,
        featured: _tutorial.featured,
        imageUrl: _tutorial.imageUrl,
        videoUrl: _tutorial.videoUrl,
      );
      
      final result = await _apiService.updateTutorial(_tutorial.id!, updatedTutorial);
      
      setState(() {
        _tutorial = result;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tutorial ${_tutorial.published ? 'published' : 'unpublished'}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update tutorial: $_error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleFeatured() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final updatedTutorial = Tutorial(
        id: _tutorial.id,
        title: _tutorial.title,
        description: _tutorial.description,
        published: _tutorial.published,
        category: _tutorial.category,
        author: _tutorial.author,
        difficultyLevel: _tutorial.difficultyLevel,
        durationMinutes: _tutorial.durationMinutes,
        featured: !_tutorial.featured,
        imageUrl: _tutorial.imageUrl,
        videoUrl: _tutorial.videoUrl,
      );
      
      final result = await _apiService.updateTutorial(_tutorial.id!, updatedTutorial);
      
      setState(() {
        _tutorial = result;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tutorial ${_tutorial.featured ? 'marked as featured' : 'removed from featured'}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update tutorial: $_error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _editTutorial() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTutorialScreen(tutorial: _tutorial),
      ),
    );
    
    if (result != null) {
      setState(() {
        _tutorial = result;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open URL: $url'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab,
      child: Scaffold(
        body: _isLoading
            ? const LoadingIndicator(isFullScreen: true)
            : CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 200.0,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(_tutorial.title),
                      background: _tutorial.imageUrl != null && _tutorial.imageUrl!.isNotEmpty
                          ? Image.network(
                              _tutorial.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                            )
                          : _buildPlaceholderImage(),
                    ),
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'Details', icon: Icon(Icons.info_outline)),
                        Tab(text: 'Edit', icon: Icon(Icons.edit)),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(_tutorial.featured ? Icons.star : Icons.star_border),
                        onPressed: _toggleFeatured,
                        tooltip: _tutorial.featured ? 'Remove from featured' : 'Mark as featured',
                      ),
                      IconButton(
                        icon: Icon(_tutorial.published ? Icons.public : Icons.public_off),
                        onPressed: _togglePublished,
                        tooltip: _tutorial.published ? 'Unpublish' : 'Publish',
                      ),
                    ],
                  ),
                  
                  SliverFillRemaining(
                    child: TabBarView(
                      children: [
                        // Details Tab
                        _buildDetailsTab(),
                        
                        // Edit Tab
                        _buildEditTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.blue.shade100,
      child: Center(
        child: Icon(
          Icons.school,
          size: 64,
          color: Colors.blue.shade300,
        ),
      ),
    );
  }
  
  Widget _buildDetailsTab() {
    final dateFormat = DateFormat('MMM d, yyyy h:mm a');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _tutorial.description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          
          // Metadata Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tutorial Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Category', _tutorial.category),
                  _buildDetailRow('Author', _tutorial.author),
                  _buildDetailRow('Difficulty Level', _tutorial.difficultyLevel),
                  _buildDetailRow('Duration', _tutorial.durationMinutes != null ? '${_tutorial.durationMinutes} minutes' : null),
                  _buildDetailRow('Status', _tutorial.published ? 'Published' : 'Draft', _tutorial.published ? Colors.green : Colors.grey),
                  _buildDetailRow('Featured', _tutorial.featured ? 'Yes' : 'No', _tutorial.featured ? Colors.amber : null),
                  _buildDetailRow('Created', _tutorial.createdAt != null ? dateFormat.format(_tutorial.createdAt!) : null),
                  _buildDetailRow('Last Updated', _tutorial.updatedAt != null ? dateFormat.format(_tutorial.updatedAt!) : null),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Media Links
          if (_tutorial.videoUrl != null && _tutorial.videoUrl!.isNotEmpty) ...[
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Video Tutorial'),
              subtitle: Text(_tutorial.videoUrl!),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchUrl(_tutorial.videoUrl!),
              tileColor: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.blue.shade200),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Delete Button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete Tutorial'),
                onPressed: _deleteTutorial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEditTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.edit_note,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Edit Tutorial',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Update tutorial details, change settings, or modify content.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit Tutorial'),
              onPressed: _editTutorial,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String? value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not specified',
              style: TextStyle(
                color: value == null ? Colors.grey : (valueColor ?? Colors.black87),
                fontStyle: value == null ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
