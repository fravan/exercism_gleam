import gleam/bool

pub type Comparison {
  Equal
  Unequal
  Sublist
  Superlist
}

pub fn sublist(compare list_a: List(a), to list_b: List(a)) -> Comparison {
  use <- bool.guard(when: list_a == list_b, return: Equal)
  use <- bool.guard(when: list_a |> contains(list_b), return: Superlist)
  use <- bool.guard(when: list_b |> contains(list_a), return: Sublist)
  Unequal
}

fn contains(list_a: List(a), list_b: List(a)) {
  case list_a, list_b {
    _, [] -> True
    [], _ -> False
    _, _ -> {
      case contains_simple(list_a, list_b) {
        True -> True
        False -> contains(tail(list_a), list_b)
      }
    }
  }
}

fn contains_simple(list_a: List(a), list_b: List(a)) {
  case list_a, list_b {
    _, [] -> True
    [a, ..rest_a], [b, ..rest_b] if a == b -> contains_simple(rest_a, rest_b)
    _, _ -> False
  }
}

fn tail(list: List(a)) {
  case list {
    [] -> []
    [_, ..tail] -> tail
  }
}
