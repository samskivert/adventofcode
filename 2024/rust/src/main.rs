use advent2024::{day1, day2};
use clap::Parser;

#[derive(Parser)]
struct Cli {
    /// The day to run.
    day: u8,

    /// Whether to use the example input.
    #[arg(short, long, default_value_t = false)]
    example: bool,
}

fn main() {
    let args = Cli::parse();

    let filename = if args.example {
        format!("input/example{}.txt", args.day)
    } else {
        format!("input/day{}.txt", args.day)
    };

    let contents = std::fs::read_to_string(&filename).expect("Could not read input file");
    let (answer1, answer2) = match args.day {
        1 => (day1::part1(&contents), day1::part2(&contents)),
        2 => (day2::part1(&contents), day2::part2(&contents)),
        _ => panic!("Day {} not implemented", args.day),
    };

    println!("Day {}, part 1: {}", args.day, answer1);
    println!("Day {}, part 2: {}", args.day, answer2);
}
