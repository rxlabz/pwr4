import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:p_four/grid.dart';

void main() {
  late Grid grid;

  setUp(() {
    grid = Grid.init(numRows: 6, numColumns: 7);
  });

  test('findTopLeftDiagonal', () {
    expect(findTopLeftDiagonalStart((x: 1, y: 5)), (x: 0, y: 4));

    expect(findTopLeftDiagonalStart((x: 6, y: 5)), (x: 1, y: 0));

    expect(findTopLeftDiagonalStart((x: 3, y: 2)), (x: 1, y: 0));

    expect(findTopLeftDiagonalStart((x: 0, y: 5)), (x: 0, y: 5));
  });

  test('findBottomRightDiagonal', () {
    expect(findBottomRightDiagonalEnd((x: 1, y: 5), numCols: 7, numRows: 6),
        (x: 1, y: 5));

    expect(findBottomRightDiagonalEnd((x: 0, y: 5), numCols: 7, numRows: 6),
        (x: 0, y: 5));

    expect(findBottomRightDiagonalEnd((x: 3, y: 2), numCols: 7, numRows: 6),
        (x: 6, y: 5));

    expect(findBottomRightDiagonalEnd((x: 4, y: 1), numCols: 7, numRows: 6),
        (x: 6, y: 3));
  });

  test('findTopRightDiagonal', () {
    expect(findTopRightDiagonalEnd((x: 1, y: 5), numCols: 7), (x: 6, y: 0));

    expect(findTopRightDiagonalEnd((x: 0, y: 5), numCols: 7), (x: 5, y: 0));

    expect(findTopRightDiagonalEnd((x: 3, y: 2), numCols: 7), (x: 5, y: 0));

    expect(findTopRightDiagonalEnd((x: 6, y: 5), numCols: 7), (x: 6, y: 5));
  });

  test('findBottomLeftDiagonal', () {
    expect(findBottomLeftDiagonalStart((x: 1, y: 5), numRows: 6), (x: 1, y: 5));

    expect(findBottomLeftDiagonalStart((x: 0, y: 5), numRows: 6), (x: 0, y: 5));

    expect(findBottomLeftDiagonalStart((x: 3, y: 2), numRows: 6), (x: 0, y: 5));

    expect(findBottomLeftDiagonalStart((x: 4, y: 1), numRows: 6), (x: 0, y: 5));
  });

  test('getCellsDiagonal 0-0', () {
    final cells = getCellsTLBRDiagonal((x: 0, y: 0), (x: 5, y: 5));
    expect(
      const ListEquality().equals(cells, [
        (x: 0, y: 0),
        (x: 1, y: 1),
        (x: 2, y: 2),
        (x: 3, y: 3),
        (x: 4, y: 4),
        (x: 5, y: 5),
      ]),
      true,
    );
  });

  test('getCellsDiagonal 3-0', () {
    final cells = getCellsTLBRDiagonal((x: 3, y: 0), (x: 6, y: 3));
    expect(
      const ListEquality().equals(cells, [
        (x: 3, y: 0),
        (x: 4, y: 1),
        (x: 5, y: 2),
        (x: 6, y: 3),
      ]),
      true,
    );
  });

  test('getCellsDiagonal from calculated TL & BR', () {
    const cell = (x: 1, y: 2);

    final tl = findTopLeftDiagonalStart(cell);
    final br = findBottomRightDiagonalEnd(
      cell,
      numCols: grid.numColumns,
      numRows: grid.numRows,
    );

    final cells = getCellsTLBRDiagonal(tl, br);
    expect(
      const ListEquality().equals(cells, [
        (x: 0, y: 1),
        (x: 1, y: 2),
        (x: 2, y: 3),
        (x: 3, y: 4),
        (x: 4, y: 5),
      ]),
      true,
    );
  });

  test('getCellsDiagonal from calculated BL & TR', () {
    const cell = (x: 1, y: 2);

    final tl = findBottomLeftDiagonalStart(cell, numRows: grid.numRows);
    final br = findTopRightDiagonalEnd(cell, numCols: grid.numColumns);

    final cells = getCellsBLTRDiagonal(tl, br);
    expect(
      const ListEquality().equals(cells, [
        (x: 0, y: 3),
        (x: 1, y: 2),
        (x: 2, y: 1),
        (x: 3, y: 0),
      ]),
      true,
    );
  });
}
