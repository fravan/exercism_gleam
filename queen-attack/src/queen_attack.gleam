import gleam/bool
import gleam/int

pub type Position {
  Position(row: Int, column: Int)
}

pub type Error {
  RowTooSmall
  RowTooLarge
  ColumnTooSmall
  ColumnTooLarge
}

pub fn create(queen: Position) -> Result(Nil, Error) {
  let Position(row, column) = queen
  use <- bool.guard(when: row < 0, return: Error(RowTooSmall))
  use <- bool.guard(when: row >= 8, return: Error(RowTooLarge))
  use <- bool.guard(when: column < 0, return: Error(ColumnTooSmall))
  use <- bool.guard(when: column >= 8, return: Error(ColumnTooLarge))
  Ok(Nil)
}

pub fn can_attack(
  black_queen black_queen: Position,
  white_queen white_queen: Position,
) -> Bool {
  case white_queen, black_queen {
    Position(w_row, _), Position(b_row, _) if w_row == b_row -> True
    Position(_, w_col), Position(_, b_col) if w_col == b_col -> True
    Position(w_row, w_col), Position(b_row, b_col) -> {
      int.absolute_value(w_row - b_row) == int.absolute_value(w_col - b_col)
    }
  }
}
