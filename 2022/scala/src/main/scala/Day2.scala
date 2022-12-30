object Day2 extends Day(2):

  enum Play:
    case Rock, Paper, Scissors

    def stronger = Play.values((ordinal + 1) % Play.values.length)
    def weaker = Play.values((ordinal + 2) % Play.values.length)
    def beats (p :Play) = stronger == p
    def score (p :Play) = if this.beats(p) then 6 else if p.beats(this) then 0 else 3

  import Play._
  object Play:
    def from (str :String) = str match
      case "A" | "X" => Rock
      case "B" | "Y" => Paper
      case "C" | "Z" => Scissors

  enum Action:
    case Win, Lose, Draw

  import Action._
  object Action:
    def from (str :String) = str match
      case "X" => Lose
      case "Y" => Draw
      case "Z" => Win

  def readStrategy[A, B] (input :Seq[String], cvt1 :String => A, cvt2 :String => B) =
    input.map(_.split(" ")).map(pp => (cvt1(pp(0)), cvt2(pp(1))))

  def score1 (p1 :Play, p2 :Play) = p1.score(p2) + p2.ordinal+1

  override def answer1 (input :Seq[String]) =
    readStrategy(input, Play.from, Play.from).map(score1).sum.toString

  def pickAction (p1 :Play, a2 :Action) = a2 match
    case Win => p1.stronger
    case Lose => p1.weaker
    case Draw => p1

  def score2 ( p1 :Play, a2 :Action) = score1(p1, pickAction(p1, a2))

  override def answer2 (input :Seq[String]) =
    readStrategy(input, Play.from, Action.from).map(score2).sum.toString
