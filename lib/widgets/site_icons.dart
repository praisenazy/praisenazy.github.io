import 'package:flutter/material.dart';

/// Minimal SVG path (d) → Flutter Path parser. Supports M/L/H/V/C/S/Q/T/Z
/// (absolute + relative) — enough for the GitHub octocat glyph (all beziers).
Path parseSvgPath(String d) {
  final path = Path();
  final tokens = RegExp(r'[a-zA-Z]|-?\d*\.?\d+(?:[eE][-+]?\d+)?')
      .allMatches(d)
      .map((m) => m.group(0)!)
      .toList();
  var i = 0;
  double cx = 0, cy = 0, sx = 0, sy = 0, lcx = 0, lcy = 0;
  var cmd = '';
  double n() => double.parse(tokens[i++]);
  bool isCmd(String t) => t.length == 1 && RegExp(r'[a-zA-Z]').hasMatch(t);

  while (i < tokens.length) {
    if (isCmd(tokens[i])) cmd = tokens[i++];
    switch (cmd) {
      case 'M': cx = n(); cy = n(); path.moveTo(cx, cy); sx = cx; sy = cy; cmd = 'L'; break;
      case 'm': cx += n(); cy += n(); path.moveTo(cx, cy); sx = cx; sy = cy; cmd = 'l'; break;
      case 'L': cx = n(); cy = n(); path.lineTo(cx, cy); break;
      case 'l': cx += n(); cy += n(); path.lineTo(cx, cy); break;
      case 'H': cx = n(); path.lineTo(cx, cy); break;
      case 'h': cx += n(); path.lineTo(cx, cy); break;
      case 'V': cy = n(); path.lineTo(cx, cy); break;
      case 'v': cy += n(); path.lineTo(cx, cy); break;
      case 'C':
        final x1 = n(), y1 = n(), x2 = n(), y2 = n(), x = n(), y = n();
        path.cubicTo(x1, y1, x2, y2, x, y); lcx = x2; lcy = y2; cx = x; cy = y; break;
      case 'c':
        final x1 = cx + n(), y1 = cy + n(), x2 = cx + n(), y2 = cy + n(), x = cx + n(), y = cy + n();
        path.cubicTo(x1, y1, x2, y2, x, y); lcx = x2; lcy = y2; cx = x; cy = y; break;
      case 'S':
        {final x2 = n(), y2 = n(), x = n(), y = n();
        path.cubicTo(2 * cx - lcx, 2 * cy - lcy, x2, y2, x, y); lcx = x2; lcy = y2; cx = x; cy = y;} break;
      case 's':
        {final x2 = cx + n(), y2 = cy + n(), x = cx + n(), y = cy + n();
        path.cubicTo(2 * cx - lcx, 2 * cy - lcy, x2, y2, x, y); lcx = x2; lcy = y2; cx = x; cy = y;} break;
      case 'Q':
        {final x1 = n(), y1 = n(), x = n(), y = n();
        path.quadraticBezierTo(x1, y1, x, y); lcx = x1; lcy = y1; cx = x; cy = y;} break;
      case 'q':
        {final x1 = cx + n(), y1 = cy + n(), x = cx + n(), y = cy + n();
        path.quadraticBezierTo(x1, y1, x, y); lcx = x1; lcy = y1; cx = x; cy = y;} break;
      case 'T':
        {final x = n(), y = n();
        path.quadraticBezierTo(2 * cx - lcx, 2 * cy - lcy, x, y); cx = x; cy = y;} break;
      case 't':
        {final x = cx + n(), y = cy + n();
        path.quadraticBezierTo(2 * cx - lcx, 2 * cy - lcy, x, y); cx = x; cy = y;} break;
      case 'Z':
      case 'z': path.close(); cx = sx; cy = sy; break;
      default: i++;
    }
  }
  return path;
}

Paint _stroke(Color color, double w) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..isAntiAlias = true;

/// Filled GitHub octocat mark (Font Awesome path, viewBox 0 0 496 512).
class GithubMark extends StatelessWidget {
  const GithubMark({super.key, this.size = 22, required this.color});
  final double size;
  final Color color;

