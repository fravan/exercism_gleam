import gleam/list
import gleam/string

const brackets = ["(", ")", "{", "}", "[", "]"]

const opening_brackets = ["(", "{", "["]

pub fn is_paired(value: String) -> Bool {
  value
  |> string.to_graphemes()
  |> list.filter(keeping: list.contains(brackets, _))
  |> list.try_fold(from: [], with: fn(opened_brackets, current_bracket) {
    let is_opening_bracket = list.contains(opening_brackets, current_bracket)

    case opened_brackets, is_opening_bracket {
      _, True -> Ok([current_bracket, ..opened_brackets])
      [], False -> Error(Nil)
      [first, ..rest], False -> {
        case first == get_opening_brackets(current_bracket) {
          True -> Ok(rest)
          False -> Error(Nil)
        }
      }
    }
  })
  == Ok([])
}

fn get_opening_brackets(bracket: String) -> String {
  case bracket {
    ")" -> "("
    "}" -> "{"
    "]" -> "["
    _ -> ""
  }
}
