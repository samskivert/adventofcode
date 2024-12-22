use std::collections::HashMap;
use std::collections::HashSet;

static DIRS: [(isize, isize); 4] = [(0, -1), (1, 0), (0, 1), (-1, 0)];

type Pos = (isize, isize);

fn parse(input: &str) -> HashMap<Pos, usize> {
    let cells: Vec<(isize, isize, char)> = input
        .lines()
        .enumerate()
        .flat_map(|(y, line)| {
            line.chars().enumerate().map(move |(x, c)| (x as isize, y as isize, c))
        })
        .collect();
    let track: HashSet<Pos> =
        cells.iter().filter(|&&(_, _, c)| c != '#').map(|&(x, y, _)| (x, y)).collect();
    let &(sx, sy, _) = cells.iter().find(|&&(_, _, c)| c == 'S').unwrap();
    let &(ex, ey, _) = cells.iter().find(|&&(_, _, c)| c == 'E').unwrap();

    let mut path = HashMap::from([((sx, sy), 0)]);
    let mut dir = DIRS.iter().position(|d| !track.contains(&(sx + d.0, sy + d.1))).unwrap();
    let mut dist = 0;
    let mut current = (sx, sy);
    while current != (ex, ey) {
        dist += 1;
        for dd in [0, 1, 3] {
            let ndir = (dir + dd) % 4;
            let npos = (current.0 + DIRS[ndir].0, current.1 + DIRS[ndir].1);
            if track.contains(&npos) {
                path.insert(npos, dist);
                current = npos;
                dir = ndir;
                break;
            }
        }
    }
    path
}

fn cheats_from(path: &HashMap<Pos, usize>, spos: Pos, cheat_len: usize) -> HashMap<Pos, usize> {
    let range = cheat_len as isize;
    let mut cheats = HashMap::new();
    for y in -range..=range {
        for x in -range..=range {
            let steps = (x.abs() + y.abs()) as usize;
            if steps > 1 && steps <= cheat_len {
                let pos = (spos.0 + x, spos.1 + y);
                if path.contains_key(&pos) {
                    cheats.insert(pos, steps);
                }
            }
        }
    }
    cheats
}

fn cheat(path: &HashMap<Pos, usize>, cheat_len: usize, min_cheat: usize) -> usize {
    let mut cheats = HashMap::new();
    for &pos in path.keys() {
        let all_cheats = cheats_from(path, pos, cheat_len);
        let dist = path[&pos];
        for (cpos, csteps) in all_cheats {
            let (pdist, cdist) = (path[&cpos], dist + csteps);
            if cdist < pdist && pdist - cdist > min_cheat {
                cheats.insert((pos, cpos), pdist - cdist);
            }
        }
    }
    cheats.len()
}

pub fn part1(input: &str) -> String {
    let path = parse(input);
    cheat(&path, 2, if path.len() < 100 { 0 } else { 99 }).to_string()
}

pub fn part2(input: &str) -> String {
    let path = parse(input);
    cheat(&path, 20, if path.len() < 100 { 49 } else { 99 }).to_string()
}
