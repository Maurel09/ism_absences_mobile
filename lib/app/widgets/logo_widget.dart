import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const LogoWidget({
    Key? key,
    this.size = 60.0,
    this.showText = true,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo SVG-like widget
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF442A1B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFD17E1F),
              width: 1,
            ),
          ),
          child: CustomPaint(
            painter: LogoPainter(),
            size: Size(size, size),
          ),
        ),
        
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ISM',
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? const Color(0xFF442A1B),
                ),
              ),
              Text(
                'Gestion Absences',
                style: TextStyle(
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD17E1F)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFFD17E1F)
      ..style = PaintingStyle.fill;

    // ISM Text (simplified representation)
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'ISM',
        style: TextStyle(
          color: const Color(0xFFD17E1F),
          fontSize: size.width * 0.16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.15, size.height * 0.15));

    // Base - 3 horizontal lines
    final baseY = size.height * 0.7;
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(size.width * 0.2, baseY + i * 2),
        Offset(size.width * 0.8, baseY + i * 2),
        paint,
      );
    }

    // Grid structure - 2 rows of 5 vertical rectangles
    final rectWidth = size.width * 0.08;
    final rectHeight = size.height * 0.2;
    final startX = size.width * 0.25;
    final startY1 = size.height * 0.45;
    final startY2 = size.height * 0.35;

    // First row
    for (int i = 0; i < 5; i++) {
      final x = startX + i * rectWidth * 1.25;
      canvas.drawRect(
        Rect.fromLTWH(x, startY1, rectWidth, rectHeight),
        paint,
      );
    }

    // Second row
    for (int i = 0; i < 5; i++) {
      final x = startX + i * rectWidth * 1.25;
      canvas.drawRect(
        Rect.fromLTWH(x, startY2, rectWidth, rectHeight),
        paint,
      );
    }

    // Roof - 4 horizontal lines
    final roofY = size.height * 0.3;
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(size.width * 0.22, roofY + i * 2),
        Offset(size.width * 0.78, roofY + i * 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
