import gleam/bit_array
import gleam/list
import gleam/result
import gleam/string

pub fn rotate(shift_key: Int, text: String) -> String {
  text
  |> string.to_graphemes
  |> list.map(maybe_rotate(_, shift_key % 26))
  |> string.join("")
}

fn maybe_rotate(letter: String, shift_key: Int) -> String {
  let arr = bit_array.from_string(letter)

  case arr {
    <<l:8>> if 65 <= l && l <= 90 -> cipher_text(l, shift_key, 90)
    <<l:8>> if 97 <= l && l <= 122 -> cipher_text(l, shift_key, 122)
    _ -> letter
  }
}

fn cipher_text(utf_letter: Int, shift_key: Int, window: Int) {
  let cipher = roundaround(utf_letter + shift_key, window)
  bit_array.to_string(<<cipher>>)
  |> result.unwrap("")
}

fn roundaround(value: Int, max: Int) {
  case value {
    _ if value > max -> roundaround(value - 26, max)
    _ -> value
  }
}
