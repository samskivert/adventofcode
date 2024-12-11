use advent2024::{
    day1, day10, day11, day12, day13, day14, day15, day16, day17, day18, day19, day2, day20, day21,
    day22, day23, day24, day25, day3, day4, day5, day6, day7, day8, day9,
};
use clap::Parser;

#[derive(Parser)]
struct Cli {
    /// The day to run.
    day: u8,

    /// Whether to use the example input.
    #[arg(short, long, default_value_t = false)]
    example: bool,
}

const DAYS: &[(fn(&str) -> String, fn(&str) -> String)] = &[
    (day1::part1, day1::part2),
    (day2::part1, day2::part2),
    (day3::part1, day3::part2),
    (day4::part1, day4::part2),
    (day5::part1, day5::part2),
    (day6::part1, day6::part2),
    (day7::part1, day7::part2),
    (day8::part1, day8::part2),
    (day9::part1, day9::part2),
    (day10::part1, day10::part2),
    (day11::part1, day11::part2),
    (day12::part1, day12::part2),
    (day13::part1, day13::part2),
    (day14::part1, day14::part2),
    (day15::part1, day15::part2),
    (day16::part1, day16::part2),
    (day17::part1, day17::part2),
    (day18::part1, day18::part2),
    (day19::part1, day19::part2),
    (day20::part1, day20::part2),
    (day21::part1, day21::part2),
    (day22::part1, day22::part2),
    (day23::part1, day23::part2),
    (day24::part1, day24::part2),
    (day25::part1, day25::part2),
];

fn main() {
    let args = Cli::parse();
    if (args.day as usize) > DAYS.len() {
        panic!("Day {} not implemented", args.day);
    }
    let (day_a, day_b) = DAYS[args.day as usize - 1];

    let basename = if args.example { "example" } else { "day" };
    let filename = |suffix: &str| format!("input/{}{}{}.txt", basename, args.day, suffix);

    let (answer1, answer2) = match std::fs::read_to_string(&filename("")) {
        Ok(contents) => (day_a(&contents), day_b(&contents)),
        Err(_) => match std::fs::read_to_string(&filename("a")) {
            Ok(contents_a) => match std::fs::read_to_string(&filename("b")) {
                Ok(contents_b) => (day_a(&contents_a), day_b(&contents_b)),
                Err(_) => panic!("Missing b variant {}", &filename("b")),
            },
            Err(_) => panic!("Unable to find input files for day {}", args.day),
        },
    };

    println!("Day {}, part 1: {}", args.day, answer1);
    println!("Day {}, part 2: {}", args.day, answer2);
}
