import gleam/bool
import gleam/list
import gleam/pair

pub opaque type Frame {
  Frame(rolls: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  use <- bool.guard(
    when: !is_valid_pin_count(game, knocked_pins),
    return: Error(InvalidPinCount),
  )
  use <- bool.guard(when: is_game_completed(game), return: Error(GameComplete))

  update_game(game, knocked_pins)
}

fn is_valid_pin_count(game: Game, knocked_pins: Int) -> Bool {
  use <- bool.guard(when: knocked_pins < 0, return: False)
  use <- bool.guard(when: knocked_pins > 10, return: False)
  let last_frame = list.length(game.frames) == 10

  case last_frame, game.frames {
    True, [Frame([10, a]), ..] | _, [Frame([a]), ..] ->
      a == 10 || a + knocked_pins <= 10
    _, _ -> True
  }
}

fn is_game_completed(game: Game) -> Bool {
  let frame_count = list.length(game.frames)
  use <- bool.guard(when: frame_count < 10, return: False)

  case game.frames {
    [Frame([10, ..rest]), ..] -> list.length(rest) == 2
    [Frame([a, b, _]), ..] -> a + b == 10
    [Frame([a, b]), ..] -> a + b < 10
    _ -> False
  }
}

fn update_game(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  let start_new_frame = fn(throw: Int) {
    Ok(Game([Frame([throw]), ..game.frames]))
  }
  let update_frame = fn(throw: Int) {
    let assert [frame, ..rest] = game.frames
    Ok(Game([Frame(list.append(frame.rolls, [throw])), ..rest]))
  }
  let last_frame = list.length(game.frames) == 10

  case last_frame, game.frames, knocked_pins {
    False, [], x -> start_new_frame(x)
    False, [Frame([10]), ..], x -> start_new_frame(x)
    False, [Frame([_, _]), ..], x -> start_new_frame(x)
    _, _, x -> update_frame(x)
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  use <- bool.guard(
    when: !is_game_completed(game),
    return: Error(GameNotComplete),
  )
  Ok(compute_score(game))
}

fn compute_score(game: Game) -> Int {
  // We score bonuses by keeping a tab on strikes and spares.
  // The list of frames must be in the order of the game.
  // Every time we have a strike or spare, we push a multiplier representing the number of next throws to count
  // Next 2 throws for a strike, next throw for a spare.
  // We keep an array of those, because with multiple strikes we can have a throw scored more than twice.
  game.frames
  |> list.reverse()
  |> list.fold(from: #([], 0), with: fn(tuple, frame) {
    let #(multipliers, acc) =
      frame.rolls
      |> list.fold(from: tuple, with: fn(tuple, roll) {
        let #(multipliers, acc) = tuple
        let multiplier = list.length(multipliers) + 1
        let updated_multipliers =
          multipliers
          |> list.map(fn(mul) { mul - 1 })
          |> list.filter(fn(mul) { mul > 0 })

        #(updated_multipliers, acc + roll * multiplier)
      })

    case frame.rolls {
      [10] -> #([2, ..multipliers], acc)
      [a, b] if a + b == 10 -> #([1, ..multipliers], acc)
      _ -> #(multipliers, acc)
    }
  })
  |> pair.second
}
