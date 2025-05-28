import 'package:flutter/material.dart';
import 'package:tutorial_management_app/theme/app_theme.dart';
import 'package:tutorial_management_app/widgets/statistics_widget.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class AnalyticsDashboardScreen extends StatefulWidget {
  final List<Tutorial> tutorials;
  
  const AnalyticsDashboardScreen({
    Key? key,
    required this.tutorials,
  }) : super(key: key);

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, int> _categoriesCount = {};
  Map<String, int> _difficultyLevelsCount = {};
  Map<String, int> _authorCount = {};
  List<MapEntry<String, int>> _topAuthors = [];
  List<MapEntry<String, int>> _topCategories = [];
  
  int _totalTutorials = 0;
  int _publishedTutorials = 0;
  int _draftTutorials = 0;
  int _featuredTutorials = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _analyzeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _analyzeData() {
    _totalTutorials = widget.tutorials.length;
    _publishedTutorials = widget.tutorials.where((t) => t.published).length;
    _draftTutorials = _totalTutorials - _publishedTutorials;
    _featuredTutorials = widget.tutorials.where((t) => t.featured).length;
    
    // Count by category
    _categoriesCount = {};
    for (var tutorial in widget.tutorials) {
      if (tutorial.category != null && tutorial.category!.isNotEmpty) {
        _categoriesCount[tutorial.category!] = (_categoriesCount[tutorial.category!] ?? 0) + 1;
      }
    }
    
    // Count by difficulty level
    _difficultyLevelsCount = {};
    for (var tutorial in widget.tutorials) {
      if (tutorial.difficultyLevel != null && tutorial.difficultyLevel!.isNotEmpty) {
        _difficultyLevelsCount[tutorial.difficultyLevel!] = (_difficultyLevelsCount[tutorial.difficultyLevel!] ?? 0) + 1;
      }
    }
    
    // Count by author
    _authorCount = {};
    for (var tutorial in widget.tutorials) {
      if (tutorial.author != null && tutorial.author!.isNotEmpty) {
        _authorCount[tutorial.author!] = (_authorCount[tutorial.author!] ?? 0) + 1;
      }
    }
    
    // Sort and get top entities
    _topAuthors = _authorCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _topCategories = _categoriesCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics Dashboard'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Overview'),
            Tab(text: 'Categories'),
            Tab(text: 'Authors'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildCategoriesTab(),
          _buildAuthorsTab(),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Summary cards
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Tutorials',
                _totalTutorials,
                Icons.menu_book,
                AppTheme.primaryColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Published',
                _publishedTutorials,
                Icons.visibility,
                AppTheme.successColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Drafts',
                _draftTutorials,
                Icons.edit_note,
                Colors.grey,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard(
                'Featured',
                _featuredTutorials,
                Icons.star,
                AppTheme.warningColor,
              ),
            ),
          ],
        ),
        
        // Publication status chart
        if (_totalTutorials > 0) ...[
          SizedBox(height: 24),
          Text(
            'Publication Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 250,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: _publishedTutorials.toDouble(),
                    title: 'Published\n${_publishedTutorials}',
                    color: AppTheme.successColor,
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: _draftTutorials.toDouble(),
                    title: 'Drafts\n${_draftTutorials}',
                    color: Colors.grey,
                    radius: 100,
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        
        // Difficulty distribution
        if (_difficultyLevelsCount.isNotEmpty) ...[
          SizedBox(height: 24),
          Text(
            'Difficulty Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16),
          StatisticsWidget(
            data: _difficultyLevelsCount,
          ),
        ],
        
        SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildCategoriesTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Top categories
        if (_topCategories.isNotEmpty) ...[
          Text(
            'Top Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16),
          
          // Categories bar chart
          Container(
            height: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _topCategories.isNotEmpty ? (_topCategories[0].value * 1.2).toDouble() : 10,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < min(_topCategories.length, 5)) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _topCategories[value.toInt()].key,
                              style: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _topCategories.isNotEmpty 
                          ? (_topCategories[0].value / 5).ceilToDouble() 
                          : 2,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return Text('');
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: _topCategories.isNotEmpty 
                      ? (_topCategories[0].value / 5).ceilToDouble() 
                      : 2,
                ),
                barGroups: _getBarGroups(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${_topCategories[groupIndex].key}: ${rod.toY.toInt()}',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // All categories list
          Text(
            'All Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16),
          
          ...List.generate(_categoriesCount.length, (index) {
            final entry = _categoriesCount.entries.toList()[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        entry.key.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ] else ...[
          Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No categories data available',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildAuthorsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Top authors
        if (_topAuthors.isNotEmpty) ...[
          Text(
            'Top Authors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16),
          
          // Top authors cards
          ...List.generate(_topAuthors.take(5).length, (index) {
            final entry = _topAuthors[index];
            final percentage = (_topAuthors[index].value / _totalTutorials) * 100;
            final color = index == 0 
                ? AppTheme.warningColor 
                : index == 1 
                    ? AppTheme.infoColor 
                    : index == 2 
                        ? AppTheme.accentColor 
                        : AppTheme.primaryColor;
                        
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        '#${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '${entry.value} tutorials (${percentage.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Progress bar
                        Stack(
                          children: [
                            Container(
                              height: 6,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            Container(
                              height: 6,
                              width: MediaQuery.of(context).size.width * (percentage / 100) * 0.6,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          
          SizedBox(height: 24),
          
          // All authors
          Text(
            'All Authors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _authorCount.length,
            itemBuilder: (context, index) {
              final entry = _authorCount.entries.toList()[index];
              final color = Colors.primaries[index % Colors.primaries.length];
              
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          entry.key.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${entry.value} ${entry.value == 1 ? 'tutorial' : 'tutorials'}',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ] else ...[
          Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No authors data available',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ),
          ),
        ],
        
        SizedBox(height: 24),
      ],
    );
  }
  
  Widget _buildSummaryCard(String title, int value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: color),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  List<BarChartGroupData> _getBarGroups() {
    final max = _topCategories.isNotEmpty ? min(_topCategories.length, 5) : 0;
    
    return List.generate(max, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: _topCategories[index].value.toDouble(),
            color: AppTheme.primaryColor,
            width: 20,
            borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      );
    });
  }
}
