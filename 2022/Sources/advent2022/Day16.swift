import Foundation
struct Day16 : Day {

    func parseValves (_ input :[String]) throws -> [String: Valve] {
        let pattern = #"Valve (\S+) has flow rate=(\d+); tunnels? leads? to valves? (.*)"#
        let regex = try NSRegularExpression(pattern: pattern)
        var valves = input.map({ input in
            let nsrange = NSRange(input.startIndex ..< input.endIndex, in: input)
            let matches = regex.matches(in: input, options: [], range: nsrange)
            guard let match = matches.first else { return Valve(id: "", rate: 0, outs: []) }
            func group (_ num :Int) -> String { String(input[Range(match.range(at: num), in: input)!]) }
            return Valve(id: group(1), rate: Int(group(2))!, outs: group(3).components(separatedBy: ", "))
        })
        let valveMap = Dictionary(uniqueKeysWithValues: valves.map({ ($0.id, $0) }))
        for ii in valves.indices { valves[ii].computeDists(valveMap) }
        return Dictionary(uniqueKeysWithValues: valves.map({ ($0.id, $0) }))
    }

    struct Valve {
        var id :String
        var rate :Int
        var outs :[String]
        var dists = [String: Int]()

        mutating func computeDists (_ valves :[String: Valve]) {
            func scan (_ valve :String, _ dist :Int) {
                dists[valve] = dist
                for ovalve in valves[valve]!.outs {
                    let odist = dists[ovalve] ?? valves.count
                    if odist > dist+1 { scan(ovalve, dist+1) }
                }
            }
            scan(id, 0)
        }
    }

    func solve (_ valves :[String: Valve], _ viaIds :[String], _ remain :Int) -> Int {
        var ids = viaIds

        func scan (_ id :String, _ remain :Int, _ score :Int) -> Int {
            let valve = valves[id]!
            let nremain = remain-1
            let nscore = score + valve.rate * nremain
            var best = nscore
            var ii = 0, ll = ids.count ; while (ii < ll) {
                let nid = ids[ii]
                if nid != "" {
                    let dist = valve.dists[nid]!
                    if nremain > dist {
                        ids[ii] = ""
                        best = max(best, scan(nid, nremain-dist, nscore))
                        ids[ii] = nid
                    }
                }
                ii += 1
            }
            return best
        }

        let start = valves["AA"]!
        var best = 0
        for ii in ids.indices {
            let id = ids[ii]
            ids[ii] = ""
            let dist = start.dists[id]!
            best = max(scan(id, remain-dist, 0), best)
            ids[ii] = id
        }
        return best
    }

    func part1 () throws -> String {
        let valves = try parseValves(try readInput(16))
        let ids = valves.values.filter({ $0.rate > 0 }).map({ $0.id })
        return String(solve(valves, ids, 30))
    }

    func foldPerms<A> (_ ids :[String], _ zero :A, _ op :(A, [String], [String]) -> A) -> A {
        var acc = zero
        func loop (_ remain :Int, _ pos :Int, _ first :[String], _ second :[String]) {
            if remain == 0 {
                let nsecond = pos < ids.count ? second + ids.suffix(from: pos) : second
                acc = op(acc, first, nsecond)
            } else {
                var tt = pos, ll = ids.count-remain+1 ; while (tt < ll) {
                    let nfirst = first + [ids[tt]]
                    let nsecond = tt > pos ? second + ids[pos..<tt] : second
                    loop(remain-1, tt+1, nfirst, nsecond)
                    tt += 1
                }
            }
        }
        let half = ids.count / 2
        for pp in 1 ... half { loop(pp, 0, [], []) }
        return acc
    }

    func part2 () throws -> String {
        let valves = try parseValves(try readInput(16))
        let ids = valves.values.filter({ $0.rate > 0 }).map({ $0.id })
        return String(foldPerms(ids, 0, { (acc, fst, snd) in
            max(acc, solve(valves, fst, 26) + solve(valves, snd, 26))
        }))
    }
}
