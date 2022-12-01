import Foundation

func readInput (_ day :Int) throws -> [String] {
    let data = try String(contentsOfFile: "Input/day\(day).txt", encoding: .utf8)
    return data.components(separatedBy: .newlines)
}