import 'package:flutter/cupertino.dart';

import 'grid.dart';

class P4Controller extends ChangeNotifier {
  late final Grid _grid;

  int numTurns = 0;

  List<Cell>? winningCells;

  int get nextPlayerIndex => (numTurns % 2) + 1;

  bool get complete => winningCells != null;

  bool get isDraw => winningCells == null && _grid.isFilled;

  bool get nextIsRed => nextPlayerIndex == 1;

  int get numColumns => _grid.numColumns;

  Grid get grid => _grid;

  P4Controller() : _grid = Grid.init(numRows: 6, numColumns: 7);

  bool canAddToColumn(int col) => !_grid.columnIsFilled(col);

  void addToColumn(int col) {
    final p = (numTurns % 2) + 1;

    final rowIndex = _grid.addToColumn(col, p);

    if (rowIndex != null) {
      final cell = (x: col, y: rowIndex, p: p);

      winningCells = _grid.hasWinningLine(cell);

      if (complete) {
        notifyListeners();
        return;
      }
    }

    numTurns++;
    notifyListeners();
  }

  void clear() {
    numTurns = 0;
    winningCells = null;
    _grid.clear();

    notifyListeners();
  }
}
