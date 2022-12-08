import Algorithms

struct Day7 : Day {
    let sampleInput = [
        "$ cd /",
        "$ ls",
        "dir a",
        "14848514 b.txt",
        "8504156 c.dat",
        "dir d",
        "$ cd a",
        "$ ls",
        "dir e",
        "29116 f",
        "2557 g",
        "62596 h.lst",
        "$ cd e",
        "$ ls",
        "584 i",
        "$ cd ..",
        "$ cd ..",
        "$ cd d",
        "$ ls",
        "4060174 j",
        "8033020 d.log",
        "5626152 d.ext",
        "7214296 k",
    ]

    class Directory {
        var files = [String: Int]()
        var dirs  = [String: Directory]()
        var size :Int { return files.values.reduce(0, +) + dirs.values.map({ $0.size }).reduce(0, +) }
        func reduceDirs<Z> (_ z :Z, _ op :(Z, Directory) -> Z) -> Z {
            var nz = op(z, self)
            for dir in dirs.values { nz = dir.reduceDirs(nz, op) }
            return nz
        }
    }

    func parseInput (_ filesys :inout Directory, _ input :[String]) {
        var stack = [Directory]()
        var cwd = filesys
        for ii in input.indices {
            let cmd = input[ii]
            if (cmd.starts(with: "$ cd ")) {
                let name = String(cmd.dropFirst("$ cd ".count))
                switch name {
                case "..":
                    cwd = stack.removeLast()
                case "/":
                    cwd = stack.first ?? filesys
                    stack = [Directory]()
                default:
                    let dir = cwd.dirs[name]!
                    stack.append(cwd)
                    cwd = dir
                }
            } else if (cmd.starts(with: "$ ls")) {
            } else if (cmd.starts(with: "dir ")) {
                let name = String(cmd.dropFirst("dir ".count))
                if cwd.dirs[name] == nil { cwd.dirs[name] = Directory() }
            } else {
                let parts = cmd.split(separator: " ")
                cwd.files[String(parts[1])] = Int(parts[0])!
            }
        }
    }

    func part1 () throws -> String { 
        var root = Directory()
        parseInput(&root, try readInput(7))
        return String(root.reduceDirs(0, { (tot, dir) in
            let size = dir.size
            if (size < 100000) { return tot + size}
            else { return tot }
        }))
    }
    
    func part2 () throws -> String {
        var root = Directory()
        parseInput(&root, try readInput(7))
        let minNeeded = 30000000 - (70000000 - root.size)
        return String(root.reduceDirs(30000000, { (smallest, dir) in
            let size = dir.size
            if (size >= minNeeded && size < smallest) { return size }
            else { return smallest }
        }))
    }
}
