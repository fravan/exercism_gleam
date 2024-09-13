import gleam/int
import gleam/list
import gleam/string

pub fn score(word: String) -> Int {
  word
  |> string.uppercase
  |> string.to_graphemes
  |> list.map(letter_to_score)
  |> int.sum
}

fn letter_to_score(letter: String) {
  case letter {
    "Q" | "Z" -> 10
    "J" | "X" -> 8
    "K" -> 5
    "F" | "H" | "V" | "W" | "Y" -> 4
    "B" | "C" | "M" | "P" -> 3
    "D" | "G" -> 2
    _ -> 1
  }
}
