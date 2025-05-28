import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:tutorial_management_app/services/api_service.dart';
import 'package:tutorial_management_app/screens/edit_tutorial_screen.dart';

class TutorialDetailScreen extends StatefulWidget {
  final Tutorial tutorial;

  const TutorialDetailScreen({super.key, required this.tutorial});

  @override
  _TutorialDetailScreenState createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  final ApiService _apiService = ApiService();
  late Tutorial _tutorial;

  @override
  void initState() {
    super.initState();
    _tutorial = widget.tutorial;
  }

  Future<void> _deleteTutorial() async {
    try {
      await _apiService.deleteTutorial(_tutorial.id!);
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutorial deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete tutorial: $e')),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Tutorial'),
          content: Text('Are you sure you want to delete "${_tutorial.title}"?'),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTutorial();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTutorialScreen(tutorial: _tutorial),
                ),
              );
              if (result is Tutorial) {
                setState(() {
                  _tutorial = result;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and status
            Row(
              children: [
                Expanded(
                  child: Text(
                    _tutorial.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_tutorial.featured)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _tutorial.published ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _tutorial.published ? 'PUBLISHED' : 'DRAFT',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Image if available
            if (_tutorial.imageUrl != null && _tutorial.imageUrl!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(_tutorial.imageUrl!),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tutorial.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Details
            _buildDetailCard(),
            const SizedBox(height: 24),

            // Video link if available
            if (_tutorial.videoUrl != null && _tutorial.videoUrl!.isNotEmpty) ...[
              Card(
                child: ListTile(
                  leading: const Icon(Icons.play_circle_fill, color: Colors.red),
                  title: const Text('Watch Video'),
                  subtitle: Text(_tutorial.videoUrl!),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    // TODO: Open video URL in browser or video player
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening video: ${_tutorial.videoUrl}')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Metadata
            _buildMetadataCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_tutorial.category != null) _buildDetailRow('Category', _tutorial.category!),
            if (_tutorial.author != null) _buildDetailRow('Author', _tutorial.author!),
            if (_tutorial.difficultyLevel != null) _buildDetailRow('Difficulty', _tutorial.difficultyLevel!),
            if (_tutorial.durationMinutes != null) 
              _buildDetailRow('Duration', '${_tutorial.durationMinutes} minutes'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Metadata',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('ID', _tutorial.id?.toString() ?? 'N/A'),
            if (_tutorial.createdAt != null)
              _buildDetailRow('Created', _formatDateTime(_tutorial.createdAt!)),
            if (_tutorial.updatedAt != null)
              _buildDetailRow('Updated', _formatDateTime(_tutorial.updatedAt!)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
