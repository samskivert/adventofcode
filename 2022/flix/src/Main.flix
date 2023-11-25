def main() :Unit \ IO =
  match Environment.getArgs() {
    case Nil => runDay(7)
    case dayArg :: _ => match Int32.parse(10, dayArg) {
      case Ok(day) => runDay(day)
      case Err(cause) => println("Invalid day ${dayArg}: ${cause}")
    }
  }

def runDay (day :Int32) :Unit \ IO =
  runDayWith(day, "data/example${day}.txt");
  runDayWith(day, "data/input${day}.txt")

def runDayWith (day :Int32, path :String) :Unit \ IO =
  match Files.readLines(path) {
  case Ok(input) => match day {
    case 1 => println((Day1.answer1(input), Day1.answer2(input)))
    case 2 => println((Day2.answer1(input), Day2.answer2(input)))
    case 3 => println((Day3.answer1(input), Day3.answer2(input)))
    case 4 => println((Day4.answer1(input), Day4.answer2(input)))
    case 5 => println((Day5.answer1(input), Day5.answer2(input)))
    case 6 => println((Day6.answer1(input), Day6.answer2(input)))
    case 7 => println((Day7.answer1(input), Day7.answer2(input)))
    case _ => println("${day} not implemented yet.")
  }
  case Err(cause) => println("Unable to read '${path}': ${cause}")
}

def parseInt (text :String) :Int32 = match Int32.parse(10, text) {
  case Ok(n) => n
  case Err(msg) => bug!(msg)
}

def parseInts (input :List[String]) :List[Option[Int32]] = input |> List.map(
  str -> match Int32.parse(10, str) {
    case Ok(n) => Some(n)
    case Err(_) => None
  })

def listTo2 (list :List[a]) :(a, a) with ToString[a] = match list {
  case a :: b :: Nil => (a, b)
  case _ => bug!("listTo2 ${List.length(list)} != 2 (in ${list})")
}
def listTo3 (list :List[a]) :(a, a, a) with ToString[a] = match list {
  case a :: b :: c :: Nil => (a, b, c)
  case _ => bug!("listTo3 ${List.length(list)} != 3 (in ${list})")
}

def splitPair (sep :String, text :String) :(String, String) = listTo2(String.splitOn({ substr = sep }, text))

def splitOnBlanks (lines :List[String]) :List[List[String]] = match lines {
  case Nil => Nil
  case _ => let next = lines |> List.takeWhile(l -> l != "");
            next :: splitOnBlanks(List.drop(List.length(next)+1, lines))
}

def splitOnBlanks2 (lines :List[String]) :(List[String], List[String]) = listTo2(splitOnBlanks(lines))

def head (list :List[a]) :a = match list {
  case h :: _ => h
  case _ => bug!("Can't take head of empty list")
}
def tail (list :List[a]) :List[a] = match list {
  case _ :: t => t
  case _ => bug!("Can't take tail of empty list")
}

def trace (a :a) :a \ IO with ToString[a] = println(a) ; a
