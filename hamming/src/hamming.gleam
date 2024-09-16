import gleam/bool
import gleam/string

pub fn distance(strand1: String, strand2: String) -> Result(Int, Nil) {
  use <- bool.guard(
    when: string.length(strand1) != string.length(strand2),
    return: Error(Nil),
  )

  do_distance(string.to_graphemes(strand1), string.to_graphemes(strand2), 0)
}

fn do_distance(s1, s2, amount) {
  case s1, s2 {
    [a, ..rest_a], [b, ..rest_b] if a != b ->
      do_distance(rest_a, rest_b, amount + 1)
    [_, ..rest_a], [_, ..rest_b] -> do_distance(rest_a, rest_b, amount)
    _, _ -> Ok(amount)
  }
}
