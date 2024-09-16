import gleam/list
import gleam/result
import gleam/string

pub fn recite(inputs: List(String)) -> String {
  do_recite(inputs, list.first(inputs) |> result.unwrap(""), [])
  |> list.reverse
  |> string.join("\n")
}

fn do_recite(inputs, first_input, acc) {
  case inputs {
    [a, b, ..rest] ->
      do_recite([b, ..rest], first_input, [
        "For want of a " <> a <> " the " <> b <> " was lost.",
        ..acc
      ])
    [] -> acc
    _ -> ["And all for the want of a " <> first_input <> ".", ..acc]
  }
}
