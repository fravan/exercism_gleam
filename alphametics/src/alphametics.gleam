import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn solve(puzzle: String) -> Result(Dict(String, Int), Nil) {
  let #(letters_count, non_zero_letters) = parse_puzzle(puzzle)
  do_solve(
    letters_count,
    non_zero_letters,
    dict.keys(letters_count),
    list.range(0, 9),
    dict.new(),
  )
}

fn do_solve(
  letters_count: Dict(String, Int),
  non_zero_letters: List(String),
  letters: List(String),
  remaining_digits: List(Int),
  letter_score: Dict(String, Int),
) {
  case letters {
    [] -> try_sum(letters_count, letter_score)
    [letter, ..rest_letters] -> {
      remaining_digits
      |> list.filter(fn(d) {
        d != 0 || !list.contains(non_zero_letters, letter)
      })
      |> list.fold_until(from: option.None, with: fn(_, digit) {
        let other_digits = list.filter(remaining_digits, fn(d) { d != digit })
        case
          do_solve(
            letters_count,
            non_zero_letters,
            rest_letters,
            other_digits,
            dict.insert(letter_score, letter, digit),
          )
        {
          Ok(res) -> list.Stop(option.Some(res))
          _ -> list.Continue(option.None)
        }
      })
      |> option.to_result(Nil)
    }
  }
}

fn try_sum(letters_count: Dict(String, Int), letter_scores: Dict(String, Int)) {
  case sum(letters_count, letter_scores) {
    0 -> Ok(letter_scores)
    _ -> Error(Nil)
  }
}

fn sum(letters_count: Dict(String, Int), letter_scores: Dict(String, Int)) {
  letters_count
  |> dict.combine(letter_scores, fn(count, score) { count * score })
  |> dict.fold(from: 0, with: fn(acc, _, curr) { acc + curr })
}

fn parse_puzzle(puzzle: String) {
  let assert [left, right_word] = string.split(puzzle, on: " == ")
  let left_words = string.split(left, on: " + ")

  let non_zero_letters =
    [right_word, ..left_words]
    |> list.map(string.first)
    |> result.values

  let letters_count =
    [right_word, ..left_words]
    |> list.index_map(fn(word, index) {
      word
      |> string.to_graphemes
      |> list.zip(
        list.range(string.length(word) - 1, 0)
        |> list.map(power_of_ten)
        |> map_if(index == 0, int.negate),
      )
    })
    |> list.flatten
    |> list.fold(from: dict.new(), with: fn(acc, tuple) {
      let #(key, amount) = tuple
      acc |> dict.upsert(key, fn(val) { option.unwrap(val, 0) + amount })
    })

  #(letters_count, non_zero_letters)
}

fn map_if(list: List(a), condition: Bool, transformer: fn(a) -> a) {
  list
  |> list.map(fn(a) {
    case condition {
      True -> transformer(a)
      False -> a
    }
  })
}

fn power_of_ten(n: Int) {
  do_power_of_ten(n, 1)
}

fn do_power_of_ten(n: Int, acc: Int) {
  case n {
    0 -> acc
    _ -> do_power_of_ten(n - 1, acc * 10)
  }
}
