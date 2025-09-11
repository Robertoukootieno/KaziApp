import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Performance monitoring widget for development
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String screenName;

  const PerformanceMonitor({
    super.key,
    required this.child,
    required this.screenName,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  late DateTime _startTime;
  DateTime? _endTime;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    
    // Mark as loaded after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _endTime = DateTime.now();
          _isLoading = false;
        });
        
        final loadTime = _endTime!.difference(_startTime).inMilliseconds;
        debugPrint('🚀 ${widget.screenName} loaded in ${loadTime}ms');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Show performance info in debug mode
        if (kDebugMode && _endTime != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_endTime!.difference(_startTime).inMilliseconds}ms',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Performance-optimized loading indicator
class FastLoadingIndicator extends StatelessWidget {
  final String message;
  final double size;

  const FastLoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// Optimized image widget with lazy loading
class OptimizedImage extends StatefulWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit fit;

  const OptimizedImage({
    super.key,
    this.imageUrl,
    required this.width,
    required this.height,
    this.placeholder,
    this.errorWidget,
    this.fit = BoxFit.cover,
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Delay image loading slightly to prioritize UI rendering
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || widget.imageUrl == null) {
      return widget.placeholder ?? 
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.grey),
        );
    }

    return Image.network(
      widget.imageUrl!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return widget.placeholder ?? 
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / 
                        loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
      },
      errorBuilder: (context, error, stackTrace) {
        return widget.errorWidget ?? 
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
      },
    );
  }
}

/// Optimized list view with lazy loading
class OptimizedListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const OptimizedListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: children.length,
      itemBuilder: (context, index) {
        // Add slight delay for items beyond the first few
        if (index > 5) {
          return FutureBuilder(
            future: Future.delayed(Duration(milliseconds: index * 10)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return children[index];
              }
              return const SizedBox(height: 60); // Placeholder height
            },
          );
        }
        
        return children[index];
      },
    );
  }
}

/// Performance utilities
class PerformanceUtils {
  static void measureExecutionTime(String operation, Function() function) {
    if (!kDebugMode) {
      function();
      return;
    }
    
    final stopwatch = Stopwatch()..start();
    function();
    stopwatch.stop();
    
    debugPrint('⏱️ $operation took ${stopwatch.elapsedMilliseconds}ms');
  }

  static Future<T> measureAsyncExecutionTime<T>(
    String operation, 
    Future<T> Function() function,
  ) async {
    if (!kDebugMode) {
      return await function();
    }
    
    final stopwatch = Stopwatch()..start();
    final result = await function();
    stopwatch.stop();
    
    debugPrint('⏱️ $operation took ${stopwatch.elapsedMilliseconds}ms');
    return result;
  }

  static void logMemoryUsage(String context) {
    if (!kDebugMode) return;
    
    // This would require additional packages for detailed memory info
    debugPrint('📊 Memory check at: $context');
  }
}
