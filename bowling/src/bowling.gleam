import gleam/bool
import gleam/list
import gleam/option.{type Option, None, Some}

pub opaque type Frame {
  OpenFrame(first_roll: Int, second_roll: Option(Int))
  Strike(first_bonus: Option(Int), second_bonus: Option(Int))
  Spare(bonus: Option(Int))
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
    when: is_invalid_pin_count(game, knocked_pins),
    return: Error(InvalidPinCount),
  )
  use <- bool.guard(when: is_game_completed(game), return: Error(GameComplete))

  update_game(game, knocked_pins)
}

fn is_invalid_pin_count(game: Game, knocked_pins: Int) -> Bool {
  use <- bool.guard(when: knocked_pins < 0, return: True)
  use <- bool.guard(when: knocked_pins > 10, return: True)

  case game.frames {
    [OpenFrame(a, None), ..] -> a + knocked_pins > 10
    _ -> False
  }
}

fn is_game_completed(game: Game) -> Bool {
  case game.frames {
    [OpenFrame(_, None), ..] -> False
    [Strike(_, None), ..] -> False
    [Spare(None), ..] -> False
    _ -> list.length(game.frames) == 10
  }
}

fn update_game(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  let last_frame = list.length(game.frames) == 10
  case last_frame, game.frames, knocked_pins {
    _, [OpenFrame(a, None), ..rest], b if a + b == 10 ->
      update_spares_and_strikes(Spare(None), rest)
    _, [OpenFrame(a, None), ..rest], b ->
      update_spares_and_strikes(OpenFrame(a, Some(b)), rest)
    True, [Spare(None), ..rest], a ->
      update_spares_and_strikes(Spare(Some(a)), rest)
    True, [Strike(None, None), ..rest], a ->
      update_spares_and_strikes(Strike(Some(a), None), rest)
    True, [Strike(Some(a), None), ..rest], b if a == 10 ->
      update_spares_and_strikes(Strike(Some(a), Some(b)), rest)
    True, [Strike(Some(a), None), ..], b if a + b > 10 -> Error(InvalidPinCount)
    True, [Strike(Some(a), None), ..rest], b ->
      update_spares_and_strikes(Strike(Some(a), Some(b)), rest)
    False, frames, 10 -> update_spares_and_strikes(Strike(None, None), frames)
    False, frames, x -> update_spares_and_strikes(OpenFrame(x, None), frames)
    _, _, _ -> Error(GameComplete)
  }
}

fn update_spares_and_strikes(current_frame: Frame, frames: List(Frame)) {
  case current_frame, frames {
    OpenFrame(a, _), [Spare(None), ..rest] ->
      Ok(Game([current_frame, Spare(Some(a)), ..rest]))
    Strike(None, None), [Spare(None), ..rest] ->
      Ok(Game([current_frame, Spare(Some(10)), ..rest]))
    OpenFrame(a, b), [Strike(_, _), Strike(x, None), ..rest] ->
      Ok(Game([current_frame, Strike(Some(a), b), Strike(x, Some(a)), ..rest]))
    OpenFrame(a, b), [Strike(_, _), ..rest] ->
      Ok(Game([current_frame, Strike(Some(a), b), ..rest]))
    Spare(_), [Strike(_, _), ..rest] ->
      Ok(Game([current_frame, Strike(Some(10), Some(0)), ..rest]))
    Strike(a, _), [Strike(_, _), Strike(_, _), ..rest] ->
      Ok(
        Game([
          current_frame,
          Strike(Some(10), a),
          Strike(Some(10), Some(10)),
          ..rest
        ]),
      )
    Strike(a, _), [Strike(_, _), ..rest] ->
      Ok(Game([current_frame, Strike(Some(10), a), ..rest]))
    _, _ -> Ok(Game([current_frame, ..frames]))
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  use <- bool.guard(
    when: !is_game_completed(game),
    return: Error(GameNotComplete),
  )

  Ok(do_score(game.frames, 0))
}

fn do_score(frames: List(Frame), acc: Int) {
  case frames {
    [OpenFrame(a, Some(b)), ..rest] -> do_score(rest, acc + a + b)
    [Spare(Some(a)), ..rest] -> do_score(rest, acc + 10 + a)
    [Strike(Some(a), Some(b)), ..rest] -> do_score(rest, acc + 10 + a + b)
    _ -> acc
  }
}
