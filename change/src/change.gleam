import gleam/bool
import gleam/int
import gleam/list
import gleam/result

pub type Error {
  ImpossibleTarget
}

pub fn find_fewest_coins(
  coins: List(Int),
  target: Int,
) -> Result(List(Int), Error) {
  do_find(coins, target, [])
  |> result.map(list.reverse)
}

fn do_find(coins: List(Int), target: Int, returned_coins: List(Int)) {
  let delta = target - int.sum(returned_coins)
  use <- bool.guard(when: delta == 0, return: Ok(returned_coins))

  case coins {
    [] -> Error(ImpossibleTarget)
    [a, ..rest] -> {
      let multiplier = delta / a
      list.range(0, multiplier)
      |> list.fold_until(from: Error(ImpossibleTarget), with: fn(_, current) {
        case
          do_find(
            rest,
            target,
            list.concat([list.repeat(a, times: current), returned_coins]),
          )
        {
          Ok(a) -> list.Stop(Ok(a))
          Error(_) -> list.Continue(Error(ImpossibleTarget))
        }
      })
    }
  }
}
