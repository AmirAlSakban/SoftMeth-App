import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:tutorial_management_app/theme/app_theme.dart';
import 'package:tutorial_management_app/screens/tutorial_list_screen_enhanced.dart';
import 'package:tutorial_management_app/screens/tutorial_detail_screen_enhanced.dart';
import 'package:tutorial_management_app/screens/add_tutorial_screen_enhanced.dart';
import 'package:tutorial_management_app/screens/analytics_dashboard_screen.dart';
import 'package:tutorial_management_app/widgets/comments_section.dart';
import 'package:tutorial_management_app/widgets/tutorial_content_editor.dart';
import 'package:tutorial_management_app/widgets/statistics_widget.dart';

class UIShowcaseScreen extends StatefulWidget {
  @override
  _UIShowcaseScreenState createState() => _UIShowcaseScreenState();
}

class _UIShowcaseScreenState extends State<UIShowcaseScreen> {
  final List<Widget> _screens = [];
  int _currentIndex = 0;
  
  // Sample tutorials for demonstration
  final List<Tutorial> _sampleTutorials = [
    Tutorial(
      id: 1,
      title: 'Getting Started with Flutter',
      description: 'A comprehensive guide for beginners to get started with Flutter development. Learn the basics of widgets, state management, and building your first app.',
      category: 'Mobile Development',
      author: 'John Doe',
      difficultyLevel: 'Beginner',
      durationMinutes: 30,
      published: true,
      featured: true,
      imageUrl: 'https://picsum.photos/seed/flutter1/800/600',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Tutorial(
      id: 2,
      title: 'Advanced State Management in Flutter',
      description: 'Dive deep into state management solutions in Flutter including Provider, Bloc, and Riverpod. Learn when to use each approach.',
      category: 'Mobile Development',
      author: 'Jane Smith',
      difficultyLevel: 'Intermediate',
      durationMinutes: 60,
      published: true,
      featured: false,
      imageUrl: 'https://picsum.photos/seed/flutter2/800/600',
      createdAt: DateTime.now().subtract(Duration(days: 20)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Tutorial(
      id: 3,
      title: 'Building a REST API with Spring Boot',
      description: 'Learn how to create a robust REST API using Spring Boot, JPA, and H2 Database. Includes authentication and documentation.',
      category: 'Backend Development',
      author: 'Robert Johnson',
      difficultyLevel: 'Advanced',
      durationMinutes: 90,
      published: true,
      featured: true,
      imageUrl: 'https://picsum.photos/seed/spring1/800/600',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      updatedAt: DateTime.now().subtract(Duration(days: 3)),
    ),
    Tutorial(
      id: 4,
      title: 'Introduction to React Hooks',
      description: 'Get started with React Hooks and learn how to use useState, useEffect, useContext, and custom hooks in your applications.',
      category: 'Web Development',
      author: 'Sarah Lee',
      difficultyLevel: 'Intermediate',
      durationMinutes: 45,
      published: true,
      featured: false,
      imageUrl: 'https://picsum.photos/seed/react1/800/600',
      createdAt: DateTime.now().subtract(Duration(days: 10)),
      updatedAt: DateTime.now().subtract(Duration(days: 5)),
    ),
    Tutorial(
      id: 5,
      title: 'Machine Learning Basics with Python',
      description: 'Introduction to Machine Learning concepts using Python, NumPy, and scikit-learn. Build your first ML model.',
      category: 'Data Science',
      author: 'Michael Chen',
      difficultyLevel: 'Intermediate',
      durationMinutes: 120,
      published: false,
      featured: false,
      imageUrl: 'https://picsum.photos/seed/ml1/800/600',
      createdAt: DateTime.now().subtract(Duration(days: 8)),
      updatedAt: DateTime.now().subtract(Duration(days: 8)),
    ),
    Tutorial(
      id: 6,
      title: 'Docker for Beginners',
      description: 'Learn the fundamentals of containerization with Docker. Create, run, and manage containers for your applications.',
      category: 'DevOps',
      author: 'John Doe',
      difficultyLevel: 'Beginner',
      durationMinutes: 60,
      published: true,
      featured: false,
      imageUrl: 'https://picsum.photos/seed/docker1/800/600',
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Tutorial(
      id: 7,
      title: 'CSS Grid and Flexbox Masterclass',
      description: 'Master modern CSS layout techniques with Grid and Flexbox. Create responsive designs without frameworks.',
      category: 'Web Development',
      author: 'Sarah Lee',
      difficultyLevel: 'Intermediate',
      durationMinutes: 75,
      published: true,
      featured: true,
      imageUrl: 'https://picsum.photos/seed/css1/800/600',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      updatedAt: DateTime.now().subtract(Duration(days: 0)),
    ),
  ];
  
  // Sample comments
  final List<Comment> _sampleComments = [
    Comment(
      id: '1',
      authorName: 'Alex Johnson',
      authorAvatar: 'https://picsum.photos/seed/alex1/100/100',
      content: 'This tutorial was incredibly helpful! I finally understand how to implement this feature in my project.',
      createdAt: DateTime.now().subtract(Duration(days: 3, hours: 5)),
      replies: [
        Comment(
          id: '1-1',
          authorName: 'Tutorial Author',
          authorAvatar: 'https://picsum.photos/seed/author1/100/100',
          content: 'Thanks Alex! I\'m glad you found it useful. Let me know if you have any questions.',
          createdAt: DateTime.now().subtract(Duration(days: 3, hours: 2)),
        ),
      ],
    ),
    Comment(
      id: '2',
      authorName: 'Maria Garcia',
      authorAvatar: 'https://picsum.photos/seed/maria1/100/100',
      content: 'The explanation on state management was clear, but I\'m still having issues with the provider implementation. Can you provide more examples?',
      createdAt: DateTime.now().subtract(Duration(days: 2, hours: 8)),
      replies: [],
    ),
    Comment(
      id: '3',
      authorName: 'Daniel Kim',
      authorAvatar: 'https://picsum.photos/seed/daniel1/100/100',
      content: 'Great tutorial! I noticed a small typo in the code snippet for the API call function.',
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      replies: [
        Comment(
          id: '3-1',
          authorName: 'Tutorial Author',
          authorAvatar: 'https://picsum.photos/seed/author1/100/100',
          content: 'Good catch, Daniel! I\'ve fixed it in the latest update. Thanks for pointing it out.',
          createdAt: DateTime.now().subtract(Duration(hours: 6)),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize showcase screens
    _screens.addAll([
      TutorialListScreen(), // Enhanced list screen
      AnalyticsDashboardScreen(tutorials: _sampleTutorials), // Analytics dashboard
      AddTutorialScreen(), // Enhanced create screen
      TutorialDetailScreen(tutorial: _sampleTutorials[0]), // Enhanced detail screen
      _buildWidgetsShowcase(), // Widgets showcase
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Tutorials',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Detail',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets),
            label: 'Widgets',
          ),
        ],
      ),
    );
  }
  
  Widget _buildWidgetsShowcase() {
    return Scaffold(
      appBar: AppBar(
        title: Text('UI Components'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UI Components Showcase',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: 24),
            
            // Statistics Widget
            _buildSectionHeader('Statistics Widget'),
            StatisticsWidget(
              title: 'Tutorial Difficulty Distribution',
              data: {
                'Beginner': 12,
                'Intermediate': 8,
                'Advanced': 5,
              },
              showChart: true,
            ),
            SizedBox(height: 24),
            
            // Comments Section
            _buildSectionHeader('Comments Section'),
            CommentsSection(
              comments: _sampleComments,
              onAddComment: (comment) {
                // This would add a comment in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Comment added: $comment')),
                );
              },
              onReplyToComment: (commentId, reply) {
                // This would reply to a comment in a real app
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reply to comment $commentId: $reply')),
                );
              },
            ),
            SizedBox(height: 24),
            
            // Content Editor
            _buildSectionHeader('Content Editor'),
            TutorialContentEditor(
              initialValue: '# Tutorial Content Example\n\nThis is a **rich text editor** that supports markdown-like formatting.\n\n## Key Features\n\n- Easy to use\n- Formatting support\n- Live preview',
              hintText: 'Write your tutorial content here...',
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
