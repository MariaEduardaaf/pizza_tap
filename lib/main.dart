import 'package:flutter/material.dart';

void main() => runApp(PizzaTapApp());

class PizzaTapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Tap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: PizzaCounterPage(),
    );
  }
}

class PizzaCounterPage extends StatefulWidget {
  @override
  _PizzaCounterPageState createState() => _PizzaCounterPageState();
}

class _PizzaCounterPageState extends State<PizzaCounterPage>
    with SingleTickerProviderStateMixin {
  int _pizzaCount = 0;
  double _scale = 1.0;
  late AnimationController _controller;

  void _increment() {
    setState(() => _pizzaCount++);
    _controller.forward(from: 0);
  }

  void _reset() {
    setState(() => _pizzaCount = 0);
  }

  Color _getBackgroundColor() {
    if (_pizzaCount >= 30) return Colors.redAccent.shade100;
    if (_pizzaCount >= 20) return Colors.orange.shade900;
    if (_pizzaCount >= 10) return Colors.deepOrange.shade700;
    return Colors.black;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {
          _scale = 1 + _controller.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _getBackgroundColor(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Text(
                  '$_pizzaCount',
                  key: ValueKey<int>(_pizzaCount),
                  style: const TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Transform.scale(
                scale: _scale,
                child: ElevatedButton(
                  onPressed: _increment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(30),
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white12,
                  ),
                  child: const Text('🍕', style: TextStyle(fontSize: 50)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _reset,
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
