import 'package:flutter/material.dart';
import 'package:memory_match_game/core/function/create_cards_function.dart';
import 'package:memory_match_game/data/memory_card_model.dart';
import 'package:memory_match_game/widget/app_name.dart';
import 'package:memory_match_game/widget/flip_card_widget.dart';
import 'package:memory_match_game/widget/reset_game_button.dart';
import 'package:memory_match_game/widget/score.dart';

class MemoryGame extends StatefulWidget 
{
  const MemoryGame({Key? key}) : super(key: key);
  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> 
{
  late List<MemoryCard> cards;
  List<int> flippedIndexes = [];
  int matches = 0;
  bool isChecking = false;

  @override
  void initState() 
  {
    super.initState();
    cards = createCards();
  }

  void handleCardClick(int clickedIndex) 
  {
    // Prevent clicking if already checking or card is already matched
    if (isChecking || cards[clickedIndex].isMatched) return;
    // Prevent clicking if card is already flipped
    if (flippedIndexes.contains(clickedIndex)) return;
    // Prevent clicking if two cards are already flipped
    if (flippedIndexes.length == 2) return;

    setState(() {
      flippedIndexes.add(clickedIndex);
    });

    // If we now have two cards flipped, check for a match
    if (flippedIndexes.length == 2) 
    {
      setState(() {
        isChecking = true;
      });

      final firstIndex = flippedIndexes[0];
      final secondIndex = flippedIndexes[1];
      final firstCard = cards[firstIndex];
      final secondCard = cards[secondIndex];

      if (firstCard.icon == secondCard.icon) 
      {
        // Match found
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            cards =
                cards
                    .asMap()
                    .map((index, card) {
                      if (index == firstIndex || index == secondIndex) {
                        return MapEntry(index, card.copyWith(isMatched: true));
                      }
                      return MapEntry(index, card);
                    })
                    .values
                    .toList();

            flippedIndexes = [];
            matches++;
            isChecking = false;
          });

          // Check for game completion
          if (matches == (cards.length ~/ 2)) 
          {
            _showCongratulationsDialog();
          }
        });
      } else {
        // No match - reset after delay
        Future.delayed(const Duration(milliseconds: 1000), () 
        {
          setState(() {
            flippedIndexes = [];
            isChecking = false;
          });
        });
      }
    }
  }

  void resetGame() 
  {
    setState(() {
      cards = createCards();
      flippedIndexes = [];
      matches = 0;
      isChecking = false;
    });
  }

  void _showCongratulationsDialog() 
  {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.purple.shade900,
            title: const Text(
              'Congratulations! 🎉',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'You\'ve found all the matches! 🎈',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  resetGame();
                },
                child: const Text(
                  'Play Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;

    return Scaffold
    (
      body: Container
      (
        decoration: const BoxDecoration
        (
          gradient: LinearGradient
          (
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: 
            [
              Color(0xFF2D1D4A), // purple-950
              Color(0xFF1E1B4B), // indigo-950
              Color(0xFF020617), // slate-950
            ],
          ),
        ),
        child: SafeArea
        (
          child: Center
          (
            child: SingleChildScrollView
            (
              child: Padding
              (
                padding: EdgeInsets.symmetric( horizontal: screenSize.width * 0.05,),
                child: Column
                (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  [
                    SizedBox(height: screenSize.height * 0.02),
                    ShaderMask
                    (
                      shaderCallback:
                          (bounds) => const LinearGradient
                          (
                            colors: 
                            [
                              Color(0xFFD8B4FE), // purple-300
                              Color(0xFFFBCFE8), // pink-300
                              Color(0xFFA5B4FC), // indigo-300
                            ],
                          ).createShader(bounds),
                      child: appName(screenSize: screenSize),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    score(matches: matches, cards: cards, screenSize: screenSize),
                    SizedBox(height: screenSize.height * 0.06),
                    Container
                    (
                      padding: EdgeInsets.all(screenSize.width * 0.04),
                      decoration: BoxDecoration
                      (
                        color: const Color(0xFF1E1B4B).withAlpha(128),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: 
                        [
                          BoxShadow
                          (
                            color: Colors.black.withAlpha(51),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: GridView.builder
                      (
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isPortrait ? 3 : 6,
                          crossAxisSpacing: screenSize.width * 0.03,
                          mainAxisSpacing: screenSize.width * 0.03,
                          childAspectRatio: 1,
                        ),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          final isFlipped =
                              card.isMatched || flippedIndexes.contains(index);

                          return GestureDetector(
                            onTap: () => handleCardClick(index),
                            child: FlipCard(
                              isFlipped: isFlipped,
                              frontColor:
                                  card.isMatched
                                      ? const Color(0xFF312E81).withAlpha(128)
                                      : flippedIndexes.contains(index)
                                      ? const Color(0xFF3730A3).withAlpha(128)
                                      : const Color(0xFF1E1B4B),
                              frontBorderColor:
                                  card.isMatched
                                      ? const Color(0xFF818CF8).withAlpha(128)
                                      : flippedIndexes.contains(index)
                                      ? const Color(0xFF6366F1).withAlpha(128)
                                      : const Color(0xFF3730A3),
                              backIcon: card.icon,
                              backIconColor: card.color,
                              isMatched: card.isMatched,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.1),
                    resetGameButton(screenSize: screenSize , resetGame: resetGame,),
                    SizedBox(height: screenSize.height * 0.06),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}






