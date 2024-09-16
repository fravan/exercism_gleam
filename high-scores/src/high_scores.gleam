import gleam/int
import gleam/list
import gleam/order

pub fn scores(high_scores: List(Int)) -> List(Int) {
  high_scores
}

pub fn latest(high_scores: List(Int)) -> Result(Int, Nil) {
  list.last(high_scores)
}

pub fn personal_best(high_scores: List(Int)) -> Result(Int, Nil) {
  high_scores
  |> list.sort(order.reverse(int.compare))
  |> list.first()
}

pub fn personal_top_three(high_scores: List(Int)) -> List(Int) {
  high_scores
  |> list.sort(order.reverse(int.compare))
  |> list.take(3)
}
