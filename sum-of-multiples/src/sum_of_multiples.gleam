import gleam/list
import gleam/set

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  factors
  |> list.flat_map(get_magic_multipliers(_, limit))
  |> set.from_list
  |> set.fold(from: 0, with: fn(acc, x) { acc + x })
}

fn get_magic_multipliers(base: Int, limit: Int) -> List(Int) {
  case base {
    0 -> []
    lower if lower < limit -> do_get_magic_multipliers(base, limit, [lower])
    _ -> []
  }
}

fn do_get_magic_multipliers(base: Int, limit: Int, accumulator: List(Int)) {
  let assert [first, ..] = accumulator
  case first + base < limit {
    False -> accumulator
    True -> do_get_magic_multipliers(base, limit, [first + base, ..accumulator])
  }
}