  static const _d =
      'M165.9 397.4c0 2-2.3 3.6-5.2 3.6-3.3.3-5.6-1.3-5.6-3.6 0-2 2.3-3.6 5.2-3.6 '
      '3-.3 5.6 1.3 5.6 3.6zm-31.1-4.5c-.7 2 1.3 4.3 4.3 4.9 2.6 1 5.6 0 6.2-2s-1.3-4.3-4.3-5.2c-2.6-.7-5.5.3-6.2 2.3zm44.2-1.7c-2.9.7-4.9 2.6-4.6 4.9.3 2 2.9 3.3 5.9 2.6 2.9-.7 4.9-2.6 4.6-4.6-.3-1.9-3-3.2-5.9-2.9zM244.8 8C106.1 8 0 113.3 0 252c0 110.9 69.8 205.8 169.5 239.2 12.8 2.3 17.3-5.6 17.3-12.1 0-6.2-.3-40.4-.3-61.4 0 0-70 15-84.7-29.8 0 0-11.4-29.1-27.8-36.6 0 0-22.9-15.7 1.6-15.4 0 0 24.9 2 38.6 25.8 21.9 38.6 58.6 27.5 72.9 20.9 2.3-16 8.8-27.1 16-33.7-55.9-6.2-112.3-14.3-112.3-110.5 0-27.5 7.6-41.3 23.6-58.9-2.6-6.5-11.1-33.3 2.6-67.9 20.9-6.5 69 27 69 27 20-5.6 41.5-8.5 62.8-8.5s42.8 2.9 62.8 8.5c0 0 48.1-33.6 69-27 13.7 34.7 5.2 61.4 2.6 67.9 16 17.7 25.8 31.5 25.8 58.9 0 96.5-58.9 104.2-114.8 110.5 9.2 7.9 17 22.9 17 46.4 0 33.7-.3 75.4-.3 83.6 0 6.5 4.6 14.4 17.3 12.1C428.2 457.8 496 362.9 496 252 496 113.3 383.5 8 244.8 8zM97.2 352.9c-1.3 1-1 3.3.7 5.2 1.6 1.6 3.9 2.3 5.2 1 1.3-1 1-3.3-.7-5.2-1.6-1.6-3.9-2.3-5.2-1zm-10.8-8.1c-.7 1.3.3 2.9 2.3 3.9 1.6 1 3.6.7 4.3-.7.7-1.3-.3-2.9-2.3-3.9-2-.6-3.6-.3-4.3.7zm32.4 35.6c-1.6 1.3-1 4.3 1.3 6.2 2.3 2.3 5.2 2.6 6.5 1 1.3-1.3.7-4.3-1.3-6.2-2.2-2.3-5.2-2.6-6.5-1zm-11.4-14.7c-1.6 1-1.6 3.6 0 5.9 1.6 2.3 4.3 3.3 5.6 2.3 1.6-1.3 1.6-3.9 0-6.2-1.4-2.3-4-3.3-5.6-2z';

  static final Path _raw = parseSvgPath(_d);

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _PathPainter(_raw, color, 512));
}

class _PathPainter extends CustomPainter {
  _PathPainter(this.path, this.color, this.viewBox);
  final Path path;
  final Color color;
  final double viewBox;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / viewBox);
    canvas.drawPath(path, Paint()..color = color..isAntiAlias = true);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PathPainter old) => old.color != color;
}

class CodeBrackets extends StatelessWidget {
  const CodeBrackets({super.key, this.size = 20, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _DrawPainter(color, 2, (c, p) {
          c.drawPath(Path()..moveTo(9, 7)..lineTo(4, 12)..lineTo(9, 17), p);
          c.drawPath(Path()..moveTo(15, 7)..lineTo(20, 12)..lineTo(15, 17), p);
          c.drawLine(const Offset(13, 6), const Offset(11, 18), p);
        }),
      );
}

class ArrowRight extends StatelessWidget {
  const ArrowRight({super.key, this.size = 20, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _DrawPainter(color, 2, (c, p) {
          c.drawLine(const Offset(4, 12), const Offset(20, 12), p);
          c.drawPath(Path()..moveTo(13, 6)..lineTo(20, 12)..lineTo(13, 18), p);
        }),
      );
}

class EnvelopeIcon extends StatelessWidget {
  const EnvelopeIcon({super.key, this.size = 20, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _DrawPainter(color, 1.8, (c, p) {
          c.drawRRect(RRect.fromRectAndRadius(
              const Rect.fromLTWH(3, 5, 18, 14), const Radius.circular(2)), p);
          c.drawPath(Path()..moveTo(3, 7)..lineTo(12, 13.5)..lineTo(21, 7), p);
        }),
      );
}

/// A stroke icon defined in a 24-unit viewBox via a draw callback.
class _DrawPainter extends CustomPainter {
  _DrawPainter(this.color, this.strokeWidth, this.draw);
  final Color color;
  final double strokeWidth;
  final void Function(Canvas canvas, Paint paint) draw;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24);
    draw(canvas, _stroke(color, strokeWidth));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DrawPainter old) => old.color != color;
}
