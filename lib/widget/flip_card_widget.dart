import 'dart:math';

import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final bool isFlipped;
  final Color frontColor;
  final Color frontBorderColor;
  final IconData backIcon;
  final Color backIconColor;
  final bool isMatched;

  const FlipCard({
    Key? key,
    required this.isFlipped,
    required this.frontColor,
    required this.frontBorderColor,
    required this.backIcon,
    required this.backIconColor,
    required this.isMatched,
  }) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_animation.value > 0.5) {
            _showFront = false;
          } else {
            _showFront = true;
          }
        });
      });
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final transform =
            Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child:
              _showFront
                  ? _buildFront()
                  : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(),
                  ),
        );
      },
    );
  }

  Widget _buildFront() {
    // final screenSize = MediaQuery.of(context).size;
    // final iconSize = screenSize.width * 0.08;

    return Container(
      decoration: BoxDecoration(
        color: widget.frontColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.frontBorderColor),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            const Color(0xFF6366F1).withAlpha(13),
            Colors.white.withAlpha(13),
          ],
        ),
      ),
    );
  }

  Widget _buildBack() {
    final screenSize = MediaQuery.of(context).size;
    final iconSize = screenSize.width * 0.1;

    return Container(
      decoration: BoxDecoration(
        color: widget.frontColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.frontBorderColor),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            const Color(0xFF6366F1).withAlpha(13),
            Colors.white.withAlpha(13),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          widget.backIcon,
          size: iconSize,
          color: widget.backIconColor,
          shadows:
              widget.isMatched
                  ? [Shadow(color: Colors.white.withAlpha(77), blurRadius: 8)]
                  : null,
        ),
      ),
    );
  }
}
