import gleam/bool

pub type Error {
  NonPositiveNumber
}

pub fn steps(number: Int) -> Result(Int, Error) {
  do_steps(number, 0)
}

fn do_steps(number: Int, steps_count: Int) {
  use <- bool.guard(when: number <= 0, return: Error(NonPositiveNumber))
  use <- bool.guard(when: number == 1, return: Ok(steps_count))
  case number % 2 {
    0 -> do_steps(number / 2, steps_count + 1)
    _ -> do_steps(number * 3 + 1, steps_count + 1)
  }
}
