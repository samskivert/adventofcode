use std::collections::HashMap;
use std::collections::HashSet;

#[derive(Eq, Hash, PartialEq, PartialOrd, Ord, Copy, Clone)]
struct Pos(isize, isize);

impl Pos {
    fn go(&self, d: char) -> Pos {
        match d {
            '>' => Pos(self.0 + 1, self.1),
            '<' => Pos(self.0 - 1, self.1),
            'v' => Pos(self.0, self.1 + 1),
            '^' => Pos(self.0, self.1 - 1),
            _ => Pos(0, 0),
        }
    }

    fn gps(&self) -> isize {
        100 * self.1 + self.0
    }
}

struct Warehouse {
    walls: HashSet<Pos>,
    boxes: HashMap<Pos, char>,
}

fn parse(input: &str, wide: bool) -> (Warehouse, Pos, Vec<char>) {
    let mut boxes = HashMap::new();
    let mut walls = HashSet::new();
    let mut robot: Pos = Pos(0, 0);
    let parts = input.split("\n\n").collect::<Vec<&str>>();
    for (y, line) in parts[0].lines().enumerate() {
        for (i, c) in line.chars().enumerate() {
            let pos = Pos(if wide { 2 * i as isize } else { i as isize }, y as isize);
            match c {
                'O' => {
                    if wide {
                        boxes.insert(pos, '[');
                        boxes.insert(pos.go('>'), ']');
                    } else {
                        boxes.insert(pos, 'O');
                    }
                }
                '#' => {
                    walls.insert(pos);
                    if wide {
                        walls.insert(pos.go('>'));
                    }
                }
                '@' => {
                    robot = pos;
                }
                _ => {}
            }
        }
    }
    (Warehouse { boxes, walls }, robot, parts[1].chars().filter(|&c| c != '\n').collect())
}

impl Warehouse {
    fn make_empty(&mut self, pos: Pos, direction: char) -> bool {
        if self.walls.contains(&pos) {
            return false;
        }
        let Some(&b) = self.boxes.get(&pos) else {
            return true;
        };
        let npos = pos.go(direction);
        if self.make_empty(npos, direction) {
            self.boxes.remove(&pos);
            self.boxes.insert(npos, b);
            return true;
        }
        false
    }

    fn make_empty2(&mut self, bpos: Pos, d: char, apply: bool) -> bool {
        if self.walls.contains(&bpos) {
            return false;
        }
        let Some(&b) = self.boxes.get(&bpos) else {
            return true;
        };

        let (lpos, rpos) = if b == '[' { (bpos, bpos.go('>')) } else { (bpos.go('<'), bpos) };
        let (nlpos, nrpos) = (lpos.go(d), rpos.go(d));
        if d == '>' || d == '<' {
            if !self.make_empty2(if d == '<' { nlpos } else { nrpos }, d, apply) {
                return false;
            }
        } else {
            if !self.make_empty2(nlpos, d, false) || !self.make_empty2(nrpos, d, false) {
                return false;
            } else if apply {
                self.make_empty2(nlpos, d, true);
                self.make_empty2(nrpos, d, true);
            }
        }

        if apply {
            self.boxes.remove(&lpos);
            self.boxes.remove(&rpos);
            self.boxes.insert(nlpos, '[');
            self.boxes.insert(nrpos, ']');
        }
        true
    }

    fn follow(&mut self, mut robot: Pos, moves: &[char], wide: bool) -> isize {
        for &m in moves {
            let npos = robot.go(m);
            if (wide && self.make_empty2(npos, m, true)) || (!wide && self.make_empty(npos, m)) {
                robot = npos;
            }
        }
        self.boxes.iter().filter(|(_, &b)| b != ']').map(|(p, _)| p.gps()).sum()
    }
}

pub fn part1(input: &str) -> String {
    let (mut w, robot, moves) = parse(input, false);
    w.follow(robot, &moves, false).to_string()
}

pub fn part2(input: &str) -> String {
    let (mut w, robot, moves) = parse(input, true);
    w.follow(robot, &moves, true).to_string()
}
