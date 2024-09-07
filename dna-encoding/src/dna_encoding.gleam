import gleam/list

pub type Nucleotide {
  Adenine
  Cytosine
  Guanine
  Thymine
}

pub fn encode_nucleotide(nucleotide: Nucleotide) -> Int {
  case nucleotide {
    Adenine -> 0b00
    Cytosine -> 0b01
    Guanine -> 0b10
    Thymine -> 0b11
  }
}

pub fn decode_nucleotide(nucleotide: Int) -> Result(Nucleotide, Nil) {
  case nucleotide {
    0b00 -> Ok(Adenine)
    0b01 -> Ok(Cytosine)
    0b10 -> Ok(Guanine)
    0b11 -> Ok(Thymine)
    _ -> Error(Nil)
  }
}

pub fn encode(dna: List(Nucleotide)) -> BitArray {
  do_encode(dna, <<>>)
}

fn do_encode(dna: List(Nucleotide), acc: BitArray) {
  case dna {
    [] -> acc
    [first, ..rest] -> do_encode(rest, <<acc:bits, encode_nucleotide(first):2>>)
  }
}

pub fn decode(dna: BitArray) -> Result(List(Nucleotide), Nil) {
  do_decode(dna, [])
}

fn do_decode(dna: BitArray, acc: List(Nucleotide)) {
  case dna {
    <<>> -> Ok(list.reverse(acc))
    <<nucleotide:2, rest:bits>> ->
      case decode_nucleotide(nucleotide) {
        Ok(n) -> do_decode(rest, [n, ..acc])
        Error(_) -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}
