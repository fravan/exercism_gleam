pub fn keep(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  do_keep(list, predicate, []) |> reverse([])
}

fn do_keep(list: List(t), predicate: fn(t) -> Bool, acc: List(t)) -> List(t) {
  case list {
    [] -> acc
    [first, ..rest] ->
      case predicate(first) {
        True -> do_keep(rest, predicate, [first, ..acc])
        False -> do_keep(rest, predicate, acc)
      }
  }
}

pub fn discard(list: List(t), predicate: fn(t) -> Bool) -> List(t) {
  keep(list, fn(t) { !predicate(t) })
}

fn reverse(list: List(t), acc: List(t)) -> List(t) {
  case list {
    [] -> acc
    [first, ..rest] -> reverse(rest, [first, ..acc])
  }
}
