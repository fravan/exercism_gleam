import gleam/list
import gleam/string

pub type Student {
  Alice
  Bob
  Charlie
  David
  Eve
  Fred
  Ginny
  Harriet
  Ileana
  Joseph
  Kincaid
  Larry
}

pub type Plant {
  Radishes
  Clover
  Violets
  Grass
}

pub fn plants(diagram: String, student: Student) -> List(Plant) {
  let assert [first_row, second_row] = string.split(diagram, on: "\n")
  let start_index = get_student_indexes(student)

  {
    string.slice(first_row, at_index: start_index, length: 2)
    <> string.slice(second_row, at_index: start_index, length: 2)
  }
  |> string.to_graphemes()
  |> list.fold(from: [], with: fn(acc, letter) { [get_plant(letter), ..acc] })
  |> list.reverse()
}

fn get_plant(letter: String) -> Plant {
  case letter {
    "V" -> Violets
    "R" -> Radishes
    "C" -> Clover
    "G" -> Grass
    _ -> panic as "unhandled letter"
  }
}

fn get_student_indexes(student: Student) -> Int {
  case student {
    Alice -> 0
    Bob -> 2
    Charlie -> 4
    David -> 6
    Eve -> 8
    Fred -> 10
    Ginny -> 12
    Harriet -> 14
    Ileana -> 16
    Joseph -> 18
    Kincaid -> 20
    Larry -> 22
  }
}
