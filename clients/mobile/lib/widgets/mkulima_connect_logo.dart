import 'package:flutter/material.dart';

class MkulimaConnectLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final Color? textColor;
  final double? fontSize;
  final bool isHorizontal;
  final bool showTagline;
  final String? tagline;

  const MkulimaConnectLogo({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.textColor,
    this.fontSize,
    this.isHorizontal = false,
    this.showTagline = false,
    this.tagline,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidget = _buildLogoIcon();
    final textWidget = showText ? _buildLogoText() : null;
    final taglineWidget = showTagline ? _buildTagline() : null;

    if (isHorizontal && textWidget != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,
          const SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget,
              if (taglineWidget != null) ...[
                const SizedBox(height: 4),
                taglineWidget,
              ],
            ],
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logoWidget,
        if (textWidget != null) ...[
          const SizedBox(height: 12),
          textWidget,
        ],
        if (taglineWidget != null) ...[
          const SizedBox(height: 8),
          taglineWidget,
        ],
      ],
    );
  }

  Widget _buildLogoIcon() {
    return SizedBox(
      width: width ?? 80,
      height: height ?? 80,
      child: CustomPaint(
        painter: MkulimaConnectLogoPainter(),
        size: Size(width ?? 80, height ?? 80),
      ),
    );
  }

  Widget _buildLogoText() {
    final defaultFontSize = fontSize ?? 24;
    final color = textColor ?? const Color(0xFF2E7D32);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Mkulima',
          style: TextStyle(
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
        Text(
          'Connect',
          style: TextStyle(
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    final color = textColor ?? Colors.grey[600];
    return Text(
      tagline ?? 'Connecting Farmers with Agricultural Services',
      style: TextStyle(
        fontSize: (fontSize ?? 24) * 0.5,
        color: color,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class MkulimaConnectLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create the leaf shape that matches the original logo exactly
    final leafPath = Path();

    // Start from the pointed tip (top-left)
    leafPath.moveTo(size.width * 0.1, size.height * 0.2);

    // Top curve - create the characteristic leaf curve
    leafPath.quadraticBezierTo(
      size.width * 0.5, size.height * 0.05,
      size.width * 0.8, size.height * 0.3,
    );

    // Right side curve
    leafPath.quadraticBezierTo(
      size.width * 0.9, size.height * 0.5,
      size.width * 0.85, size.height * 0.7,
    );

    // Bottom curve
    leafPath.quadraticBezierTo(
      size.width * 0.7, size.height * 0.9,
      size.width * 0.4, size.height * 0.85,
    );

    // Left curve back to tip
    leafPath.quadraticBezierTo(
      size.width * 0.15, size.height * 0.6,
      size.width * 0.1, size.height * 0.2,
    );

    leafPath.close();

    // Create gradient that matches the original logo
    final leafGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF7CB342), // Light green
        const Color(0xFF4CAF50), // Medium green
        const Color(0xFF2E7D32), // Dark green
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final leafPaint = Paint()
      ..shader = leafGradient
      ..style = PaintingStyle.fill;

    // Draw the leaf
    canvas.drawPath(leafPath, leafPaint);

    // Draw the network nodes (white circles connected by lines)
    final nodePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.035
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Define node positions to match the original logo
    final node1 = Offset(size.width * 0.35, size.height * 0.4);
    final node2 = Offset(size.width * 0.55, size.height * 0.35);
    final node3 = Offset(size.width * 0.45, size.height * 0.6);

    // Draw connections
    canvas.drawLine(node1, node2, linePaint);
    canvas.drawLine(node2, node3, linePaint);
    canvas.drawLine(node3, node1, linePaint);

    // Draw nodes
    final nodeRadius = size.width * 0.055;
    canvas.drawCircle(node1, nodeRadius, nodePaint);
    canvas.drawCircle(node2, nodeRadius, nodePaint);
    canvas.drawCircle(node3, nodeRadius, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


