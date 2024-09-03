import gleam/int

pub fn convert(number: Int) -> String {
  #(number, "")
  |> add_sound("Pling", 3)
  |> add_sound("Plang", 5)
  |> add_sound("Plong", 7)
  |> or_return_default()
}

fn add_sound(
  accumulator: #(Int, String),
  sound: String,
  factor: Int,
) -> #(Int, String) {
  case accumulator {
    #(n, s) if n % factor == 0 -> #(n, s <> sound)
    _ -> accumulator
  }
}

fn or_return_default(accumulator: #(Int, String)) -> String {
  case accumulator {
    #(_, s) if s != "" -> s
    #(n, _) -> int.to_string(n)
  }
}
