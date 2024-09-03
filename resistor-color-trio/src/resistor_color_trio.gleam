import gleam/float
import gleam/int
import gleam/result

pub type Resistance {
  Resistance(unit: String, value: Int)
}

pub fn label(colors: List(String)) -> Result(Resistance, Nil) {
  case colors {
    [first_value, second_value, unit, ..] -> {
      let total_value =
        get_multiplier(unit)
        * { get_value(first_value) * 10 + get_value(second_value) }
      let #(unit, unit_value) = get_unit(total_value)
      Ok(Resistance(value: total_value / unit_value, unit: unit))
    }
    _ -> Error(Nil)
  }
}

fn get_multiplier(color: String) -> Int {
  int.power(10, of: int.to_float(get_value(color)))
  |> result.unwrap(1.0)
  |> float.round()
}

fn get_value(color: String) -> Int {
  case color {
    "black" -> 0
    "brown" -> 1
    "red" -> 2
    "orange" -> 3
    "yellow" -> 4
    "green" -> 5
    "blue" -> 6
    "violet" -> 7
    "grey" -> 8
    "white" -> 9
    _ -> 0
  }
}

fn get_unit(total_value: Int) -> #(String, Int) {
  case total_value {
    giga if giga >= 1_000_000_000 -> #("gigaohms", 1_000_000_000)
    mega if mega >= 1_000_000 -> #("megaohms", 1_000_000)
    kilo if kilo >= 1000 -> #("kiloohms", 1000)
    _ -> #("ohms", 1)
  }
}
