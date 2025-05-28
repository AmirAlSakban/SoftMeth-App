import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:tutorial_management_app/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddTutorialScreen extends StatefulWidget {
  const AddTutorialScreen({Key? key}) : super(key: key);

  @override
  _AddTutorialScreenState createState() => _AddTutorialScreenState();
}

class _AddTutorialScreenState extends State<AddTutorialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _authorController = TextEditingController();
  final _durationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();
  
  bool _isPublished = false;
  bool _isFeatured = false;
  bool _isLoading = false;
  File? _selectedImage;
  bool _showErrors = false;

  final List<String> _difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  String _selectedDifficulty = 'Beginner';

  // Popular categories to suggest to the user
  final List<String> _popularCategories = [
    'Programming', 'Web Development', 'Mobile Apps', 
    'Data Science', 'Machine Learning', 'Design',
    'DevOps', 'Cloud Computing', 'Cybersecurity'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _authorController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // This is just a mock function since we're just creating UI
    // In a real app, this would use ImagePicker to select an image
    setState(() {
      _selectedImage = null; // We'd set this to the picked image file
      _imageUrlController.text = "https://picsum.photos/seed/tutorial/800/600";
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picked successfully!'),
        backgroundColor: AppTheme.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveTutorial() async {
    setState(() {
      _showErrors = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would actually create the tutorial
      final tutorial = Tutorial(
        id: 0, // Will be assigned by backend
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categoryController.text.trim(),
        author: _authorController.text.trim(),
        difficultyLevel: _selectedDifficulty,
        durationMinutes: int.tryParse(_durationController.text) ?? 0,
        published: _isPublished,
        featured: _isFeatured,
        imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
        videoUrl: _videoUrlController.text.trim().isEmpty ? null : _videoUrlController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Simulate API delay
      await Future.delayed(Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tutorial created successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop(tutorial);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create tutorial: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: _popularCategories.map((category) => ActionChip(
        avatar: Icon(Icons.category, size: 18, color: AppTheme.primaryColor),
        label: Text(category),
        onPressed: () {
          setState(() {
            _categoryController.text = category;
          });
        },
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Tutorial'),
        elevation: 0,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveTutorial,
              child: const Text(
                'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _showErrors 
            ? AutovalidateMode.always 
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tutorial Preview Card
              if (_titleController.text.isNotEmpty)
                Card(
                  margin: EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preview header
                      Container(
                        padding: EdgeInsets.all(12),
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: Row(
                          children: [
                            Icon(Icons.preview, color: AppTheme.primaryColor),
                            SizedBox(width: 8),
                            Text(
                              'Preview',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Image preview if available
                      if (_selectedImage != null || _imageUrlController.text.isNotEmpty)
                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _selectedImage != null
                                  ? FileImage(_selectedImage!) as ImageProvider
                                  : NetworkImage(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _titleController.text.isEmpty 
                                        ? 'Tutorial Title' 
                                        : _titleController.text,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (_isFeatured)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.warningColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'FEATURED',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _isPublished ? AppTheme.successColor : Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _isPublished ? 'PUBLISHED' : 'DRAFT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              _descriptionController.text.isEmpty 
                                  ? 'Tutorial description will appear here...' 
                                  : _descriptionController.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                if (_categoryController.text.isNotEmpty) ...[
                                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Text(
                                    _categoryController.text,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  SizedBox(width: 16),
                                ],
                                if (_authorController.text.isNotEmpty) ...[
                                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Text(
                                    _authorController.text,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  SizedBox(width: 16),
                                ],
                                if (_durationController.text.isNotEmpty) ...[
                                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Text(
                                    '${_durationController.text} min',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Basic Information Card
              Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title *',
                          hintText: 'Enter a clear, descriptive title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                          helperText: 'Use a concise, informative title',
                        ),
                        onChanged: (value) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required';
                          }
                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          hintText: 'Explain what this tutorial is about',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          helperText: 'Provide a detailed description (at least 10 characters)',
                        ),
                        onChanged: (value) => setState(() {}),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description is required';
                          }
                          if (value.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _categoryController,
                              decoration: const InputDecoration(
                                labelText: 'Category *',
                                hintText: 'e.g., Programming, Design',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category),
                              ),
                              onChanged: (value) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Category is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _authorController,
                              decoration: const InputDecoration(
                                labelText: 'Author *',
                                hintText: 'Your name or username',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person),
                              ),
                              onChanged: (value) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Author is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Suggested Categories:',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryChips(),
                    ],
                  ),
                ),
              ),

              // Tutorial Details Card
              Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tutorial Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedDifficulty,
                              decoration: const InputDecoration(
                                labelText: 'Difficulty Level',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.signal_cellular_alt),
                              ),
                              items: _difficulties.map((difficulty) {
                                return DropdownMenuItem(
                                  value: difficulty,
                                  child: Text(difficulty),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDifficulty = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              decoration: const InputDecoration(
                                labelText: 'Duration (minutes)',
                                hintText: 'e.g., 30',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.timer),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => setState(() {}),
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final duration = int.tryParse(value);
                                  if (duration == null || duration <= 0) {
                                    return 'Enter a valid duration';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Media Card
              Card(
                margin: EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Media',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Image picker field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Image',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: _pickImage,
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: AppTheme.inputBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.borderColor),
                              ),
                              child: _selectedImage != null || _imageUrlController.text.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _selectedImage != null
                                        ? Image.file(
                                            _selectedImage!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : Image.network(
                                            _imageUrlController.text,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          size: 48,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Tap to add an image',
                                          style: TextStyle(
                                            color: AppTheme.textSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL (optional)',
                          hintText: 'Enter URL for an online image',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.image),
                          helperText: 'Or enter a direct URL to an image',
                        ),
                        onChanged: (value) => setState(() {}),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!Uri.tryParse(value)?.hasAbsolutePath == true) {
                              return 'Enter a valid URL';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _videoUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Video URL (optional)',
                          hintText: 'e.g., YouTube or Vimeo link',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.video_library),
                          helperText: 'Link to a video that accompanies this tutorial',
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (!Uri.tryParse(value)?.hasAbsolutePath == true) {
                              return 'Enter a valid URL';
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Publication Settings Card
              Card(
                margin: EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Publication Settings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: const Text('Published'),
                        subtitle: const Text('Make this tutorial visible to users'),
                        value: _isPublished,
                        onChanged: (value) {
                          setState(() {
                            _isPublished = value;
                          });
                        },
                        activeColor: AppTheme.successColor,
                        secondary: Icon(
                          _isPublished ? Icons.visibility : Icons.visibility_off,
                          color: _isPublished ? AppTheme.successColor : Colors.grey,
                        ),
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Featured'),
                        subtitle: const Text('Highlight this tutorial on the homepage'),
                        value: _isFeatured,
                        onChanged: (value) {
                          setState(() {
                            _isFeatured = value;
                          });
                        },
                        activeColor: AppTheme.warningColor,
                        secondary: Icon(
                          _isFeatured ? Icons.star : Icons.star_border,
                          color: _isFeatured ? AppTheme.warningColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveTutorial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Creating Tutorial...'),
                        ],
                      )
                    : const Text(
                        'Create Tutorial',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
