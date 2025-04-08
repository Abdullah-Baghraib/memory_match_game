import 'package:flutter/material.dart';

class resetGameButton extends StatelessWidget {
  final void Function()? resetGame ;
  const resetGameButton({
    super.key,
    required this.screenSize, required this.resetGame,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton
    (
      onPressed: resetGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E1B4B),
        foregroundColor: const Color(0xFFC7D2FE),
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.1,
          vertical: screenSize.height * 0.02,
        ),
        side: const BorderSide(color: Color(0xFF4338CA)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Start New Game',
        style: TextStyle(fontSize: screenSize.width * 0.04),
      ),
    );
  }
}