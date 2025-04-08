import 'package:flutter/material.dart';

class MemoryCard {
  final int id;
  final IconData icon;
  final Color color;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.icon,
    required this.color,
    this.isMatched = false,
  });

  MemoryCard copyWith({bool? isMatched}) {
    return MemoryCard(
      id: id,
      icon: icon,
      color: color,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}