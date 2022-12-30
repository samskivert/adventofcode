object Day3 extends Day(3):

  def split (sack :String) = (sack.take(sack.size/2).toSet, sack.drop(sack.size/2).toSet)
  def mispacked (left :Set[Char], right :Set[Char]) = (left & right).head
  def priority (c :Char) = if c >= 97 then c - 96 else c - 38
  def badge (sacks :Seq[Set[Char]]) = sacks.reduce(_ & _).head

  override def answer1 (input :Seq[String]) = input.map(split).map(mispacked).map(priority).sum
  override def answer2 (input :Seq[String]) =
    input.map(_.toSet).grouped(3).map(badge).map(priority).sum
