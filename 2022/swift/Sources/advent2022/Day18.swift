struct Day18 : Day {
    let sampleInput = [
        "2,2,2", "1,2,2", "3,2,2", "2,1,2", "2,3,2", "2,2,1", "2,2,3", "2,2,4", "2,2,6", "1,2,5", "3,2,5", "2,1,5", "2,3,5",
    ]

    func parseCubes (_ input :[String]) -> [(Int, Int, Int)] {
        func parse (_ line :String) -> (Int, Int, Int) {
            let parts = line.components(separatedBy: ",")
            return (Int(parts[0])!, Int(parts[1])!, Int(parts[2])!)
        }
        return input.map(parse)
    }

    struct Boulder {
        let minx, miny, minz, maxx, maxy, maxz :Int
        let xspan, yspan, zspan :Int
        var cells :[UInt8]

        init (_ cubes :[(Int, Int, Int)]) {
            let xs = cubes.lazy.map({ $0.0 }) ; maxx = xs.max()! ; minx = xs.min()!
            let ys = cubes.lazy.map({ $0.1 }) ; maxy = ys.max()! ; miny = ys.min()!
            let zs = cubes.lazy.map({ $0.2 }) ; maxz = zs.max()! ; minz = zs.min()!

            xspan = maxx-minx+1
            yspan = maxy-miny+1
            zspan = maxz-minz+1
            cells = [UInt8](repeating: 0, count: xspan*yspan*zspan)
            for (x, y, z) in cubes { cells[idx(x, y, z)] = 1 }

            for x in minx ... maxx { for y in miny ... maxy {
                fill(x, y, minz, 2)
                fill(x, y, maxz, 2)
            }}
            for x in minx ... maxx { for z in minz ... maxz {
                fill(x, miny, z, 2)
                fill(x, maxy, z, 2)
            }}
            for y in miny ... maxy { for z in minz ... maxz {
                fill(minx, y, z, 2)
                fill(maxx, y, z, 2)
            }}
        }

        private var ns = [(Int, Int, Int)](repeating: (0, 0, 0), count: 6)
        private mutating func neighbors (_ x :Int, _ y :Int, _ z :Int) -> [(x: Int, y: Int, z: Int)] {
            ns[0] = (x-1, y, z)
            ns[1] = (x+1, y, z)
            ns[2] = (x, y-1, z)
            ns[3] = (x, y+1, z)
            ns[4] = (x, y, z-1)
            ns[5] = (x, y, z+1)
            return ns
        }

        private mutating func fill (_ x :Int, _ y :Int, _ z :Int, _ v :UInt8) {
            if oob(x, y, z) { return }
            let ii = idx(x, y, z)
            if cells[ii] != 0 { return }
            cells[ii] = v
            for (nx, ny, nz) in neighbors(x, y, z) { fill(nx, ny, nz, v) }
        }

        private func idx (_ x :Int, _ y :Int, _ z :Int) -> Int { (z-minz)*xspan*yspan + (y-miny)*xspan + (x-minx) }
        private func oob (_ x :Int, _ y :Int, _ z :Int) -> Bool { x < minx || y < miny || z < minz || x > maxx || y > maxy || z > maxz }

        mutating func surface (_ x :Int, _ y :Int, _ z :Int) -> Int {
            neighbors(x, y, z).reduce(0, { (acc, c) in acc + (oob(c.x, c.y, c.z) ? 1 : cells[idx(c.x, c.y, c.z)] == 1 ? 0 : 1) })
        }

        mutating func exposed (_ x :Int, _ y :Int, _ z :Int) -> Int {
            neighbors(x, y, z).reduce(0, { (acc, c) in acc + (oob(c.x, c.y, c.z) ? 1 : cells[idx(c.x, c.y, c.z)] == 2 ? 1 : 0) })
        }
    }

    func part1 () throws -> String {
        let cubes = parseCubes(try readInput(18))
        var boulder = Boulder(cubes)
        return String(cubes.map({ (x, y, z) in boulder.surface(x, y, z) }).reduce(0, +))
    }

    func part2 () throws -> String {
        let cubes = parseCubes(try readInput(18))
        var boulder = Boulder(cubes)
        return String(cubes.map({ (x, y, z) in boulder.exposed(x, y, z) }).reduce(0, +))
     }
}
