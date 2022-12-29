struct Day8 : Day {
    let sampleInput = [
        "30373",
        "25512",
        "65332",
        "33549",
        "35390"
    ]

    func parseLine (_ line :String) -> [Int] { line.map({ Int($0.asciiValue!) - Int(Character("0").asciiValue!) }) }
    func parseGrid (_ input :[String]) -> [[Int]] { input.map(parseLine) }
    func mapGrid<A> (_ grid :[[Int]], _ f :([[Int]], Int) -> A) -> [A] {
        func rays (_ row :Int, _ col :Int) -> [[Int]] {
            func slice (_ dr :Int, _ dc :Int) -> [Int] {
                var trees = [Int]()
                var r = row+dr ; var c = col+dc
                while (r >= 0 && c >= 0 && r < grid.count && c < grid[0].count) {
                    trees.append(grid[r][c])
                    r += dr
                    c += dc
                }
                return trees
            }
            return [slice(-1, 0), slice(1, 0), slice(0, -1), slice(0, 1)]
        }
        return grid.indices.flatMap { row in grid[row].indices.map { col in f(rays(row, col), grid[row][col]) }}
    }

    func part1 () throws -> String { String(mapGrid(parseGrid(try readInput(8)), {
        (rays, h) in rays.contains { $0.allSatisfy { $0 < h }}
    }).filter({ $0 }).count) }

    func part2 () throws -> String { String(mapGrid(parseGrid(try readInput(8)), {
        (rays, h) in rays.map({ 1 + ($0.firstIndex(where: { $0 >= h }) ?? $0.count-1) }).reduce(1,*)
    }).max() ?? 0) }
}
