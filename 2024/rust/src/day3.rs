use regex::Regex;

fn parse_int(s: &str) -> (u32, &str) {
    let digits = s.chars().take_while(|c| c.is_digit(10));
    let count = digits.count();
    if count == 0 {
        return (0, s);
    }
    (s[..count].parse().unwrap(), &s[count..])
}

fn parse_mul(s: &str) -> (u32, &str) {
    let (n1, rest) = parse_int(s);
    match rest.strip_prefix(',') {
        None => (0, rest),
        Some(rest) => {
            let (n2, rest) = parse_int(rest);
            match rest.strip_prefix(')') {
                None => (0, rest),
                Some(rest) => (n1 * n2, rest),
            }
        }
    }
}

pub fn part1(input: &str) -> String {
    let mut rest = input;
    let mut total = 0;
    while !rest.is_empty() {
        if let Some(idx) = rest.find("mul(") {
            let (m, nrest) = parse_mul(&rest[idx + 4..]);
            total += m;
            rest = nrest;
        } else {
            break;
        }
    }
    total.to_string()
}

pub fn part2(input: &str) -> String {
    let re = Regex::new(r"(mul|don't|do)\(").unwrap();
    let mut rest = input;
    let mut total = 0;
    let mut active = 1;
    while !rest.is_empty() {
        match re.find(rest) {
            Some(mat) => match mat.as_str() {
                "mul(" => {
                    let (m, nrest) = parse_mul(&rest[mat.start() + 4..]);
                    total += m * active;
                    rest = nrest;
                }
                "don't(" => {
                    rest = &rest[mat.start() + 6..];
                    if rest.starts_with(')') {
                        active = 0;
                    }
                }
                "do(" => {
                    rest = &rest[mat.start() + 3..];
                    if rest.starts_with(')') {
                        active = 1;
                    }
                }
                _ => {
                    println!("So impossible: {} at {}", mat.as_str(), mat.start());
                }
            },
            None => break,
        }
    }
    total.to_string()
}
