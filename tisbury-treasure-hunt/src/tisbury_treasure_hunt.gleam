import gleam/list
import gleam/pair

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  pair.swap(place_location)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  treasure_location == place_location_to_treasure_location(place_location)
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  treasures
  |> list.filter(fn(treasure) {
    let #(_, position) = treasure
    treasure_location_matches_place_location(place.1, position)
  })
  |> list.length
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  let #(place_name, _) = place
  let #(found_treasure_name, _) = found_treasure
  let #(desired_treasure_name, _) = desired_treasure

  case found_treasure_name, place_name {
    "Brass Spyglass", "Abandoned Lighthouse" -> True
    "Amethyst Octopus", "Stormy Breakwater" ->
      ["Crystal Crab", "Glass Starfish"] |> list.contains(desired_treasure_name)
    "Vintage Pirate Hat", "Harbor Managers Office" ->
      ["Model Ship in Large Bottle", "Antique Glass Fishnet Float"]
      |> list.contains(desired_treasure_name)
    _, _ -> False
  }
}
