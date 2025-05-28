import 'package:flutter/material.dart';
import 'package:tutorial_management_app/models/tutorial.dart';
import 'package:intl/intl.dart';

class TutorialCard extends StatelessWidget {
  final Tutorial tutorial;
  final Function onTap;
  final Function? onEdit;
  final Function? onDelete;

  const TutorialCard({
    Key? key,
    required this.tutorial,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final difficultyColors = {
      'BEGINNER': Colors.green,
      'INTERMEDIATE': Colors.orange,
      'ADVANCED': Colors.red,
    };

    final difficultyColor = difficultyColors[tutorial.difficultyLevel?.toUpperCase()] ?? Colors.blue;
    final dateFormat = DateFormat('MMM d, yyyy');
    final formattedDate = tutorial.updatedAt != null 
        ? dateFormat.format(tutorial.updatedAt!)
        : 'N/A';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: tutorial.featured ? Colors.amber.shade300 : Colors.transparent,
          width: tutorial.featured ? 2 : 0,
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        onTap: () => onTap(),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tutorial Image or Header
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.blue.shade100,
                child: tutorial.imageUrl != null && tutorial.imageUrl!.isNotEmpty
                  ? Image.network(
                      tutorial.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        _buildPlaceholderImage(),
                    )
                  : _buildPlaceholderImage(),
              ),
            ),
            
            // Title and badges
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tutorial.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (tutorial.featured)
                    _buildBadge('Featured', Colors.amber),
                  SizedBox(width: 4),
                  if (tutorial.published)
                    _buildBadge('Published', Colors.green)
                  else
                    _buildBadge('Draft', Colors.grey),
                ],
              ),
            ),
            
            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                tutorial.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Metadata
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  if (tutorial.category != null && tutorial.category!.isNotEmpty)
                    Chip(
                      label: Text(
                        tutorial.category!,
                        style: TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.grey[200],
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  Spacer(),
                  if (tutorial.difficultyLevel != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: difficultyColor, width: 1),
                      ),
                      child: Text(
                        tutorial.difficultyLevel!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: difficultyColor,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  if (tutorial.durationMinutes != null)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          '${tutorial.durationMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            // Author and date
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  if (tutorial.author != null && tutorial.author!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                          tutorial.author!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  Spacer(),
                  Text(
                    'Updated: $formattedDate',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            if (onEdit != null || onDelete != null)
              Divider(height: 1),
              
            if (onEdit != null || onDelete != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => onEdit!(),
                        tooltip: 'Edit Tutorial',
                      ),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDelete!(),
                        tooltip: 'Delete Tutorial',
                      ),
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
      color: Colors.blue.shade50,
      child: Center(
        child: Icon(
          Icons.school,
          size: 48,
          color: Colors.blue.shade200,
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
