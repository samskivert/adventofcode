fn parse(input: &str) -> (usize, usize, Vec<Vec<char>>) {
    let grid: Vec<Vec<char>> = input.lines().map(|line| line.chars().collect()).collect();
    (grid[0].len(), grid.len(), grid)
}

pub fn part1(input: &str) -> String {
    let (wid, hei, grid) = parse(input);
    let in_grid = |x, y| x >= 0 && y >= 0 && x < wid as isize && y < hei as isize;
    let check = |(x, y, c)| in_grid(x, y) && grid[y as usize][x as usize] == c;
    let coords = (0..hei).flat_map(move |y| (0..wid).map(move |x| (x, y)));
    let deltas = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)];
    coords
        .flat_map(|(x, y)| deltas.iter().map(move |&(dx, dy)| (x as isize, y as isize, dx, dy)))
        .filter(|&(x, y, dx, dy)| {
            check((x, y, 'X'))
                && check((x + 1 * dx, y + 1 * dy, 'M'))
                && check((x + 2 * dx, y + 2 * dy, 'A'))
                && check((x + 3 * dx, y + 3 * dy, 'S'))
        })
        .count()
        .to_string()
}

pub fn part2(input: &str) -> String {
    let (wid, hei, grid) = parse(input);
    let check_x_mas = |&(x, y): &(usize, usize)| {
        let ul = grid[y - 1][x - 1];
        let ur = grid[y - 1][x + 1];
        let ll = grid[y + 1][x - 1];
        let lr = grid[y + 1][x + 1];
        grid[y][x] == 'A'
            && ((ul == 'M' && lr == 'S') || (ul == 'S' && lr == 'M'))
            && ((ur == 'M' && ll == 'S') || (ur == 'S' && ll == 'M'))
    };
    let coords = (1..hei - 1).flat_map(move |y| (1..wid - 1).map(move |x| (x, y)));
    coords.filter(check_x_mas).count().to_string()
}
