fn parse(input: &str) -> (usize, Vec<usize>) {
    fn parse_tail<T>(line: &str, f: impl Fn(&str) -> T) -> T {
        f(line.split_once(": ").unwrap().1)
    }
    let parse_int_tail = |line: &str| parse_tail(line, |s| s.parse().unwrap());
    let [a, _, _, _, p] = input.lines().collect::<Vec<_>>().try_into().unwrap();
    (parse_int_tail(a), parse_tail(p, |s| s.split(',').map(|s| s.parse().unwrap()).collect()))
}

fn combo(v: usize, a: usize, b: usize, c: usize) -> usize {
    if v < 4 {
        v
    } else if v == 4 {
        a
    } else if v == 5 {
        b
    } else if v == 6 {
        c
    } else {
        unreachable!()
    }
}

fn run(program: &[usize], a: usize) -> Vec<usize> {
    let (mut a, mut b, mut c) = (a, 0, 0);
    let mut pc = 0;
    let mut outs = Vec::new();
    while pc < program.len() {
        let (op, arg) = (program[pc], program[pc + 1]);
        pc += 2;
        match op {
            0 => a = a >> combo(arg, a, b, c),
            1 => b = b ^ arg,
            2 => b = combo(arg, a, b, c) % 8,
            3 => pc = if a == 0 { pc } else { arg },
            4 => b = b ^ c,
            5 => outs.push(combo(arg, a, b, c) % 8),
            6 => b = a >> combo(arg, a, b, c),
            7 => c = a >> combo(arg, a, b, c),
            _ => unreachable!(),
        }
    }
    outs
}

pub fn part1(input: &str) -> String {
    let (a, program) = parse(input);
    let outs = run(&program, a);
    outs.iter().map(|v| v.to_string()).collect::<Vec<_>>().join(",")
}

pub fn part2(input: &str) -> String {
    fn search(program: &[usize], digits: &mut [usize], dd: usize) -> Option<usize> {
        let pp = program.len() - dd - 1;
        for d in 0..8 {
            digits[dd] = d;
            let a = digits.iter().fold(0, |a, d| (a << 3) + d);
            let outs = run(&program, a);
            if outs.len() != program.len() || outs[pp] != program[pp] {
                continue;
            } else if pp == 0 {
                return Some(a);
            } else if let Some(a) = search(program, digits, dd + 1) {
                return Some(a);
            }
        }
        None
    }
    let (_, program) = parse(input);
    let mut digits = program.iter().map(|_| 0).collect::<Vec<_>>();
    search(&program, &mut digits, 0).unwrap().to_string()
}
