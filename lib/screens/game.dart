import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tic_tac_toe/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool oTurn = true;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  bool winnerFound = false;
  Timer? timer;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  String resultDeclaration = '';
  int attempts = 0;
  List<int> matchIndexces = [];
  List<String> displayXO = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() {
    seconds = maxSeconds;
  }

  static var customFontWhite = GoogleFonts.coiny(
      textStyle:
          const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 28));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Player O',
                              style: customFontWhite,
                            ),
                            Text(
                              oScore.toString(),
                              style: customFontWhite,
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Player X',
                              style: customFontWhite,
                            ),
                            Text(
                              xScore.toString(),
                              style: customFontWhite,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: GridView.builder(
                      itemCount: 9,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          onTap: () {
                            _tapped(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 5, color: MainColor.primaryColor),
                                color: matchIndexces.contains(index)
                                    ? MainColor.asccentColor
                                    : MainColor.secondaryColor),
                            child: Center(
                              child: Text(
                                displayXO[index],
                                style: GoogleFonts.coiny(
                                    textStyle: TextStyle(
                                        fontSize: 64,
                                        color: MainColor.primaryColor)),
                              ),
                            ),
                          ),
                        );
                      })),
              Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          resultDeclaration,
                          style: customFontWhite,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildtimer()
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
          filledBoxes++;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filledBoxes++;
        }
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  Widget buildtimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSeconds,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                  backgroundColor: MainColor.asccentColor,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 50),
                  ),
                )
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            onPressed: () {
              startTimer();
              _clearBoard();
              attempts++;
            },
            child: Text(
              attempts == 0 ? 'Start' : 'Play Again',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ));
  }

  void _checkWinner() {
    //1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[0]} wins!';
        matchIndexces.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }
    //2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[3]} wins!';
        matchIndexces.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(displayXO[3]);
      });
    }
    //3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[6]} wins!';
        matchIndexces.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(displayXO[6]);
      });
    }

    //1st column
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[0]} wins!';
        matchIndexces.addAll([0, 3, 6]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[1]} wins!';
        matchIndexces.addAll([1, 4, 7]);
        stopTimer();
        _updateScore(displayXO[1]);
      });
    }
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[2]} wins!';
        matchIndexces.addAll([2, 5, 8]);
        stopTimer();
        _updateScore(displayXO[2]);
      });
    }

    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[0]}wins!';
        matchIndexces.addAll([0, 4, 8]);
        stopTimer();
        _updateScore(displayXO[0]);
      });
    }

    if (displayXO[2] == displayXO[4] &&
        displayXO[2] == displayXO[6] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = 'Player ${displayXO[2]}wins!';
        matchIndexces.addAll([2, 4, 6]);
        stopTimer();
        _updateScore(displayXO[2]);
      });
    }

    if (filledBoxes == 9 && !winnerFound) {
      setState(() {
        resultDeclaration = 'No one win the game! ;(';
        stopTimer();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore += 1;
    } else if (winner == 'X') {
      xScore += 1;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
    });
    filledBoxes = 0;
  }
}
