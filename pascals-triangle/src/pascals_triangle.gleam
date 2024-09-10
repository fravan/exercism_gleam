import gleam/list

pub fn rows(n: Int) -> List(List(Int)) {
  do_rows(n, [])
}

fn do_rows(n: Int, rows: List(List(Int))) {
  case n {
    0 -> list.reverse(rows)
    _ -> {
      do_rows(n - 1, [generate_row(rows), ..rows])
    }
  }
}

fn generate_row(rows: List(List(Int))) -> List(Int) {
  case rows {
    [] -> [1]
    [last_row, ..] -> generate_columns(from: last_row, starting_with: [1])
  }
}

fn generate_columns(from row: List(Int), starting_with columns: List(Int)) {
  case row {
    [first, second, ..rest] ->
      generate_columns([second, ..rest], [first + second, ..columns])
    _ -> [1, ..columns]
  }
}
