import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';

class DashboardHeader extends StatelessWidget {
  final List<Tutorial> tutorials;
  final Function onAdd;
  final bool isLoading;

  const DashboardHeader({
    super.key,
    required this.tutorials,
    required this.onAdd,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate metrics
    final int totalCount = tutorials.length;
    final int publishedCount = tutorials.where((tutorial) => tutorial.published).length;
    final int featuredCount = tutorials.where((tutorial) => tutorial.featured).length;
    
    // Get categories count
    Map<String, int> categoryCounts = {};
    for (var tutorial in tutorials) {
      if (tutorial.category != null && tutorial.category!.isNotEmpty) {
        categoryCounts[tutorial.category!] = (categoryCounts[tutorial.category!] ?? 0) + 1;
      }
    }
    
    // Get most popular category
    String mostPopularCategory = 'None';
    int maxCount = 0;
    categoryCounts.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostPopularCategory = category;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tutorial Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your educational content',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('New Tutorial'),
                onPressed: () => onAdd(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
        
        // Stats Cards
        if (isLoading)
          _buildLoadingStats()
        else
          Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard(
                    'Total Tutorials',
                    totalCount.toString(),
                    Icons.library_books,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Published',
                    publishedCount.toString(),
                    Icons.public,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Featured',
                    featuredCount.toString(),
                    Icons.star,
                    Colors.amber,
                  ),
                  _buildStatCard(
                    'Popular Category',
                    mostPopularCategory,
                    Icons.category,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          
        // Filter section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'All Tutorials',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.more_horiz,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingStats() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            4, 
            (index) => Container(
              width: 160,
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
