import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import gleam/string

pub fn solve(puzzle: String) -> Result(Dict(String, Int), Nil) {
  let #(left_words, right_words) = split(puzzle)
  let non_zero_letters =
    list.concat([
      list.map(left_words, first_letter),
      list.map(right_words, first_letter),
    ])

  let left_letters_count =
    left_words |> list.fold(from: dict.new(), with: build_letter_count)
  let right_letters_count =
    right_words |> list.fold(from: dict.new(), with: build_letter_count)

  let letters =
    list.concat([dict.keys(left_letters_count), dict.keys(right_letters_count)])
    |> list.unique()

  list.range(0, 9)
  |> list.combinations(list.length(letters))
  |> list.flat_map(list.permutations)
  |> list.fold_until(from: option.None, with: fn(_, combination) {
    let letter_scores =
      letters
      |> list.zip(combination)
      |> dict.from_list

    use <- bool.guard(
      when: is_invalid_combination(non_zero_letters, letter_scores),
      return: list.Continue(option.None),
    )

    let left_sum = sum(left_letters_count, letter_scores)
    let right_sum = sum(right_letters_count, letter_scores)

    case left_sum == right_sum {
      True -> list.Stop(option.Some(letter_scores))
      False -> list.Continue(option.None)
    }
  })
  |> option.to_result(Nil)
}

fn is_invalid_combination(
  non_zero_letters: List(String),
  letter_scores: Dict(String, Int),
) {
  let has_zero_leading_letters =
    non_zero_letters
    |> list.any(fn(letter) {
      let assert Ok(score) = dict.get(letter_scores, letter)
      score == 0
    })

  let letter_scores = dict.values(letter_scores)
  let has_duplicated_values = letter_scores != list.unique(letter_scores)

  has_zero_leading_letters || has_duplicated_values
}

fn build_letter_count(letters_count: Dict(String, Int), word: String) {
  let word_length = string.length(word)
  word
  |> string.to_graphemes
  |> list.index_fold(from: letters_count, with: fn(letters_count, letter, idx) {
    // A word like "AND" is translated as "#(A, 100), #(N, 10), #(D, 1)"
    letters_count
    |> dict.upsert(letter, fn(current_count) {
      case current_count {
        option.None -> power_of_ten(word_length - idx - 1)
        option.Some(count) -> count + power_of_ten(word_length - idx - 1)
      }
    })
  })
}

fn split(puzzle: String) {
  let assert [left, right] = string.split(puzzle, on: " == ")
  #(string.split(left, on: " + "), string.split(right, on: " + "))
}

fn sum(letters_count: Dict(String, Int), letter_scores: Dict(String, Int)) {
  letters_count
  |> dict.fold(from: 0, with: fn(acc, letter, count) {
    let assert Ok(score) = dict.get(letter_scores, letter)
    acc + count * score
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

fn first_letter(word: String) {
  let assert Ok(letter) = string.first(word)
  letter
}
