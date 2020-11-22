import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _a1, _a2;
  CurvedAnimation _c1, _c2;
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();

    _a1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _a2 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _c1 = CurvedAnimation(parent: _a1, curve: Curves.fastOutSlowIn);
    _c2 = CurvedAnimation(parent: _a2, curve: Curves.fastOutSlowIn);
  }

  void _startAnimation() {
    _a1.forward().then((value) => _a2.forward());
    setState(() {
      _isAnimating = false;
    });
  }

  void _reverseAnimation() {
    _a2.reverse().then((value) => _a1.reverse());
    setState(() {
      _isAnimating = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Container(
        margin: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width - 200) / 2,
            top: (MediaQuery.of(context).size.height - 300) / 2),
        child: InkWell(
          onTap: _isAnimating ? _startAnimation : _reverseAnimation,
          child: Container(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                AnimatedBuilder(
                  animation: _c1,
                  builder: (context, child) {
                    final value1 = _c1.value;
                    return AnimatedBuilder(
                      animation: _c2,
                      builder: (context, child) {
                        final value2 = _c2.value;
                        return CustomPaint(
                          painter: ShapePainter(value1: value1, value2: value2),
                          child: child,
                        );
                      },
                    );
                  },
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final double value1;
  final double value2;

  ShapePainter({@required this.value1, @required this.value2});

  @override
  void paint(Canvas canvas, Size size) {
    final isOpen = value1 == 1;

    // Paints
    var openSheetPaint = Paint()..color = Colors.white;
    var staticOpenSheetPaint = Paint()..color = Colors.grey[100];
    var textPaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 2;
    var staticSheetPaint1 = Paint()..color = Colors.grey[200];
    var staticSheetPaint2 = Paint()..color = Colors.grey[300];
    var letterPaint = Paint()
      ..color = Colors.yellow[700];
    var transparentPaint = Paint()..color = Colors.transparent;

    // Paths
    var staticOpenSheetPath = Path()
      ..addPolygon([
        Offset(0, 0),
        Offset(200, 0),
        Offset(200, 50),
        Offset(100, 100),
        Offset(0, 50),
      ], true);

    var openSheetPath = Path()
      ..addPolygon([
        Offset(0, 0),
        Offset(200, 0),
        Offset(200, 50 + (-100 * value1)),
        Offset(100, 100 + (-200 * value1)),
        Offset(0, 50 + (-100 * value1)),
      ], true);

    var staticSheetPath1 = Path()
      ..addPolygon([
        Offset(0, 50),
        Offset(200, 150),
        Offset(0, 150),
      ], true);

    var staticSheetPath2 = Path()
      ..addPolygon([
        Offset(200, 50),
        Offset(200, 150),
        Offset(0, 150),
      ], true);

    var letterPath = Path()
      ..addRect(Rect.fromPoints(
          Offset(20, 20 + (-60 * value2)),
          Offset(
            180,
            130 + (-60 * value2),
          )));

    canvas.drawPath(staticOpenSheetPath, staticOpenSheetPaint);
    canvas.drawPath(openSheetPath, openSheetPaint);

    canvas.drawPath(letterPath, letterPaint); // letter sheet
    canvas.drawLine(Offset(40, 40 + (-60 * value2)),
        Offset(160, 40 + (-60 * value2)), textPaint); // letter text 1
    canvas.drawLine(Offset(40, 50 + (-60 * value2)),
        Offset(160, 50 + (-60 * value2)), textPaint); // letter text 2
    canvas.drawLine(Offset(40, 60 + (-60 * value2)),
        Offset(160, 60 + (-60 * value2)), textPaint); // letter text 3
    canvas.drawLine(Offset(120, 100 + (-60 * value2)),
        Offset(160, 100 + (-60 * value2)), textPaint); // letter text 4
    canvas.drawLine(Offset(120, 110 + (-60 * value2)),
        Offset(160, 110 + (-60 * value2)), textPaint); // letter text 4

    !isOpen
        ? canvas.drawPath(openSheetPath, openSheetPaint)
        : canvas.drawPath(openSheetPath, transparentPaint);

    canvas.drawPath(staticSheetPath1, staticSheetPaint1);
    canvas.drawPath(staticSheetPath2, staticSheetPaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
