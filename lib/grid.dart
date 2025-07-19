typedef Cell = ({int x, int y});

class Grid {
  late final List<List<int>> _table;

  List<List<int>> get rows => _table;

  final int numRows;

  final int numColumns;

  Grid.init({required this.numRows, required this.numColumns}) {
    _table = List.generate(numRows, (j) => List.generate(numColumns, (i) => 0));
  }

  bool get isFilled =>
      List.generate(numColumns, (index) => columnIsFilled(index))
          .every((value) => value);

  int? addToColumn(int col, int value) {
    int indexRow = _table.length - 1;

    while (indexRow >= 0) {
      if (_table[indexRow][col] == 0) {
        _table[indexRow][col] = value;
        return indexRow;
      }

      indexRow--;
    }

    return null;
  }

  @override
  String toString() => _table.join('\n');

  bool columnIsFilled(int col) => _table.every((list) => list[col] != 0);

  List<Cell>? hasWinningLine(({int x, int y, int p}) cell) {
    final (:x, :y, :p) = cell;

    return hasHorizontalWin(y, p) ??
        hasVerticalWin(x, p) ??
        hasDiagonalWin(x, y, p);
  }

  List<Cell>? hasHorizontalWin(int row, int p) {
    final winningLineStart = _table[row].join('').indexOf('$p' * 4);
    if (winningLineStart == -1) return null;

    return List.generate(4, (i) => winningLineStart + i)
        .map((i) => (x: i, y: row))
        .toList();
  }

  List<Cell>? hasVerticalWin(int col, int p) {
    final winningColumnStart =
        _table.map((row) => row[col]).join('').indexOf('$p' * 4);
    if (winningColumnStart == -1) return null;

    return List.generate(4, (i) => winningColumnStart + i)
        .map((i) => (x: col, y: i))
        .toList();
  }

  List<Cell>? hasDiagonalWin(int col, int row, int p) {
    //return null;

    final cell = (x: col, y: row);

    // calcul du top gauche
    final topLeftCell = findTopLeftDiagonalStart(cell);

    // calcul du bottom droit
    final bottomRightCell =
        findBottomRightDiagonalEnd(cell, numCols: numColumns, numRows: numRows);

    final tlbrDiagonal = getCellsTLBRDiagonal(topLeftCell, bottomRightCell);

    final winningDiagonalTopLeft =
        tlbrDiagonal.map((c) => _table[c.y][c.x]).join('').indexOf('$p' * 4);

    if (winningDiagonalTopLeft != -1) {
      return tlbrDiagonal
          .getRange(winningDiagonalTopLeft, winningDiagonalTopLeft + 4)
          .toList();
    }

    // calcul du top droit
    final topRightCell = findTopRightDiagonalEnd(cell, numCols: numColumns);

    // calcul du bottom gauche
    final bottomLeftCell = findBottomLeftDiagonalStart(cell, numRows: numRows);

    final blTrDiagonal = getCellsBLTRDiagonal(bottomLeftCell, topRightCell);

    final winningDiagonalBottomLeft =
        blTrDiagonal.map((c) => _table[c.y][c.x]).join('').indexOf('$p' * 4);

    if (winningDiagonalBottomLeft != -1) {
      return blTrDiagonal
          .getRange(winningDiagonalBottomLeft, winningDiagonalBottomLeft + 4)
          .toList();
      ;
    }

    return null;
  }

  void clear() {
    _table
      ..clear()
      ..addAll(
        List.generate(numRows, (j) => List.generate(numColumns, (i) => 0)),
      );
  }
}

List<Cell> getCellsTLBRDiagonal(Cell topLeftCell, Cell bottomRightCell) {
  final cells = <Cell>[topLeftCell];

  Cell intermediateCell = topLeftCell;
  while (intermediateCell.x < bottomRightCell.x - 1 &&
      intermediateCell.y < bottomRightCell.y - 1) {
    intermediateCell = (x: intermediateCell.x + 1, y: intermediateCell.y + 1);
    cells.add(intermediateCell);
  }

  cells.add(bottomRightCell);

  return cells;
}

List<Cell> getCellsBLTRDiagonal(Cell bottomLeftCell, Cell topRightCell) {
  final cells = <Cell>[bottomLeftCell];

  Cell intermediateCell = bottomLeftCell;
  while (/*intermediateCell.x < bottomRightCell.x - 1 &&*/
      intermediateCell.y > topRightCell.y + 1) {
    intermediateCell = (x: intermediateCell.x + 1, y: intermediateCell.y - 1);
    cells.add(intermediateCell);
  }

  cells.add(topRightCell);

  return cells;
}

Cell findTopLeftDiagonalStart(Cell cell) {
  ({int x, int y}) topLeftCell = cell;
  while (topLeftCell.x > 0 && topLeftCell.y > 0) {
    topLeftCell = (x: topLeftCell.x - 1, y: topLeftCell.y - 1);
  }
  return topLeftCell;
}

Cell findBottomRightDiagonalEnd(
  Cell cell, {
  required int numRows,
  required int numCols,
}) {
  ({int x, int y}) bottomRightCell = cell;
  while (bottomRightCell.x < numCols - 1 && bottomRightCell.y < numRows - 1) {
    bottomRightCell = (x: bottomRightCell.x + 1, y: bottomRightCell.y + 1);
  }
  return bottomRightCell;
}

Cell findTopRightDiagonalEnd(Cell cell, {required int numCols}) {
  ({int x, int y}) topRightCell = cell;
  while (topRightCell.x < numCols - 1 && topRightCell.y > 0) {
    topRightCell = (x: topRightCell.x + 1, y: topRightCell.y - 1);
  }
  return topRightCell;
}

Cell findBottomLeftDiagonalStart(Cell cell, {required int numRows}) {
  ({int x, int y}) bottomLeftCell = cell;
  while (bottomLeftCell.x > 0 && bottomLeftCell.y < numRows - 1) {
    bottomLeftCell = (x: bottomLeftCell.x - 1, y: bottomLeftCell.y + 1);
  }
  return bottomLeftCell;
}
