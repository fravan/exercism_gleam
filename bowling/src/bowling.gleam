import gleam/bool
import gleam/int
import gleam/iterator
import gleam/list
import gleam/result

pub opaque type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
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
  use <- bool.guard(when: knocked_pins < 0, return: Error(InvalidPinCount))
  use <- bool.guard(when: knocked_pins > 10, return: Error(InvalidPinCount))

  case list.length(game.frames) {
    too_many if too_many > 10 -> Error(GameComplete)
    10 -> update_last_frame(game, knocked_pins)
    _ -> update_any_frame(game, knocked_pins)
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  use <- bool.guard(
    when: list.length(game.frames) != 10,
    return: Error(GameNotComplete),
  )

  Ok(do_score(game.frames, 0))
}

fn do_score(frames: List(Frame), acc: Int) {
  case frames {
    [] -> acc
    [first, ..rest] ->
      do_score(rest, acc + int.sum(first.rolls) + int.sum(first.bonus))
  }
}

fn update_last_frame(game: Game, knocked_pins: Int) {
  case game.frames {
    [Frame([10], []), ..rest] -> update_frame(Frame([10], [knocked_pins]), rest)
    [Frame([10], [a]), ..rest] ->
      update_frame(Frame([10], [a, knocked_pins]), rest)
    [Frame([x, y], []), ..rest] if x + y == 10 ->
      update_frame(Frame([x, y], [knocked_pins]), rest)
    [Frame([10], _), _] -> Error(GameComplete)
    [Frame([x, y], _), _] if x + y == 10 -> Error(GameComplete)
    _ -> update_any_frame(game, knocked_pins)
  }
}

fn update_any_frame(game: Game, knocked_pins: Int) {
  use <- bool.guard(
    when: list.length(game.frames) > 10,
    return: Error(GameComplete),
  )

  case game.frames {
    [] -> Ok(Game(frames: [Frame([knocked_pins], [])]))
    [Frame([10], _) as strike, ..rest] ->
      update_frame(Frame([knocked_pins], []), [strike, ..rest])
    [Frame([x], _), ..rest] -> update_frame(Frame([x, knocked_pins], []), rest)
    [Frame([_, _], _) as first, ..rest] -> {
      update_frame(Frame([knocked_pins], []), [first, ..rest])
    }
    _ -> Error(InvalidPinCount)
  }
}

fn update_frame(frame: Frame, frames: List(Frame)) {
  use <- bool.guard(
    when: int.sum(frame.rolls) > 10,
    return: Error(InvalidPinCount),
  )

  Ok(Game([frame, ..update_previous_frames(frame, frames)]))
}

fn update_previous_frames(current_frame: Frame, previous_frames: List(Frame)) {
  // Check for strikes and spares in frames
  case current_frame, previous_frames {
    // Updates 2 strikes in a row
    Frame([x], _), [Frame([10], _), Frame([10], _), ..rest] -> [
      Frame([10], [x]),
      Frame([10], [10, x]),
      ..rest
    ]
    // Updates previous spare with last throw
    Frame([x], _), [Frame([a, b], _), ..rest] if a + b == 10 -> [
      Frame([a, b], [x]),
      ..rest
    ]
    // Updates previous strike with last throw (first & second it's the same case)
    Frame(rolls, _), [Frame([10], _), ..rest] -> [Frame([10], rolls), ..rest]
    _, _ -> previous_frames
  }
}
