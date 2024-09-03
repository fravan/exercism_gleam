import gleam/int
import gleam/list

pub type Category {
  Ones
  Twos
  Threes
  Fours
  Fives
  Sixes
  FullHouse
  FourOfAKind
  LittleStraight
  BigStraight
  Choice
  Yacht
}

pub fn score(category: Category, dice: List(Int)) -> Int {
  case category {
    Ones -> calculate_simple_factor(1, dice)
    Twos -> calculate_simple_factor(2, dice)
    Threes -> calculate_simple_factor(3, dice)
    Fours -> calculate_simple_factor(4, dice)
    Fives -> calculate_simple_factor(5, dice)
    Sixes -> calculate_simple_factor(6, dice)
    FullHouse -> calculate_full_house(dice)
    FourOfAKind -> calculate_four_of_a_kind(dice)
    LittleStraight -> calculate_little_straight(dice)
    BigStraight -> calculate_big_straight(dice)
    Choice -> calculate_choice(dice)
    Yacht -> calculate_yacht(dice)
  }
}

fn calculate_simple_factor(factor: Int, dice: List(Int)) -> Int {
  dice
  |> list.filter(keeping: fn(die) { die == factor })
  |> list.length
  |> int.multiply(factor)
}

fn calculate_full_house(dice: List(Int)) -> Int {
  case list.sort(dice, int.compare) {
    [a, b, c, d, e] if a == b && b == c && d == e && a != e -> int.sum(dice)
    [a, b, c, d, e] if a == b && c == d && d == e && a != e -> int.sum(dice)
    _ -> 0
  }
}

fn calculate_four_of_a_kind(dice: List(Int)) -> Int {
  case list.sort(dice, int.compare) {
    [_, a, b, c, d] if a == b && b == c && c == d -> 4 * a
    [a, b, c, d, _] if a == b && b == c && c == d -> 4 * a
    _ -> 0
  }
}

fn calculate_little_straight(dice: List(Int)) -> Int {
  case list.sort(dice, int.compare) {
    [1, 2, 3, 4, 5] -> 30
    _ -> 0
  }
}

fn calculate_big_straight(dice: List(Int)) -> Int {
  case list.sort(dice, int.compare) {
    [2, 3, 4, 5, 6] -> 30
    _ -> 0
  }
}

fn calculate_choice(dice: List(Int)) -> Int {
  int.sum(dice)
}

fn calculate_yacht(dice: List(Int)) -> Int {
  case dice {
    [a, b, c, d, e] if a == b && b == c && c == d && d == e -> 50
    _ -> 0
  }
}
