import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String message;
  final bool isFullScreen;

  const LoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    if (isFullScreen) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Center(child: content),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(child: content),
      );
    }
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(actionLabel!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.actionLabel = 'Retry',
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: onAction,
                  label: Text(actionLabel!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
