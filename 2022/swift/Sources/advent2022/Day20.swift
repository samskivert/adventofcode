struct Day20 : Day {
    let sampleInput = [ "1", "2", "-3", "3", "-2", "0", "4" ]

    func mix (_ ns :[Int], _ key :Int, _ mixes :Int) -> [Int] {
        let cc = ns.count
        var nvs = ns.enumerated().map({ ($1*key, $0) })
        var mm = mixes ; while (mm > 0) {
            var nn = 0 ; while (nn < cc) {
                let ii = nvs.firstIndex(where: { $0.1 == nn })!
                let (n, oo) = nvs[ii]
                if n != 0 {
                    let nii = (ii + cc-1 + (n % (cc-1))) % (cc-1)
                    if nii < ii { nvs.replaceSubrange(nii+1...ii, with: nvs[nii..<ii]) }
                    else if nii > ii { nvs.replaceSubrange(ii..<nii, with: nvs[ii+1...nii]) }
                    nvs[nii] = (n, oo)
                }
                nn += 1
            }
            mm -= 1
        }
        return nvs.map({ $0.0 })
    }

    func decode (_ ns :[Int]) -> Int {
        let ii0 = ns.firstIndex(of: 0)!
        return ns[(ii0 + 1000) % ns.count] + ns[(ii0 + 2000) % ns.count] + ns[(ii0 + 3000) % ns.count]
    }

    func part1 () throws -> String { String(decode(mix(try readInput(20).map({ Int($0)! }), 1, 1))) }

    func part2 () throws -> String { String(decode(mix(try readInput(20).map({ Int($0)! }), 811589153, 10))) }
}
