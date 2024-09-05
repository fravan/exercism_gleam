import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}
import gleam/string

pub fn count_words(input: String) -> Dict(String, Int) {
  input
  |> string.lowercase()
  |> string.to_graphemes()
  |> normalize_string("", [])
  |> build_dict()
}

const allowed_letters = "abcdefghijklmnopqrstuvwxyz1234567890"

fn normalize_string(
  input: List(String),
  current_read_word: String,
  output: List(String),
) {
  case input, current_read_word {
    [], _ -> [current_read_word, ..output]
    // Ignore starting quotes, or ending quotes
    ["'", ..rest], "" -> normalize_string(rest, "", output)
    // Any other quotes must be surrounded by an allowed character
    ["'", after, ..rest], _ -> {
      case string.contains(allowed_letters, after) {
        True ->
          normalize_string([after, ..rest], current_read_word <> "'", output)
        False -> normalize_string(rest, "", [current_read_word, ..output])
      }
    }
    [first, ..rest], _ -> {
      case string.contains(allowed_letters, first) {
        True -> normalize_string(rest, current_read_word <> first, output)
        False -> normalize_string(rest, "", [current_read_word, ..output])
      }
    }
  }
}

fn build_dict(inputs: List(String)) {
  inputs
  |> list.fold(from: dict.new(), with: fn(acc, input) {
    dict.upsert(acc, input, fn(value) {
      case value {
        None -> 1
        Some(amount) -> 1 + amount
      }
    })
  })
  |> dict.delete("")
}
