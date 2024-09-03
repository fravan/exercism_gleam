import gleam/string

pub fn message(log_line: String) -> String {
  case log_line {
    "[ERROR]: " <> message -> message
    "[WARNING]: " <> message -> message
    "[INFO]: " <> message -> message
    _ -> log_line
  }
  |> string.trim
}

pub fn log_level(log_line: String) -> String {
  case log_line {
    "[ERROR]: " <> _ -> "error"
    "[WARNING]: " <> _ -> "warning"
    "[INFO]: " <> _ -> "info"
    _ -> log_line
  }
}

pub fn reformat(log_line: String) -> String {
  case log_line {
    "[ERROR]: " <> message -> string.trim(message) <> " (error)"
    "[WARNING]: " <> message -> string.trim(message) <> " (warning)"
    "[INFO]: " <> message -> string.trim(message) <> " (info)"
    _ -> log_line
  }
}
