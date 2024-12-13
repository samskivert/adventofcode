use std::collections::HashSet;
use std::collections::VecDeque;

// 0: left, 1: up, 2: right, 3: down
const DX: [isize; 4] = [-1, 0, 1, 0];
const DY: [isize; 4] = [0, -1, 0, 1];

fn neighbors((x, y): (isize, isize)) -> impl Iterator<Item = (isize, isize)> {
    (0..4).map(move |d| (x + DX[d], y + DY[d]))
}

struct Garden {
    width: isize,
    height: isize,
    garden: Vec<Vec<char>>,
}

impl Garden {
    fn parse(input: &str) -> Self {
        let garden = input.lines().map(|line| line.chars().collect::<Vec<_>>()).collect::<Vec<_>>();
        Self { width: garden[0].len() as isize, height: garden.len() as isize, garden }
    }

    fn plant(&self, (x, y): (isize, isize)) -> char {
        if y < 0 || y >= self.height || x < 0 || x >= self.width {
            ' '
        } else {
            self.garden[y as usize][x as usize]
        }
    }

    fn region(&self, coord: (isize, isize)) -> HashSet<(isize, isize)> {
        let plant = self.plant(coord);
        let mut queue = VecDeque::new();
        queue.push_back(coord);
        let mut region = HashSet::new();
        while let Some(coord) = queue.pop_front() {
            if self.plant(coord) == plant && region.insert(coord) {
                neighbors(coord).for_each(|(dx, dy)| queue.push_back((dx, dy)));
            }
        }
        region
    }

    fn regions(&self) -> Vec<HashSet<(isize, isize)>> {
        let mut regions = Vec::new();
        let mut coords = (0..self.height)
            .flat_map(|y| (0..self.width).map(move |x| (x as isize, y as isize)))
            .collect::<HashSet<_>>();
        while !coords.is_empty() {
            let coord = coords.iter().next().unwrap();
            let region = self.region(*coord);
            coords.retain(|c| !region.contains(c));
            regions.push(region);
        }
        regions
    }

    fn fences(&self, coord: (isize, isize)) -> usize {
        let plant = self.plant(coord);
        neighbors(coord).filter(|&(nx, ny)| self.plant((nx, ny)) != plant).count()
    }

    fn fence_cost(&self, region: &HashSet<(isize, isize)>) -> usize {
        region.iter().map(|&coord| self.fences(coord) * region.len()).sum()
    }

    fn sides(&self, region: &HashSet<(isize, isize)>) -> usize {
        let mut fences = HashSet::new();
        for &(x, y) in region.iter() {
            for dir in 0..4 {
                let (nx, ny) = (x + DX[dir], y + DY[dir]);
                if self.plant((nx, ny)) != self.plant((x, y)) {
                    let fence = if dir % 2 == 0 { (dir, x, y) } else { (dir, y, x) };
                    fences.insert(fence);
                }
            }
        }
        let mut sides = 0;
        while !fences.is_empty() {
            let &(sdir, smaj, _) = fences.iter().next().unwrap();
            let fence_line = fences
                .iter()
                .copied()
                .filter(|&(dir, maj, _)| dir == sdir && maj == smaj)
                .collect::<Vec<_>>();
            fences.retain(|f| !fence_line.contains(f));
            let mut mins = fence_line.iter().map(|(_, _, min)| *min).collect::<Vec<_>>();
            mins.sort();
            sides += mins.windows(2).filter(|w| w[1] - w[0] > 1).count() + 1;
        }
        sides
    }
}

pub fn part1(input: &str) -> String {
    let garden = Garden::parse(input);
    garden.regions().iter().map(|r| garden.fence_cost(r)).sum::<usize>().to_string()
}

pub fn part2(input: &str) -> String {
    let garden = Garden::parse(input);
    garden.regions().iter().map(|r| garden.sides(r) * r.len()).sum::<usize>().to_string()
}
