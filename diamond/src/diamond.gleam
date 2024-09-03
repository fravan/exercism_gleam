import gleam/list
import gleam/string

pub fn build(letter: String) -> String {
  case letter {
    "A" -> "A"
    _ -> build_diamond(letter)
  }
}

fn build_diamond(letter: String) -> String {
  let letter_value = get_letter_value(letter)
  let start = get_letter_value("A")
  let diff = letter_value - start

  let half =
    list.range(0, diff - 1)
    |> list.fold(from: [], with: fn(acc, row) {
      [print_current_letter(start:, row:, diff:), ..acc]
    })

  list.concat([
    list.reverse(half),
    [letter <> string.repeat(" ", times: diff * 2 - 1) <> letter],
    half,
  ])
  |> string.join(with: "\n")
}

fn print_current_letter(
  start start: Int,
  row row: Int,
  diff diff: Int,
) -> String {
  let current_letter = get_letter_text(start + row)

  string.repeat(" ", times: diff - row)
  <> case row {
    0 -> current_letter
    _ ->
      current_letter <> string.repeat(" ", times: row * 2 - 1) <> current_letter
  }
  <> string.repeat(" ", times: diff - row)
}

fn get_letter_value(letter: String) -> Int {
  let assert <<character:int>> = <<letter:utf8>>
  character
}

fn get_letter_text(letter: Int) -> String {
  let assert Ok(codepoint) = string.utf_codepoint(letter)
  string.from_utf_codepoints([codepoint])
}
