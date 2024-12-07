use std::collections::HashSet;

static DX: [i16; 4] = [0, 1, 0, -1];
static DY: [i16; 4] = [-1, 0, 1, 0];

struct Room {
    width: i16,
    height: i16,
    start: (i16, i16),
    obstacles: HashSet<(i16, i16)>,
}

impl Room {
    fn new(input: &str) -> Self {
        let mut start = (0, 0);
        let mut obstacles = HashSet::new();
        for (y, line) in input.lines().enumerate() {
            for (x, c) in line.chars().enumerate() {
                if c == '^' {
                    start = (x as i16, y as i16);
                } else if c == '#' {
                    obstacles.insert((x as i16, y as i16));
                }
            }
        }
        Self {
            width: input.lines().next().unwrap().len() as i16,
            height: input.lines().count() as i16,
            start,
            obstacles,
        }
    }

    fn follow_path(&self, visited: &mut HashSet<(i16, i16)>, blocked: (i16, i16)) -> bool {
        let mut pos = self.start;
        let mut dir = 0;
        let mut seen = HashSet::new();
        loop {
            visited.insert(pos);
            if !seen.insert((dir, pos)) {
                return true;
            }
            let (nx, ny) = (pos.0 + DX[dir], pos.1 + DY[dir]);
            let npos = (nx, ny);
            if nx < 0 || ny < 0 || nx >= self.width || ny >= self.height {
                break;
            } else if self.obstacles.contains(&npos) || npos == blocked {
                dir = (dir + 1) % 4;
            } else {
                pos = npos;
            }
        }
        false
    }
}

pub fn part1(input: &str) -> String {
    let room = Room::new(input);
    let mut visited = HashSet::new();
    room.follow_path(&mut visited, (-1, -1));
    visited.len().to_string()
}

pub fn part2(input: &str) -> String {
    let room = Room::new(input);
    let mut visited = HashSet::new();
    room.follow_path(&mut visited, (-1, -1));
    visited.remove(&room.start);
    visited.iter().filter(|&&pos| room.follow_path(&mut HashSet::new(), pos)).count().to_string()
}
