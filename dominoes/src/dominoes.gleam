import gleam/list
import gleam/pair
import gleam/queue.{type Queue}
import gleam/result

pub fn can_chain(chain: List(#(Int, Int))) -> Bool {
  stuff(chain)
}

type Domino =
  #(Int, Int)

fn stuff(chain: List(Domino)) {
  case chain {
    [] -> True
    [first, ..rest] -> {
      let final_queue = stuff_on_queue(queue.from_list([first]), first, rest)
      case final_queue {
        Error(_) -> False
        Ok(final_queue) -> {
          let first = queue.pop_front(final_queue)
          let last = queue.pop_back(final_queue)

          case first, last {
            Ok(#(first, _)), Ok(#(last, _)) ->
              pair.first(first) == pair.second(last)
            _, _ -> False
          }
        }
      }
    }
  }
}

fn stuff_on_queue(
  queue: Queue(Domino),
  current_domino: Domino,
  dominos: List(Domino),
) {
  case get_matching_domino(current_domino, dominos, []) {
    // If we don't find a matching domino because there's none left
    // Then we have finished the chain so this is fine
    Error(remaining) ->
      case remaining {
        [] -> Ok(queue)
        _ -> Error(Nil)
      }
    Ok(#(match, remaining_dominos)) -> {
      stuff_on_queue(queue.push_back(queue, match), match, remaining_dominos)
    }
  }
}

fn get_matching_domino(
  current_domino: Domino,
  dominos: List(Domino),
  remaining_dominos: List(Domino),
) {
  case dominos {
    [] -> Error(list.concat([dominos, remaining_dominos]))
    [first, ..rest] -> {
      case first == current_domino || pair.swap(first) == current_domino {
        True -> Ok(#(current_domino, list.concat([remaining_dominos, rest])))
        False ->
          get_matching_domino(current_domino, rest, [first, ..remaining_dominos])
      }
    }
  }
}
