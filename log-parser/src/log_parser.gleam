import gleam/option.{Some}
import gleam/regex.{Match}

pub fn is_valid_line(line: String) -> Bool {
  case line {
    "[DEBUG]" <> _ | "[INFO]" <> _ | "[WARNING]" <> _ | "[ERROR]" <> _ -> True
    _ -> False
  }
}

pub fn split_line(line: String) -> List(String) {
  let assert Ok(re) = regex.from_string("<[~*=-]*>")
  regex.split(re, line)
}

pub fn tag_with_user_name(line: String) -> String {
  let assert Ok(re) = regex.from_string("User\\s+(\\S+)")
  let matches = regex.scan(with: re, content: line)
  case matches {
    [Match(submatches: [Some(user)], ..), ..] ->
      "[USER] " <> user <> " " <> line
    _ -> line
  }
}
