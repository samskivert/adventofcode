use advent2024::{day1, day2, day3, day4};
use clap::Parser;

#[derive(Parser)]
struct Cli {
    /// The day to run.
    day: u8,

    /// Whether to use the example input.
    #[arg(short, long, default_value_t = false)]
    example: bool,
}

const DAYS: [(fn(&str) -> String, fn(&str) -> String); 4] = [
    (day1::part1, day1::part2),
    (day2::part1, day2::part2),
    (day3::part1, day3::part2),
    (day4::part1, day4::part2),
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
