pub fn square_of_sum(n: Int) -> Int {
  let sum = do_square_of_sum(n, 0)
  sum * sum
}

fn do_square_of_sum(n: Int, accumulator: Int) -> Int {
  case n {
    non_positive if non_positive <= 0 -> accumulator
    _ -> do_square_of_sum(n - 1, accumulator + n)
  }
}

pub fn sum_of_squares(n: Int) -> Int {
  do_sum_of_squares(n, 0)
}

fn do_sum_of_squares(n: Int, accumulator: Int) -> Int {
  case n {
    non_positive if non_positive <= 0 -> accumulator
    _ -> do_sum_of_squares(n - 1, accumulator + { n * n })
  }
}

pub fn difference(n: Int) -> Int {
  square_of_sum(n) - sum_of_squares(n)
}
