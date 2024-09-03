import gleam/list
import gleam/string

pub type Robot {
  Robot(direction: Direction, position: Position)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Position {
  Position(x: Int, y: Int)
}

pub fn create(direction: Direction, position: Position) -> Robot {
  Robot(direction:, position:)
}

pub fn move(
  direction: Direction,
  position: Position,
  instructions: String,
) -> Robot {
  instructions
  |> string.to_graphemes()
  |> list.fold(from: create(direction, position), with: fn(robot, instruction) {
    case instruction {
      "R" -> Robot(..robot, direction: get_right_direction(robot.direction))
      "L" -> Robot(..robot, direction: get_left_direction(robot.direction))
      "A" -> Robot(..robot, position: advance(robot))
      _ -> robot
    }
  })
}

fn advance(robot: Robot) {
  case robot.direction {
    East -> Position(..robot.position, x: robot.position.x + 1)
    West -> Position(..robot.position, x: robot.position.x - 1)
    North -> Position(..robot.position, y: robot.position.y + 1)
    South -> Position(..robot.position, y: robot.position.y - 1)
  }
}

fn get_right_direction(direction: Direction) {
  case direction {
    North -> East
    East -> South
    South -> West
    West -> North
  }
}

fn get_left_direction(direction: Direction) {
  case direction {
    North -> West
    East -> North
    South -> East
    West -> South
  }
}
