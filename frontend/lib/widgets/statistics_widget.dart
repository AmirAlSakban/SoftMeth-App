import 'package:flutter/material.dart';
import 'package:tutorial_management_app/theme/app_theme.dart';
import 'dart:math';

class StatisticsWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? title;
  final bool showChart;

  const StatisticsWidget({
    super.key,
    required this.data,
    this.title,
    this.showChart = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            
            // Main content
            if (showChart && data.length > 1)
              _buildChart(context)
            else
              _buildSimpleStats(context),
              
          ],
        ),
      ),
    );
  }
  
  Widget _buildSimpleStats(BuildContext context) {
    return Column(
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                entry.value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildChart(BuildContext context) {
    // For demo purposes, we'll create a simple horizontal bar chart
    final maxValue = data.values.whereType<num>().fold<num>(0, (a, b) => max(a, b));
    
    return Column(
      children: data.entries.map((entry) {
        // Skip non-numeric values
        if (entry.value is! num) return const SizedBox.shrink();
        
        final value = entry.value as num;
        final percentage = maxValue > 0 ? value / maxValue : 0;
        
        // Choose a color based on the key
        final Color barColor = _getColorForKey(entry.key);
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  // Background
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Foreground
                  Container(
                    height: 8,
                    width: MediaQuery.of(context).size.width * percentage * 0.8, // 80% of screen width max
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  
  Color _getColorForKey(String key) {
    // Choose a color based on the key
    final String lowerKey = key.toLowerCase();
    
    if (lowerKey.contains('published')) return AppTheme.successColor;
    if (lowerKey.contains('draft')) return Colors.grey;
    if (lowerKey.contains('featured')) return AppTheme.warningColor;
    if (lowerKey.contains('beginner')) return Colors.green;
    if (lowerKey.contains('intermediate')) return Colors.orange;
    if (lowerKey.contains('advanced')) return Colors.red;
    
    // Generate a color based on the key string
    final int hash = key.hashCode;
    final List<Color> colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.accentColor,
      AppTheme.warningColor,
      AppTheme.infoColor,
    ];
    
    return colors[hash.abs() % colors.length];
  }
}
