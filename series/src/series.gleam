import gleam/bool
import gleam/list
import gleam/string

pub type Error {
  SliceLengthNegative
  EmptySeries
  SliceLengthZero
  SliceLengthTooLarge
}

pub fn slices(input: String, size: Int) -> Result(List(String), Error) {
  use <- bool.guard(when: input == "", return: Error(EmptySeries))
  use <- bool.guard(when: size == 0, return: Error(SliceLengthZero))
  use <- bool.guard(when: size < 0, return: Error(SliceLengthNegative))
  use <- bool.guard(
    when: string.length(input) < size,
    return: Error(SliceLengthTooLarge),
  )

  input
  |> string.to_graphemes
  |> list.window(size)
  |> list.map(string.concat)
  |> Ok
}
