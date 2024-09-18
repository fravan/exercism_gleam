import gleam/int
import gleam/list

pub type Allergen {
  Eggs
  Peanuts
  Shellfish
  Strawberries
  Tomatoes
  Chocolate
  Pollen
  Cats
}

pub fn allergic_to(allergen: Allergen, score: Int) -> Bool {
  let allergen_score = get_allergen_score(allergen)
  int.bitwise_and(score, allergen_score) == allergen_score
}

pub fn list(score: Int) -> List(Allergen) {
  [Eggs, Peanuts, Shellfish, Strawberries, Tomatoes, Chocolate, Pollen, Cats]
  |> list.filter(allergic_to(_, score))
}

fn get_allergen_score(allergen: Allergen) -> Int {
  case allergen {
    Eggs -> 1
    Peanuts -> 2
    Shellfish -> 4
    Strawberries -> 8
    Tomatoes -> 16
    Chocolate -> 32
    Pollen -> 64
    Cats -> 128
  }
}
