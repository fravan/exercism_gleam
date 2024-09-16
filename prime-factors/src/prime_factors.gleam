import gleam/bool
import gleam/list

pub fn factors(value: Int) -> List(Int) {
  do_factors(value, 2, [])
}

fn do_factors(value: Int, factor: Int, factors: List(Int)) {
  use <- bool.guard(when: value <= 1, return: list.reverse(factors))
  case value % factor {
    0 -> do_factors(value / factor, factor, [factor, ..factors])
    _ -> do_factors(value, factor + 1, factors)
  }
}
