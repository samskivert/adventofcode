object Day6 extends Day(6):

  def startMarker (input :String, size :Int) :Int =
    input.indices.find(ss => input.substring(ss, ss+size).toSet.size == size) match
      case Some(start) => start + size
      case None => 0

  override def answer1 (input :Seq[String]) = startMarker(input(0), 4)
  override def answer2 (input :Seq[String]) = startMarker(input(0), 14)
