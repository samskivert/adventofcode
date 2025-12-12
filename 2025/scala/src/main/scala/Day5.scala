object Day5 extends Day(5) {

  case class Range (low :Long, high :Long) {
    def fresh (id :Long) = id >= low && id <= high
    def overlaps (range :Range) = fresh(range.low) || fresh(range.high)
    def merge (range :Range) = Range(Math.min(low, range.low), Math.max(high, range.high))
    def size = high-low+1
  }

  def parse (input :Seq[String]) :(Seq[Range], Seq[Long]) = {
    def parseRange (line :String) = {
      val Array(low, high) = line.split("-")
      Range(low.toLong, high.toLong)
    }
    val (ranges, ids) = input.span(_ != "")
    (ranges.map(parseRange), ids.drop(1).map(_.toLong))
  }

  override def answer1 (input :Seq[String]) = {
    val (ranges, ids) = parse(input)
    ids.count(id => ranges.exists(_.fresh(id)))
  }

  override def answer2 (input :Seq[String]) = {
    // sort the ranges and merge overlapping ranges together
    val merged = parse(input)._1.sortBy(_.low).foldLeft(List[Range]()) {
      case (Nil, next) => next :: Nil
      case (last :: rest, next) =>
        if (last.overlaps(next)) last.merge(next) :: rest
        else next :: last :: rest
    }
    merged.map(_.size).sum
  }
}
