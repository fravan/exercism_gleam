import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/result

pub type Error {
  InvalidSquare
}

pub fn square(square: Int) -> Result(Int, Error) {
  use <- bool.guard(
    when: square <= 0 || square > 64,
    return: Error(InvalidSquare),
  )
  int.power(2, int.to_float(square) -. 1.0)
  |> result.map(float.round)
  |> result.map_error(fn(_) { InvalidSquare })
}

pub fn total() -> Int {
  list.range(1, 64)
  |> list.fold(from: 0, with: fn(acc, curr) {
    let assert Ok(sq) = square(curr)
    acc + sq
  })
}
