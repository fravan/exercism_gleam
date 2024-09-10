pub fn append(first first: List(a), second second: List(a)) -> List(a) {
  foldr(first, second, fn(acc, curr) { [curr, ..acc] })
}

pub fn concat(lists: List(List(a))) -> List(a) {
  foldl(lists, [], append)
}

pub fn filter(list: List(a), function: fn(a) -> Bool) -> List(a) {
  foldr(list, [], fn(acc, curr) {
    case function(curr) {
      True -> [curr, ..acc]
      False -> acc
    }
  })
}

pub fn length(list: List(a)) -> Int {
  foldl(list, 0, fn(acc, _) { acc + 1 })
}

pub fn map(list: List(a), function: fn(a) -> b) -> List(b) {
  foldr(list, [], fn(acc, curr) { [function(curr), ..acc] })
}

pub fn foldl(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case list {
    [] -> initial
    [x, ..rest] -> foldl(rest, function(initial, x), function)
  }
}

pub fn foldr(
  over list: List(a),
  from initial: b,
  with function: fn(b, a) -> b,
) -> b {
  case list {
    [] -> initial
    [x, ..rest] -> function(foldr(rest, initial, function), x)
  }
}

pub fn reverse(list: List(a)) -> List(a) {
  foldl(list, [], fn(acc, curr) { [curr, ..acc] })
}
