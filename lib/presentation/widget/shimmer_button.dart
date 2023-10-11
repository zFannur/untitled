import 'package:flutter/material.dart';

class ShimmerButton extends StatefulWidget {
  final Function () onPressed;
  final String text;

  const ShimmerButton({super.key, required this.onPressed, required this.text});

  @override
  ShimmerButtonState createState() => ShimmerButtonState();
}

class ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _colorAnimation =
        ColorTween(begin: Colors.lightGreen[100], end: Colors.lightGreen)
            .animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.repeat(
      reverse: true,
    );
    return MaterialButton(
      onPressed: widget.onPressed,
      textColor: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) => Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: _colorAnimation.value!.withOpacity(0.6),
                    blurRadius: 16.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      -4.0,
                      -4.0,
                    ),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _colorAnimation.value!,
                    _colorAnimation.value!.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              height: 48.0,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}