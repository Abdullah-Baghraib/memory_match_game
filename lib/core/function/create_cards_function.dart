  import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memory_match_game/data/memory_card_model.dart';

List<MemoryCard> createCards() 
  {
    final iconConfigs = 
    [
      {'icon': Icons.favorite, 'color': Colors.pink.shade400},
      {'icon': Icons.star, 'color': Colors.amber.shade400},
      {'icon': Icons.wb_sunny, 'color': Colors.yellow.shade400},
      {'icon': Icons.nightlight_round, 'color': Colors.purple.shade400},
      {'icon': Icons.cloud, 'color': Colors.lightBlue.shade400},
      {'icon': Icons.local_florist, 'color': Colors.green.shade400},
    ];

    final List<MemoryCard> newCards = [];

    for (int i = 0; i < iconConfigs.length; i++) 
    {
      newCards.add(
        MemoryCard(
          id: i * 2,
          icon: iconConfigs[i]['icon'] as IconData,
          color: iconConfigs[i]['color'] as Color,
        ),
      );
      newCards.add(
        MemoryCard(
          id: i * 2 + 1,
          icon: iconConfigs[i]['icon'] as IconData,
          color: iconConfigs[i]['color'] as Color,
        ),
      );
    }

    newCards.shuffle(Random());
    return newCards;
  }