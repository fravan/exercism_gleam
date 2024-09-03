import gleam/option.{type Option, None, Some}

pub fn two_fer(name: Option(String)) -> String {
  case name {
    None -> "One for you, one for me."
    Some(n) -> "One for " <> n <> ", one for me."
  }
}
