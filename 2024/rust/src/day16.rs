use std::cmp::Ordering;
use std::collections::BinaryHeap;
use std::collections::HashMap;
use std::collections::HashSet;
use std::collections::VecDeque;

static DIRS: [(isize, isize); 4] = [(1, 0), (0, 1), (-1, 0), (0, -1)];

#[derive(Eq, Hash, PartialEq, PartialOrd, Ord, Copy, Clone, Debug)]
struct Pos(isize, isize);

impl Pos {
    fn go(&self, dir: usize) -> Pos {
        let (dx, dy) = DIRS[dir];
        Pos(self.0 + dx, self.1 + dy)
    }
}

fn parse(input: &str) -> (HashSet<Pos>, Pos, Pos) {
    let mut walls = HashSet::new();
    let mut start = Pos(0, 0);
    let mut end = Pos(0, 0);
    for (y, line) in input.lines().enumerate() {
        for (x, c) in line.chars().enumerate() {
            if c == '#' {
                walls.insert(Pos(x as isize, y as isize));
            } else if c == 'S' {
                start = Pos(x as isize, y as isize);
            } else if c == 'E' {
                end = Pos(x as isize, y as isize);
            }
        }
    }
    (walls, start, end)
}

fn count_visited(crossed: &HashMap<(Pos, Pos), isize>, end: Pos, score: isize) -> usize {
    let mut seen = HashSet::new();
    let mut queue = VecDeque::new();
    queue.push_back((end, score));
    while let Some((pos, score)) = queue.pop_front() {
        if seen.insert(pos) {
            for d in 0..4 {
                let ppos = pos.go(d);
                if let Some(&pscore) = crossed.get(&(ppos, pos)) {
                    if pscore < score {
                        queue.push_back((ppos, pscore));
                    }
                }
            }
        }
    }
    seen.len()
}

#[derive(Eq, PartialEq, Copy, Clone, Debug)]
struct Path(Pos, usize, isize);
impl Ord for Path {
    fn cmp(&self, other: &Self) -> Ordering {
        other.2.cmp(&self.2)
    }
}
impl PartialOrd for Path {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn add_paths(heap: &mut BinaryHeap<Path>, path: Path) {
    heap.push(path);
    heap.push(Path(path.0, (path.1 + 1) % 4, path.2 + 1000));
    heap.push(Path(path.0, (path.1 + 3) % 4, path.2 + 1000));
}

fn solve(walls: &HashSet<Pos>, start: Pos, end: Pos) -> (isize, usize) {
    let mut crossed: HashMap<(Pos, Pos), isize> = HashMap::new();
    let mut heap = BinaryHeap::new();
    add_paths(&mut heap, Path(start, 0, 0));

    while let Some(Path(pos, dir, score)) = heap.pop() {
        if pos == end {
            return (score, count_visited(&crossed, end, score));
        }
        let npos = pos.go(dir);
        let edge = (pos, npos);
        if walls.contains(&npos) || crossed.contains_key(&edge) {
            continue;
        }
        crossed.insert(edge, score);
        add_paths(&mut heap, Path(npos, dir, score + 1));
    }
    (0, 0)
}

pub fn part1(input: &str) -> String {
    let (walls, start, end) = parse(input);
    solve(&walls, start, end).0.to_string()
}

pub fn part2(input: &str) -> String {
    let (walls, start, end) = parse(input);
    solve(&walls, start, end).1.to_string()
}
