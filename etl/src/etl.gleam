import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub fn transform(legacy: Dict(Int, List(String))) -> Dict(String, Int) {
  legacy
  |> dict.to_list
  |> list.flat_map(fn(entry) {
    let #(score, letters) = entry
    letters
    |> list.map(fn(letter) { #(string.lowercase(letter), score) })
  })
  |> dict.from_list
}
