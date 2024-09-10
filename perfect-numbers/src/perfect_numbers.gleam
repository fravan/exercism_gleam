import gleam/bool
import gleam/int
import gleam/order.{Eq, Gt, Lt}

pub type Classification {
  Perfect
  Abundant
  Deficient
}

pub type Error {
  NonPositiveInt
}

pub fn classify(number: Int) -> Result(Classification, Error) {
  use <- bool.guard(when: number <= 0, return: Error(NonPositiveInt))

  case int.compare(aliquot_sum(number, 0, 0), number) {
    Lt -> Ok(Deficient)
    Eq -> Ok(Perfect)
    Gt -> Ok(Abundant)
  }
}

// This method is much slower for some reason
// fn aliquot_sum(number: Int) {
//   list.range(1, number / 2)
//   |> list.filter(fn(current) { current != number && number % current == 0 })
//   |> int.sum()
// }
fn aliquot_sum(number: Int, current: Int, sum: Int) {
  case current > number / 2, number % current {
    True, _ -> sum
    False, 0 -> aliquot_sum(number, current + 1, sum + current)
    False, _ -> aliquot_sum(number, current + 1, sum)
  }
}
