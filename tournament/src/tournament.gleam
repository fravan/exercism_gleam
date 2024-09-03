import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/order
import gleam/string

type Stats {
  Stats(wins: Int, draws: Int, losses: Int, points: Int)
}

pub fn tally(input: String) -> String {
  let results =
    input
    |> read_table()
    |> dict.to_list()
    |> sort_results()

  "Team                           | MP |  W |  D |  L |  P"
  <> results
  |> list.map(fn(result) {
    let #(name, stats) = result
    "\n"
    <> string.pad_right(name, to: 30, with: " ")
    <> write_score(stats.wins + stats.draws + stats.losses)
    <> write_score(stats.wins)
    <> write_score(stats.draws)
    <> write_score(stats.losses)
    <> write_score(stats.points)
  })
  |> string.join("")
}

fn sort_results(results: List(#(String, Stats))) {
  results
  |> list.sort(by: fn(team_one, team_two) {
    let #(name_one, stats_one) = team_one
    let #(name_two, stats_two) = team_two

    order.break_tie(
      in: order.negate(int.compare(stats_one.points, stats_two.points)),
      with: string.compare(name_one, name_two),
    )
  })
}

type InputResult {
  Win(winner: String, looser: String)
  Draw(team_one: String, team_two: String)
}

fn read_table(input: String) -> Dict(String, Stats) {
  input
  |> string.split(on: "\n")
  |> list.fold(from: dict.new(), with: fn(table, input) {
    let result = read_input(input)
    case result {
      Ok(Win(winner, looser)) -> {
        table
        |> update_winner(winner)
        |> update_looser(looser)
      }
      Ok(Draw(team_one, team_two)) -> {
        table
        |> update_tie(team_one)
        |> update_tie(team_two)
      }
      _ -> table
    }
  })
}

fn read_input(input: String) {
  case string.split(input, on: ";") {
    [team_one, team_two, result] -> {
      case result {
        "win" -> Ok(Win(team_one, team_two))
        "loss" -> Ok(Win(team_two, team_one))
        _ -> Ok(Draw(team_one, team_two))
      }
    }
    _ -> Error(Nil)
  }
}

fn update_winner(table: Dict(String, Stats), winner: String) {
  table
  |> dict.upsert(winner, fn(stats) {
    case stats {
      Some(s) -> Stats(..s, wins: s.wins + 1, points: s.points + 3)
      None -> Stats(wins: 1, draws: 0, losses: 0, points: 3)
    }
  })
}

fn update_looser(table: Dict(String, Stats), looser: String) {
  table
  |> dict.upsert(looser, fn(stats) {
    case stats {
      Some(s) -> Stats(..s, losses: s.losses + 1)
      None -> Stats(losses: 1, draws: 0, wins: 0, points: 0)
    }
  })
}

fn update_tie(table: Dict(String, Stats), tied: String) {
  table
  |> dict.upsert(tied, fn(stats) {
    case stats {
      Some(s) -> Stats(..s, draws: s.draws + 1, points: s.points + 1)
      None -> Stats(draws: 1, losses: 0, wins: 0, points: 1)
    }
  })
}

fn write_score(score: Int) -> String {
  " |" <> string.pad_left(int.to_string(score), to: 3, with: " ")
}
