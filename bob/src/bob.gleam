import gleam/string

pub fn hey(remark: String) -> String {
  let trimmed_remark = string.trim(remark)
  let is_silence = string.is_empty(trimmed_remark)
  let is_question = string.ends_with(trimmed_remark, "?")
  let is_yelling = has_only_uppercase(trimmed_remark)

  case is_silence, is_question, is_yelling {
    True, _, _ -> "Fine. Be that way!"
    False, True, False -> "Sure."
    False, False, True -> "Whoa, chill out!"
    False, True, True -> "Calm down, I know what I'm doing!"
    False, _, _ -> "Whatever."
  }
}

fn has_only_uppercase(remark: String) -> Bool {
  string.uppercase(remark) == remark && string.lowercase(remark) != remark
}
