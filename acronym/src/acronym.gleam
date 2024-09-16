import gleam/list
import gleam/result
import gleam/string

pub fn abbreviate(phrase phrase: String) -> String {
  phrase
  |> string.replace("-", with: " ")
  |> string.replace("_", with: "")
  |> string.split(" ")
  |> list.map(fn(word) {
    word
    |> string.first
    |> result.map(string.uppercase)
  })
  |> result.values
  |> string.concat
}
