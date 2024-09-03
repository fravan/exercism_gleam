import gleam/list
import gleam/string

pub fn recite(
  start_bottles start_bottles: Int,
  take_down take_down: Int,
) -> String {
  list.range(start_bottles, start_bottles - take_down + 1)
  |> list.fold(from: [], with: fn(acc, amount) { [print_verse(amount), ..acc] })
  |> list.reverse()
  |> string.join("\n\n")
}

fn get_verse() {
  ":AMOUNT_START green :NAME_START hanging on the wall,
:AMOUNT_START green :NAME_START hanging on the wall,
And if one green bottle should accidentally fall,
There'll be :AMOUNT_END green :NAME_END hanging on the wall."
}

fn print_verse(amount: Int) -> String {
  get_verse()
  |> string.replace(
    each: ":AMOUNT_START",
    with: string.capitalise(get_number(amount)),
  )
  |> string.replace(each: ":NAME_START", with: get_bottles(amount))
  |> string.replace(each: ":AMOUNT_END", with: get_number(amount - 1))
  |> string.replace(each: ":NAME_END", with: get_bottles(amount - 1))
}

fn get_number(amount: Int) -> String {
  case amount {
    0 -> "no"
    1 -> "one"
    2 -> "two"
    3 -> "three"
    4 -> "four"
    5 -> "five"
    6 -> "six"
    7 -> "seven"
    8 -> "eight"
    9 -> "nine"
    10 -> "ten"
    _ -> "too many"
  }
}

fn get_bottles(amount: Int) -> String {
  case amount {
    1 -> "bottle"
    _ -> "bottles"
  }
}
