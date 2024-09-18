import gleam/list
import gleam/string

const start = "On the {day} day of Christmas my true love gave to me: "

const all_the_stuff = [
  "a Partridge in a Pear Tree", "two Turtle Doves", "three French Hens",
  "four Calling Birds", "five Gold Rings", "six Geese-a-Laying",
  "seven Swans-a-Swimming", "eight Maids-a-Milking", "nine Ladies Dancing",
  "ten Lords-a-Leaping", "eleven Pipers Piping", "twelve Drummers Drumming",
]

pub fn verse(number: Int) -> String {
  string.replace(start, each: "{day}", with: get_day(number))
  <> get_all_stuff(number)
  <> "."
}

pub fn lyrics(from starting_verse: Int, to ending_verse: Int) -> String {
  list.range(from: starting_verse, to: ending_verse)
  |> list.map(verse)
  |> string.join("\n")
}

fn get_all_stuff(number: Int) {
  all_the_stuff
  |> list.take(number)
  |> fn(the_good_stuff) {
    case the_good_stuff {
      [] | [_] -> the_good_stuff
      [first, ..rest] -> ["and " <> first, ..rest]
    }
  }
  |> list.reverse()
  |> string.join(", ")
}

fn get_day(number: Int) {
  case number {
    1 -> "first"
    2 -> "second"
    3 -> "third"
    4 -> "fourth"
    5 -> "fifth"
    6 -> "sixth"
    7 -> "seventh"
    8 -> "eighth"
    9 -> "ninth"
    10 -> "tenth"
    11 -> "eleventh"
    12 -> "twelfth"
    _ -> "other"
  }
}
