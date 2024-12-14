use std::collections::HashSet;

fn parse(input: &str) -> Vec<(i16, i16, i16, i16)> {
    let parse_robot = |line: &str| {
        let (p, v) = line[2..].split_once(" v=").unwrap();
        let (px, py) = p.split_once(",").unwrap();
        let (vx, vy) = v.split_once(",").unwrap();
        (px.parse().unwrap(), py.parse().unwrap(), vx.parse().unwrap(), vy.parse().unwrap())
    };
    input.lines().map(parse_robot).collect()
}

fn step(robots: &mut Vec<(i16, i16, i16, i16)>, width: i16, height: i16) {
    for robot in robots {
        robot.0 = (robot.0 + robot.2 + width) % width;
        robot.1 = (robot.1 + robot.3 + height) % height;
    }
}

fn count_stacked(robots: &[(i16, i16, i16, i16)]) -> usize {
    let map: HashSet<(i16, i16)> = robots.iter().map(|r| (r.0, r.1)).collect();
    robots.iter().filter(|r| map.contains(&(r.0, r.1 - 1))).count()
}

fn print_robots(robots: &[(i16, i16, i16, i16)], width: i16, height: i16) {
    let map: HashSet<(i16, i16)> = robots.iter().map(|r| (r.0, r.1)).collect();
    for y in 0..height {
        for x in 0..width {
            print!("{}", if map.contains(&(x, y)) { '#' } else { '.' });
        }
        println!();
    }
}

pub fn part1(input: &str) -> String {
    let mut robots = parse(input);
    let (width, height) = if robots.len() < 15 { (11, 7) } else { (101, 103) };
    for _ in 0..100 {
        step(&mut robots, width, height);
    }
    let ul = robots.iter().filter(|r| r.0 < width / 2 && r.1 < height / 2).count();
    let ur = robots.iter().filter(|r| r.0 < width / 2 && r.1 > height / 2).count();
    let ll = robots.iter().filter(|r| r.0 > width / 2 && r.1 < height / 2).count();
    let lr = robots.iter().filter(|r| r.0 > width / 2 && r.1 > height / 2).count();
    (ul * ur * ll * lr).to_string()
}

pub fn part2(input: &str) -> String {
    let mut robots = parse(input);
    let (width, height) = if robots.len() < 15 { (11, 7) } else { (101, 103) };
    let mut steps = 0;
    loop {
        step(&mut robots, width, height);
        steps += 1;
        let stacked = count_stacked(&robots);
        if stacked > robots.len() / 3 {
            print_robots(&robots, width, height);
            return steps.to_string();
        }
    }
}
