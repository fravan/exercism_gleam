import gleam/list

type Domino =
  #(Int, Int)

pub fn can_chain(chain: List(Domino)) -> Bool {
  case chain {
    [] -> True
    [#(start, end)] -> start == end
    [domino, ..remaining] ->
      remaining |> list.any(chains_with(domino, remaining, _))
  }
}

fn chains_with(
  current_domino: Domino,
  remaining: List(Domino),
  tested_domino: Domino,
) {
  case tested_domino {
    #(left, right) | #(right, left) if right == current_domino.1 -> {
      // we can assert here because `tested_domino` comes from `remaining` List
      let assert Ok(#(_, remaining_dominos)) =
        remaining |> list.pop(fn(d) { d == tested_domino })
      can_chain([#(current_domino.0, left), ..remaining_dominos])
    }
    _ -> False
  }
}
