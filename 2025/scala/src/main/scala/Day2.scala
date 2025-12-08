object Day2 extends Day(2) {

  def readRanges (input :String) :Seq[(Long,Long)] = input.split(",").map { (range) =>
    val Array(low, high) = range.split("-")
    (low.toLong, high.toLong)
  }

  def invalid1 (n :Long) = {
    val nstr = n.toString ; val nlen = nstr.length
    nlen % 2 == 0 && (nstr.take(nlen/2) == nstr.drop(nlen/2))
  }

  def invalid2 (n :Long) = {
    def digits (n :Long, ds :Int = 0) :Int = if (n > 0) digits(n/10, ds+1) else ds
    val ds = digits(n)
    (1 to ds/2).filter(len => ds % len == 0).exists(len => {
      val mod = Math.pow(10, len).toLong
      val pre = n % mod
      def loop (rem :Long) :Boolean = if (rem == 0) true else (rem % mod == pre) && loop(rem / mod)
      loop(n / mod)
    })
  }

  override def answer1 (input :Seq[String]) = {
    (for (range <- readRanges(input(0)) ; n <- range(0) to range(1) ; if invalid1(n)) yield n).sum
  }

  override def answer2 (input :Seq[String]) = {
    (for (range <- readRanges(input(0)) ; n <- range(0) to range(1) ; if invalid2(n)) yield n).sum
  }
}
