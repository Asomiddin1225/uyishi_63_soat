import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Row(
            children: [
              Icon(Icons.access_time),
              Text("  Soat"),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              """
     Soat ishlayotgani bildirish
maxsadida vaht tezlashtirilgan !!!""",
              style: TextStyle(color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  width: double.infinity,
                  height: 600,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: ClockAnimation()),
            ),
          ],
        ),
      ),
    );
  }
}

class ClockAnimation extends StatefulWidget {
  @override
  _ClockAnimationState createState() => _ClockAnimationState();
}

class _ClockAnimationState extends State<ClockAnimation>
    with TickerProviderStateMixin {
  late AnimationController _secondController;
  late AnimationController _minuteController;
  late AnimationController _hourController;

  @override
  void initState() {
    super.initState();

    // Sekund strelkasini animatsiya qilish
    _secondController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 60),
    )..repeat();

    // Minut strelkasini animatsiya qilish
    _minuteController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    )..repeat();

    // Soat strelkasini animatsiya qilish
    _hourController = AnimationController(
      vsync: this,
      duration: Duration(minutes: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _secondController.dispose();
    _minuteController.dispose();
    _hourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
          [_secondController, _minuteController, _hourController]),
      builder: (context, child) {
        return CustomPaint(
          size: Size(200, 200),
          painter: ClockPainter(
            secondAngle: _secondController.value * 2 * pi,
            minuteAngle: _minuteController.value * 2 * pi,
            hourAngle: _hourController.value * 2 * pi,
          ),
        );
      },
    );
  }
}

class ClockPainter extends CustomPainter {
  final double secondAngle;
  final double minuteAngle;
  final double hourAngle;

  ClockPainter({
    required this.secondAngle,
    required this.minuteAngle,
    required this.hourAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final markaz = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final orqafonPaint = Paint();
    orqafonPaint.color = Colors.green;
    orqafonPaint.style = PaintingStyle.fill;

    // Soat yuzasini chizish
    canvas.drawCircle(markaz, radius, orqafonPaint);

    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 10;
    paint.color = Color.fromARGB(255, 37, 2, 93);

    // Soat yuzini chizish
    canvas.drawCircle(markaz, radius, paint);

    // Soat strelkalarini chizish
    final soatPaint = Paint();
    soatPaint.color = Colors.pink;
    soatPaint.strokeWidth = 8;
    soatPaint.strokeCap = StrokeCap.round;

    final minutPaint = Paint();
    minutPaint.color = Colors.blue;
    minutPaint.strokeWidth = 8;
    minutPaint.strokeCap = StrokeCap.round;

    final sekundPaint = Paint();
    sekundPaint.color = Colors.orange;
    sekundPaint.strokeWidth = 8;
    sekundPaint.strokeCap = StrokeCap.round;

    // Sekund strelkasi
    final sekundEnd = Offset(
        markaz.dx + radius * 0.7 * cos(secondAngle - pi / 2),
        markaz.dy + radius * 0.7 * sin(secondAngle - pi / 2));

    // Minut strelkasi
    final minutEnd = Offset(
        markaz.dx + radius * 0.6 * cos(minuteAngle - pi / 2),
        markaz.dy + radius * 0.6 * sin(minuteAngle - pi / 2));

    // Soat strelkasi
    final soatEnd = Offset(markaz.dx + radius * 0.5 * cos(hourAngle - pi / 2),
        markaz.dy + radius * 0.5 * sin(hourAngle - pi / 2));

    // Strelkalarni chizish
    canvas.drawLine(markaz, sekundEnd, sekundPaint);
    canvas.drawLine(markaz, minutEnd, minutPaint);
    canvas.drawLine(markaz, soatEnd, soatPaint);

    // Markaziy doirani chizish
    final ortaPaint = Paint();
    ortaPaint.color = Colors.white;
    ortaPaint.style = PaintingStyle.fill;

    canvas.drawCircle(markaz, 10, ortaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
