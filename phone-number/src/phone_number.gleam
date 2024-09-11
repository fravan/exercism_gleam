import gleam/bool
import gleam/list.{Continue, Stop}
import gleam/result
import gleam/string

const letters = "abcdefghijklmnopqrstuvwxyz"

pub fn clean(input: String) -> Result(String, String) {
  input
  |> string.to_graphemes
  |> list.fold_until(from: Ok(""), with: normalize_input)
  |> result.try(map_to_phone_number)
}

fn normalize_input(
  normalized_input: Result(String, String),
  current_letter: String,
) {
  let is_number = "0123456789" |> string.contains(current_letter)
  let is_ignorable = "+() .-" |> string.contains(current_letter)

  case is_number, is_ignorable, normalized_input {
    _, True, _ -> Continue(normalized_input)
    True, _, Ok(normalized) -> Continue(Ok(normalized <> current_letter))
    _, _, _ -> {
      case string.contains(letters, current_letter) {
        True -> Stop(Error("letters not permitted"))
        False -> Stop(Error("punctuations not permitted"))
      }
    }
  }
}

fn map_to_phone_number(input: String) {
  let size = string.length(input)
  use <- bool.guard(
    when: size <= 9,
    return: Error("must not be fewer than 10 digits"),
  )
  use <- bool.guard(
    when: size > 11,
    return: Error("must not be greater than 11 digits"),
  )

  case size, input {
    11, "1" <> rest_of_input -> map_to_phone_number(rest_of_input)
    11, _ -> Error("11 digits must start with 1")
    _, _ -> {
      let area_code = string.slice(input, 0, 3)
      let exchange_code = string.slice(input, 3, 3)

      case area_code, exchange_code {
        "0" <> _, _ -> Error("area code cannot start with zero")
        "1" <> _, _ -> Error("area code cannot start with one")
        _, "0" <> _ -> Error("exchange code cannot start with zero")
        _, "1" <> _ -> Error("exchange code cannot start with one")
        _, _ -> Ok(input)
      }
    }
  }
}
