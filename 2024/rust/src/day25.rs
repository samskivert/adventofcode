fn parse(input: &str) -> (Vec<[u8; 5]>, Vec<[u8; 5]>) {
    let mut locks = Vec::new();
    let mut keys = Vec::new();
    for schematic in input.split("\n\n") {
        let mut is_lock = false;
        let mut heights = [0, 0, 0, 0, 0];
        for (row, line) in schematic.lines().enumerate() {
            if row == 0 && line.contains('#') {
                is_lock = true;
            }
            if row > 0 && row < 6 {
                for (col, _) in line.chars().enumerate().filter(|(_, c)| *c == '#') {
                    heights[col] += 1;
                }
            }
        }
        if is_lock {
            locks.push(heights);
        } else {
            keys.push(heights);
        }
    }
    (locks, keys)
}

fn fits(lock: &[u8; 5], key: &[u8; 5]) -> bool {
    (0..5).all(|i| lock[i] + key[i] <= 5)
}

pub fn part1(input: &str) -> String {
    let (locks, keys) = parse(input);
    locks.iter().map(|l| keys.iter().filter(|&k| fits(l, k)).count()).sum::<usize>().to_string()
}

pub fn part2(_input: &str) -> String {
    "🎄".to_string()
}
