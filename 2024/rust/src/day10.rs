static DELTAS: [(isize, isize); 4] = [(0, -1), (0, 1), (-1, 0), (1, 0)];

struct Map {
    width: isize,
    height: isize,
    terrain: Vec<Vec<u32>>,
}

impl Map {
    fn parse(input: &str) -> Self {
        let terrain: Vec<Vec<u32>> = input
            .lines()
            .map(|line| line.chars().map(|c| c.to_digit(10).unwrap()).collect())
            .collect();
        Self { width: terrain[0].len() as isize, height: terrain.len() as isize, terrain }
    }

    fn inside(&self, pos: &(isize, isize)) -> bool {
        pos.0 >= 0 && pos.0 < self.width && pos.1 >= 0 && pos.1 < self.height
    }

    fn score(
        &self,
        reached: &mut Vec<(isize, isize)>,
        all: bool,
        pos @ (x, y): (isize, isize),
        eh: u32,
    ) -> u32 {
        let h = self.terrain[y as usize][x as usize];
        if eh != h {
            return 0;
        } else if h < 9 {
            let ns = DELTAS.iter().map(|(dx, dy)| (x + dx, y + dy)).filter(|pos| self.inside(pos));
            ns.map(|pos| self.score(reached, all, pos, eh + 1)).sum()
        } else if !all && reached.contains(&pos) {
            return 0;
        } else {
            reached.push(pos);
            return 1;
        }
    }

    fn chart(&self, all: bool) -> u32 {
        (0..self.height)
            .flat_map(|y| (0..self.width).map(move |x| (x, y)))
            .map(|start| self.score(&mut vec![], all, start, 0))
            .sum()
    }
}

pub fn part1(input: &str) -> String {
    Map::parse(input).chart(false).to_string()
}

pub fn part2(input: &str) -> String {
    Map::parse(input).chart(true).to_string()
}
