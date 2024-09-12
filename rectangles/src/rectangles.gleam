import gleam/dict.{type Dict}
import gleam/list
import gleam/string

type Coordinates {
  Coordinates(line: Int, col: Int)
}

type Element {
  Corner
  HEdge
  VEdge
}

type Grid =
  Dict(Coordinates, Element)

pub fn rectangles(input: String) -> Int {
  input
  |> parse
  |> count_rectangles
}

fn parse(input: String) -> Grid {
  input
  |> string.split(on: "\n")
  |> list.index_fold(from: dict.new(), with: fn(grid, input, line) {
    input
    |> string.to_graphemes
    |> list.index_fold(from: grid, with: fn(grid, character, col) {
      case character {
        "+" -> grid |> add_corner(Coordinates(line:, col:))
        "-" -> grid |> add_h_edge(Coordinates(line:, col:))
        "|" -> grid |> add_v_edge(Coordinates(line:, col:))
        _ -> grid
      }
    })
  })
}

fn count_rectangles(grid: Grid) -> Int {
  grid
  |> dict.fold(from: 0, with: fn(acc, coordinates, element) {
    case element {
      Corner -> acc + search_rectangles(grid, coordinates, coordinates, Top)
      _ -> acc
    }
  })
}

/// We only start counting on corners
/// For each one of them, will try to "complete" the rectangle
/// starting on the top edge, reading to the right of the corner
/// Represents the Edge being scanned
type Scan {
  Top
  Right
  Bottom
  Left
}

fn search_rectangles(
  grid: Grid,
  origin: Coordinates,
  current_coordinates: Coordinates,
  current_scan: Scan,
) -> Int {
  let Coordinates(line:, col:) = current_coordinates

  let target_point = case current_scan {
    Top -> Coordinates(line:, col: col + 1)
    Bottom -> Coordinates(line:, col: col - 1)
    Right -> Coordinates(col:, line: line + 1)
    Left -> Coordinates(col:, line: line - 1)
  }
  let target_edge = case current_scan {
    Top | Bottom -> HEdge
    Right | Left -> VEdge
  }

  case grid |> dict.get(target_point), origin == target_point {
    Ok(edge), _ if edge == target_edge ->
      search_rectangles(grid, origin, target_point, current_scan)
    Ok(Corner), False -> {
      let current_rectangle = case current_scan {
        Top -> search_rectangles(grid, origin, target_point, Right)
        Right -> search_rectangles(grid, origin, target_point, Bottom)
        Bottom -> search_rectangles(grid, origin, target_point, Left)
        Left -> 0
      }
      current_rectangle
      + search_rectangles(grid, origin, target_point, current_scan)
    }
    Ok(Corner), True -> 1
    _, _ -> 0
  }
}

/// If we find a Corner, which is not the origin, we want to :
/// "Turn 90degrees" to continue to complete the current rectangle
/// AND also continue on the same edge in case there are other rectangles
fn add_corner(grid: Grid, position: Coordinates) -> Grid {
  add_element(grid, position, Corner)
}

fn add_h_edge(grid: Grid, position: Coordinates) -> Grid {
  add_element(grid, position, HEdge)
}

fn add_v_edge(grid: Grid, position: Coordinates) -> Grid {
  add_element(grid, position, VEdge)
}

fn add_element(grid: Grid, position: Coordinates, element: Element) -> Grid {
  grid |> dict.insert(position, element)
}
