import 'package:flutter/material.dart';
import 'package:tutorial_management_app/theme/app_theme.dart';

class TutorialContentEditor extends StatefulWidget {
  final String? initialValue;
  final Function(String)? onChanged;
  final String? hintText;
  
  const TutorialContentEditor({
    super.key,
    this.initialValue,
    this.onChanged,
    this.hintText,
  });

  @override
  State<TutorialContentEditor> createState() => _TutorialContentEditorState();
}

class _TutorialContentEditorState extends State<TutorialContentEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  int _selectedStartIndex = -1;
  int _selectedEndIndex = -1;
  String _currentFormatOption = '';
  bool _showFormatToolbar = false;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _focusNode = FocusNode();
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _showFormatToolbar = true);
      } else {
        setState(() => _showFormatToolbar = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  void _handleFormatOption(String option) {
    if (_selectedStartIndex < 0 || _selectedEndIndex <= _selectedStartIndex) {
      return;
    }
    
    String prefix = '';
    String suffix = '';
    
    switch (option) {
      case 'bold':
        prefix = '**';
        suffix = '**';
        break;
      case 'italic':
        prefix = '_';
        suffix = '_';
        break;
      case 'code':
        prefix = '`';
        suffix = '`';
        break;
      case 'h1':
        prefix = '# ';
        suffix = '';
        break;
      case 'h2':
        prefix = '## ';
        suffix = '';
        break;
      case 'h3':
        prefix = '### ';
        suffix = '';
        break;
      case 'link':
        prefix = '[';
        suffix = '](url)';
        break;
      case 'bullet':
        prefix = '- ';
        suffix = '';
        break;
      case 'number':
        prefix = '1. ';
        suffix = '';
        break;
      case 'quote':
        prefix = '> ';
        suffix = '';
        break;
    }
    
    final text = _controller.text;
    final selectedText = text.substring(_selectedStartIndex, _selectedEndIndex);
    
    final newText = text.replaceRange(
      _selectedStartIndex, 
      _selectedEndIndex,
      '$prefix$selectedText$suffix',
    );
    
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection(
        baseOffset: _selectedStartIndex + prefix.length,
        extentOffset: _selectedStartIndex + prefix.length + selectedText.length,
      ),
    );
    
    setState(() => _currentFormatOption = option);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Format toolbar
        if (_showFormatToolbar)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildFormatButton('bold', 'B', FontWeight.bold),
                  _buildFormatButton('italic', 'I', FontWeight.normal, isItalic: true),
                  _buildFormatButton('code', '< >', FontWeight.normal, icon: Icons.code),
                  const VerticalDivider(width: 16, thickness: 1, color: AppTheme.borderColor),
                  _buildFormatButton('h1', 'H1', FontWeight.bold),
                  _buildFormatButton('h2', 'H2', FontWeight.bold),
                  _buildFormatButton('h3', 'H3', FontWeight.bold),
                  const VerticalDivider(width: 16, thickness: 1, color: AppTheme.borderColor),
                  _buildFormatButton('link', 'Link', FontWeight.normal, icon: Icons.link),
                  _buildFormatButton('bullet', 'List', FontWeight.normal, icon: Icons.format_list_bulleted),
                  _buildFormatButton('number', '1.', FontWeight.normal, icon: Icons.format_list_numbered),
                  _buildFormatButton('quote', 'Quote', FontWeight.normal, icon: Icons.format_quote),
                ],
              ),
            ),
          ),
        
        // Text editor
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: null,
            minLines: 10,
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Write your tutorial content here...',
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
              setState(() {
                _selectedStartIndex = _controller.selection.baseOffset;
                _selectedEndIndex = _controller.selection.extentOffset;
              });
            },
            onTap: () {
              setState(() {
                _selectedStartIndex = _controller.selection.baseOffset;
                _selectedEndIndex = _controller.selection.extentOffset;
              });
            },
          ),
        ),
        
        // Preview section
        if (_controller.text.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 8),
                child: Text(
                  'Preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: _buildRichTextPreview(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFormatButton(String option, String label, FontWeight weight, {IconData? icon, bool isItalic = false}) {
    final isActive = _currentFormatOption == option;
    
    return GestureDetector(
      onTap: () => _handleFormatOption(option),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: icon != null
            ? Icon(
                icon,
                size: 18,
                color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
              )
            : Text(
                label,
                style: TextStyle(
                  fontWeight: weight,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                  color: isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                ),
              ),
      ),
    );
  }

  Widget _buildRichTextPreview() {
    // This is a simplified preview that would be replaced by a Markdown renderer in a real app
    // For demo purposes, we'll just make headings and bold text stand out
    
    final text = _controller.text;
    List<TextSpan> spans = [];
    
    // Very simple markdown-like parser (just for demonstration)
    final lines = text.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (line.startsWith('# ')) {
        spans.add(TextSpan(
          text: '${line.substring(2)}\n',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ));
      } else if (line.startsWith('## ')) {
        spans.add(TextSpan(
          text: '${line.substring(3)}\n',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ));
      } else if (line.startsWith('### ')) {
        spans.add(TextSpan(
          text: '${line.substring(4)}\n',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ));
      } else if (line.startsWith('- ')) {
        spans.add(TextSpan(
          text: '• ${line.substring(2)}\n',
          style: const TextStyle(height: 1.5),
        ));
      } else if (line.startsWith('> ')) {
        spans.add(TextSpan(
          text: '${line.substring(2)}\n',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ));
      } else {
        // Parse bold and italic in the text
        String processedLine = line;
        List<TextSpan> lineSpans = [];
        
        // Process bold text between **
        RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
        Iterable<RegExpMatch> boldMatches = boldRegex.allMatches(processedLine);
        int lastEnd = 0;
        
        for (var match in boldMatches) {
          if (match.start > lastEnd) {
            lineSpans.add(TextSpan(text: processedLine.substring(lastEnd, match.start)));
          }
          
          lineSpans.add(TextSpan(
            text: match.group(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ));
          
          lastEnd = match.end;
        }
        
        // Add remaining text
        if (lastEnd < processedLine.length) {
          lineSpans.add(TextSpan(text: processedLine.substring(lastEnd)));
        }
        
        // If no formatting was found, add the whole line
        if (lineSpans.isEmpty) {
          lineSpans.add(TextSpan(text: processedLine));
        }
        
        // Add line break
        lineSpans.add(const TextSpan(text: '\n'));
        
        // Add the line spans to the main spans list
        spans.addAll(lineSpans);
      }
    }
    
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          height: 1.5,
        ),
        children: spans,
      ),
    );
  }
}
