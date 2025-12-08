object Day3 extends Day(3) {

  def maxjolt (count :Int)(bank :String) :Long = {
    val jolts = bank.map(c => (c - '0'))
    def loop (acc :Long, pos :Int, rem :Int) :Long = if (rem == 0) acc else {
      val rest = jolts.view.slice(pos, jolts.size-rem+1)
      val next = rest.max
      loop(acc*10+next, pos+rest.indexOf(next)+1, rem-1)
    }
    loop(0, 0, count)
  }

  override def answer1 (input :Seq[String]) = input.map(maxjolt(2)).sum

  override def answer2 (input :Seq[String]) = input.map(maxjolt(12)).sum
}
