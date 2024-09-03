import gleam/list
import gleam/string

pub fn find_anagrams(word: String, candidates: List(String)) -> List(String) {
  let normalized_word = normalize(word)

  list.fold(candidates, from: [], with: fn(acc, candidate) {
    let normalized_candidate = normalize(candidate)

    case
      normalized_word.0 == normalized_candidate.0,
      normalized_word.1 == normalized_candidate.1
    {
      True, _ -> acc
      _, True -> [candidate, ..acc]
      _, False -> acc
    }
  })
  |> list.reverse()
}

fn normalize(word: String) {
  let key =
    word
    |> string.lowercase()
  let value =
    key
    |> string.to_graphemes()
    |> list.sort(string.compare)
  #(key, value)
}
