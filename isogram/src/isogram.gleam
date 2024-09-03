import gleam/list
import gleam/string

pub fn is_isogram(phrase phrase: String) -> Bool {
  let all_letters =
    phrase
    |> string.lowercase()
    |> string.replace(each: "-", with: "")
    |> string.replace(each: " ", with: "")
    |> string.to_graphemes()

  all_letters == list.unique(all_letters)
}
