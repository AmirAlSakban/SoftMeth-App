import 'package:flutter/material.dart';

class SearchFilterBar extends StatefulWidget {
  final TextEditingController searchController;
  final bool showPublishedOnly;
  final Function(bool) onTogglePublished;
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategoryChanged;

  const SearchFilterBar({
    Key? key,
    required this.searchController,
    required this.showPublishedOnly,
    required this.onTogglePublished,
    this.categories = const [],
    this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  _SearchFilterBarState createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Column(
        children: [
          // Search field
          TextField(
            controller: widget.searchController,
            decoration: InputDecoration(
              hintText: 'Search tutorials...',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: widget.searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => widget.searchController.clear(),
                      color: Colors.grey,
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.blue[300]!, width: 1),
              ),
            ),
          ),
          
          // Filters
          SizedBox(height: 12),
          Row(
            children: [
              // Published toggle
              FilterChip(
                label: Text('Published Only'),
                selected: widget.showPublishedOnly,
                onSelected: widget.onTogglePublished,
                avatar: Icon(
                  widget.showPublishedOnly ? Icons.check_circle : Icons.public,
                  size: 18,
                  color: widget.showPublishedOnly ? Colors.white : Colors.grey,
                ),
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: widget.showPublishedOnly ? Colors.white : Colors.black87,
                  fontWeight: widget.showPublishedOnly ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              
              SizedBox(width: 8),
              
              // Categories dropdown
              if (widget.categories.isNotEmpty)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: widget.selectedCategory,
                      hint: Text(
                        'All Categories', 
                        style: TextStyle(fontSize: 14),
                      ),
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: [
                        DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Categories'),
                        ),
                        ...widget.categories.map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        )).toList(),
                      ],
                      onChanged: (value) => widget.onCategoryChanged(value),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
