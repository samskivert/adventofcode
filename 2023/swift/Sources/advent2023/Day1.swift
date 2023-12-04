import Foundation
import Algorithms

struct Day1 : Day {

  func sumCombined (_ digits :[(Int, Int)]) -> Int {
    digits.reduce(0, { (s, d) in s + d.0*10 + d.1 })
  }

  func part1 (_ input :[String]) throws -> String {
    let digitSet = CharacterSet.decimalDigits
    let digits = input.map { line in
      (Int(line.unicodeScalars.first(where: { digitSet.contains($0) })!.value - 48),
       Int(line.unicodeScalars.last(where: { digitSet.contains($0) })!.value - 48))
    }
    return String(sumCombined(digits))
  }

  let digitWords = [
    "1": 1, "one": 1,
    "2": 2, "two": 2,
    "3": 3, "three": 3,
    "4": 4, "four": 4,
    "5": 5, "five": 5,
    "6": 6, "six": 6,
    "7": 7, "seven": 7,
    "8": 8, "eight": 8,
    "9": 9, "nine": 9,
  ]

  func findDigit(_ indices :any Collection<String.Index>, _ line :String) -> Int {
    indices.firstNonNil({ start in
      for (digit, value) in digitWords {
        if let end = line.index(start, offsetBy: digit.count, limitedBy: line.endIndex) {
          if line[start ..< end] == digit { return value }
        }
      }
      return nil
    }) ?? 0
  }

  func part2 (_ input :[String]) throws -> String {
    String(sumCombined(input.map { line in
      (findDigit(line.indices, line), findDigit(line.indices.reversed(), line))
    }))
  }
}
