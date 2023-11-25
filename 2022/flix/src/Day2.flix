mod Day2 {

  enum Play with Eq, Order { case Rock, case Paper, case Scissors }

  def ordinal (play :Play) :Int32 = match play {
    case Play.Rock => 1
    case Play.Paper => 2
    case Play.Scissors => 3
  }
  def stronger (play :Play) :Play = match play {
    case Play.Rock => Play.Paper
    case Play.Paper => Play.Scissors
    case Play.Scissors => Play.Rock
  }
  def weaker (play :Play) :Play = match play {
    case Play.Rock => Play.Scissors
    case Play.Paper => Play.Rock
    case Play.Scissors => Play.Paper
  }
  def beats (b :Play, a :Play) :Bool = a == stronger(b)
  def score (b :Play, a :Play) :Int32 =
    if (beats(a, b)) 6
    else if (beats(b, a)) 0
    else 3

  def playFrom (str :String) :Play = match str {
    case "A" => Play.Rock
    case "X" => Play.Rock
    case "B" => Play.Paper
    case "Y" => Play.Paper
    case "C" => Play.Scissors
    case "Z" => Play.Scissors
    case _ => bug!("Invalid Play ${str}")
  }

  enum Action { case Win, case Lose, case Draw }

  def actionFrom (str :String) :Action = match str {
    case "X" => Action.Lose
    case "Y" => Action.Draw
    case "Z" => Action.Win
    case _ => bug!("Invalid Action ${str}")
  }

  def parseLine (line :String) :(String, String) = match String.splitOn({substr = " "}, line) {
    case a :: b :: Nil => (a, b)
    case _ => bug!("Invalid line: '${line}'")
  }
  def readStrategy (input :List[String], cvt1 :String -> a, cvt2 :String -> b) :List[(a, b)] =
    input |> List.map(parseLine) |> List.map(pp -> (cvt1(fst(pp)), cvt2(snd(pp))))

  def score1 (ps :(Play, Play)) :Int32 = let (p1, p2) = ps ; score(p2, p1) + ordinal(p2)

  pub def answer1 (input :List[String]) :Int32 =
    readStrategy(input, playFrom, playFrom) |> List.map(score1) |> List.sum

  def pickAction (p1 :Play, a2 :Action) :Play = match a2 {
    case Action.Win => stronger(p1)
    case Action.Lose => weaker(p1)
    case _ => p1
  }

  def score2 (pa :(Play, Action)) :Int32 = let (p, a) = pa ; score1((p, pickAction(p, a)))

  pub def answer2 (input :List[String]) :Int32 =
    readStrategy(input, playFrom, actionFrom) |> List.map(score2) |> List.sum
}
