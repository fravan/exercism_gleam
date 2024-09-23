import gleam/bool
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string

pub type Error {
  ImpossibleTarget
}

pub fn find_fewest_coins(
  coins: List(Int),
  target: Int,
) -> Result(List(Int), Error) {
  let sorted_coins = list.sort(coins, order.reverse(int.compare))
  do_find(sorted_coins, target, [])
}

fn do_find(coins: List(Int), target: Int, returned_coins: List(Int)) {
  let delta = target - int.sum(returned_coins)
  use <- bool.guard(when: delta == 0, return: Ok(returned_coins))

  case coins {
    [] -> Error(ImpossibleTarget)
    [a, ..rest] -> {
      let multiplier = delta / a
      list.range(0, multiplier)
      |> list.map(fn(multiply) {
        do_find(
          rest,
          target,
          list.concat([list.repeat(a, times: multiply), returned_coins]),
        )
      })
      |> list.fold(from: Error(ImpossibleTarget), with: fn(acc, current) {
        case acc, current {
          Error(_), Ok(_) -> current
          Ok(list_a), Ok(list_b) -> {
            case list.length(list_a) > list.length(list_b) {
              True -> current
              False -> acc
            }
          }
          _, _ -> acc
        }
      })
    }
  }
}
