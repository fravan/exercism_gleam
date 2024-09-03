import gleam/list
import gleam/result

pub fn convert(number: Int) -> String {
  do_convert(number, "")
}

const map = [
  #(1000, "M"), #(900, "CM"), #(500, "D"), #(400, "CD"), #(100, "C"),
  #(90, "XC"), #(50, "L"), #(40, "XL"), #(10, "X"), #(9, "IX"), #(5, "V"),
  #(4, "IV"), #(1, "I"),
]

fn do_convert(number: Int, accumulator: String) -> String {
  case number {
    finished if finished <= 0 -> accumulator
    _ -> {
      let #(arabic, roman) =
        list.find(map, fn(tuple) { number >= tuple.0 })
        |> result.unwrap(#(1, "I"))
      do_convert(number - arabic, accumulator <> roman)
    }
  }
}
