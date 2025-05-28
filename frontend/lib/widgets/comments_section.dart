import 'package:flutter/material.dart';
import 'package:tutorial_management_app/theme/app_theme.dart';

class Comment {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
    this.replies = const [],
  });
}

class CommentsSection extends StatefulWidget {
  final List<Comment> comments;
  final Function(String)? onAddComment;
  final Function(String, String)? onReplyToComment;
  final String? placeholder;

  const CommentsSection({
    Key? key,
    required this.comments,
    this.onAddComment,
    this.onReplyToComment,
    this.placeholder,
  }) : super(key: key);

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  String? _replyToCommentId;
  String? _replyToAuthorName;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    if (_replyToCommentId != null && widget.onReplyToComment != null) {
      widget.onReplyToComment!(_replyToCommentId!, _commentController.text.trim());
    } else if (widget.onAddComment != null) {
      widget.onAddComment!(_commentController.text.trim());
    }

    _commentController.clear();
    setState(() {
      _replyToCommentId = null;
      _replyToAuthorName = null;
    });
  }

  void _startReplyTo(String commentId, String authorName) {
    setState(() {
      _replyToCommentId = commentId;
      _replyToAuthorName = authorName;
    });
    
    // Focus on the text field
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _cancelReply() {
    setState(() {
      _replyToCommentId = null;
      _replyToAuthorName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Text(
            'Comments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ),
        
        // Comments list
        if (widget.comments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                widget.placeholder ?? 'No comments yet. Be the first to comment!',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.comments.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              return _buildCommentTile(comment);
            },
          ),
          
        // Add new comment
        Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppTheme.borderColor,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reply indicator
                if (_replyToAuthorName != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Replying to $_replyToAuthorName',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 16),
                          onPressed: _cancelReply,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                
                // Comment input
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.inputBackgroundColor,
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppTheme.borderColor,
                              width: 1,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: AppTheme.primaryColor,
                      onPressed: _submitComment,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTile(Comment comment, {bool isReply = false}) {
    final formattedDate = _formatDate(comment.createdAt);
    
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 32.0 : 8.0,
        right: 8.0,
        top: 12.0,
        bottom: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: isReply ? 14 : 18,
                backgroundImage: NetworkImage(comment.authorAvatar),
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 12),
              
              // Comment content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.authorName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isReply ? 14 : 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: AppTheme.textTertiaryColor,
                            fontSize: isReply ? 12 : 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.content,
                      style: TextStyle(
                        fontSize: isReply ? 13 : 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Reply button
                    if (!isReply && widget.onReplyToComment != null)
                      GestureDetector(
                        onTap: () => _startReplyTo(comment.id, comment.authorName),
                        child: Text(
                          'Reply',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          // Replies
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: comment.replies.map((reply) {
                  return _buildCommentTile(reply, isReply: true);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
