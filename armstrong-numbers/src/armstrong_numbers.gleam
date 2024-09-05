import gleam/int
import gleam/list
import gleam/result

pub fn is_armstrong_number(number: Int) -> Bool {
  let result =
    number
    |> int.digits(10)
    |> result.map(fn(digits) {
      let number_of_digits = list.length(digits)
      digits
      |> list.fold(from: 0, with: fn(acc, digit) {
        acc + int.product(list.repeat(digit, number_of_digits))
      })
    })

  case result {
    Ok(total) -> total == number
    Error(_) -> False
  }
}
