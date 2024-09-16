import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

pub fn encode(plaintext: String) -> String {
  plaintext
  |> string.to_graphemes
  |> list.fold(from: #("", "", 0), with: fn(acc, read) {
    let #(encoded, letter, count) = acc
    case read == letter {
      True -> #(encoded, letter, count + 1)
      False -> #(write_encodings(encoded, letter, count), read, 1)
    }
  })
  |> fn(encodings: #(String, String, Int)) {
    let #(encoded, current_letter, current_count) = encodings
    write_encodings(encoded, current_letter, current_count)
  }
}

pub fn decode(ciphertext: String) -> String {
  ciphertext
  |> string.to_graphemes
  |> list.fold(from: #("", ""), with: fn(acc, read) {
    case read {
      "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" -> #(
        acc.0,
        acc.1 <> read,
      )
      _ -> {
        let count = int.parse(acc.1) |> result.unwrap(1)
        #(acc.0 <> string.repeat(read, times: count), "")
      }
    }
  })
  |> pair.first
}

fn write_encodings(encoded: String, letter: String, count: Int) {
  case count {
    0 -> encoded
    1 -> encoded <> letter
    _ -> encoded <> int.to_string(count) <> letter
  }
}
