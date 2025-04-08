import 'package:flutter/material.dart';
import 'package:memory_match_game/data/memory_card_model.dart';

class score extends StatelessWidget {
  const score({
    super.key,
    required this.matches,
    required this.cards,
    required this.screenSize,
  });

  final int matches;
  final List<MemoryCard> cards;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Text('Matches found: $matches of ${cards.length ~/ 2}',style: TextStyle(  fontSize: screenSize.width * 0.03,  color: const Color(0xFFC7D2FE),  ),);
  }
}