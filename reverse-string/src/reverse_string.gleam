import gleam/string

pub fn reverse(value: String) -> String {
  value
  |> string.to_graphemes()
  |> do_reverse("")
}

fn do_reverse(value: List(String), reversed: String) -> String {
  case value {
    [] -> reversed
    [letter, ..rest] -> do_reverse(rest, letter <> reversed)
  }
}
