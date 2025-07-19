import 'dart:math';

import 'package:flutter/material.dart';
import 'package:p_four/game_controller.dart';

import 'grid.dart';

void main() {
  runApp(const MainApp());
}

const player1Color = Colors.red;

const player2Color = Colors.amber;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: GameScreen(),
        debugShowCheckedModeBanner: false,
      );
}

class GameScreen extends StatelessWidget {
  final controller = P4Controller();

  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grid = controller.grid;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final textStyle = TextStyle(
          color: controller.complete ? Colors.green : Colors.blueGrey,
          fontSize: 24,
        );
        return Scaffold(
          backgroundColor: Colors.blueGrey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.blueGrey.shade50,
            title: controller.isDraw
                ? Text('Draw', style: textStyle)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Text(
                        'Player ${controller.nextPlayerIndex} ${controller.complete ? 'wins' : ''}',
                        style: textStyle,
                      ),
                      Icon(
                        Icons.circle,
                        color: controller.nextIsRed ? Colors.red : Colors.amber,
                        size: 24,
                      )
                    ],
                  ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: controller.clear,
                icon: const Icon(Icons.sync),
                tooltip: 'New game',
              ),
            ],
          ),
          body: Center(
            child: AspectRatio(
              aspectRatio: grid.numColumns / (grid.numRows + 1),
              child: LayoutBuilder(builder: (context, contraint) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    if (!controller.complete)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          controller.numColumns,
                          (i) => InsertButton(
                            hoverColor: controller.nextPlayerIndex == 1
                                ? player1Color
                                : player2Color,
                            onPressed: controller.canAddToColumn(i)
                                ? () => controller.addToColumn(i)
                                : null,
                          ),
                        ),
                      ),
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: grid.numColumns / grid.numRows,
                        child: P4GridView(
                          grid: grid,
                          winningLine: controller.winningCells,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class InsertButton extends StatefulWidget {
  final VoidCallback? onPressed;

  final Color hoverColor;

  const InsertButton(
      {super.key, required this.onPressed, required this.hoverColor});

  @override
  State<InsertButton> createState() => _InsertButtonState();
}

class _InsertButtonState extends State<InsertButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => hovered = true),
      onExit: (e) => setState(() => hovered = false),
      child: IconButton(
        onPressed: widget.onPressed,
        iconSize: 32,
        color: hovered ? widget.hoverColor : Colors.black54,
        icon: const Icon(Icons.arrow_drop_down_circle),
      ),
    );
  }
}

class P4GridView extends StatelessWidget {
  final Grid grid;

  final List<Cell>? winningLine;

  const P4GridView({
    super.key,
    required this.grid,
    required this.winningLine,
  });

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: GridPainter(grid, winningLine: winningLine),
      );
}

class GridPainter extends CustomPainter {
  final Grid grid;

  final List<Cell>? winningLine;

  GridPainter(this.grid, {required this.winningLine});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromPoints(Offset.zero, size.bottomRight(Offset.zero)),
        Paint()..color = Colors.blueGrey);

    final cellMargin = size.width / 96;
    final cellWidth = size.width / grid.numColumns;
    final cellHeight = size.height / grid.numRows;

    final cellSize = min(cellWidth, cellHeight);

    for (final row in grid.rows.indexed) {
      final (rowIndex, rowValue) = row;

      for (final cell in rowValue.indexed) {
        final (colIndex, cellValue) = cell;
        canvas.drawCircle(
          Offset(
            cell.$1 * cellSize + cellSize / 2,
            rowIndex * cellSize + cellSize / 2,
          ),
          cellSize / 2 - cellMargin * 2,
          Paint()
            ..color = switch (cellValue) {
              1 => player1Color,
              2 => player2Color,
              _ => Colors.blueGrey.shade50,
            },
        );

        if (winningLine?.contains((x: colIndex, y: rowIndex)) == true) {
          canvas.drawCircle(
            Offset(
              cell.$1 * cellSize + cellSize / 2,
              rowIndex * cellSize + cellSize / 2,
            ),
            cellSize / 2 - cellMargin * 2,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Colors.black87,
          );
          canvas.drawCircle(
            Offset(
              cell.$1 * cellSize + cellSize / 2,
              rowIndex * cellSize + cellSize / 2,
            ),
            cellSize / 2 - cellMargin,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.white,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
