import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

fn increment(amount: Option(Int)) {
  case amount {
    None -> 1
    Some(amount) -> amount + 1
  }
}

pub fn nucleotide_count(dna: String) -> Result(Dict(String, Int), Nil) {
  dna
  |> string.uppercase
  |> string.to_graphemes
  |> list.try_fold(
    from: dict.from_list([#("A", 0), #("C", 0), #("G", 0), #("T", 0)]),
    with: fn(acc, letter) {
      case letter {
        "A" | "C" | "G" | "T" -> Ok(dict.upsert(acc, letter, increment))
        _ -> Error(Nil)
      }
    },
  )
}
