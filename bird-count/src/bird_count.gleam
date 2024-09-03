import gleam/int
import gleam/list

pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [today, ..] -> today
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [today, ..rest] -> [today + 1, ..rest]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  list.contains(days, 0)
}

pub fn total(days: List(Int)) -> Int {
  int.sum(days)
}

pub fn busy_days(days: List(Int)) -> Int {
  days
  |> list.filter(fn(day) { day > 4 })
  |> list.length()
}
