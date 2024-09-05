import gleam/set
import gleam/string

pub fn is_pangram(sentence: String) -> Bool {
  let all_letters =
    set.from_list(string.to_graphemes("abcdefghijklmnopqrstuvwxyz"))

  sentence
  |> string.lowercase()
  |> string.to_graphemes()
  |> set.from_list
  |> set.is_subset(all_letters, _)
}
