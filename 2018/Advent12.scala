object Advent12 extends AdventApp {
  def mkState (pots :Seq[(Boolean,Int)]) = pots.filter(_._1).map(_._2).toSet
  def ruleNo (bits :Seq[Boolean]) :Int = (0 /: bits)((n, b) => (n << 1) | (if (b) 1 else 0))
  val input = readlines("data/input12.txt")
  val initState = mkState(input.next.substring(15).map(_ == '#').zipWithIndex)
  val onRules = input.filter(_ endsWith " => #").map(r => ruleNo(r.substring(0, 5).map(_ == '#')))
  val rules = (new Array[Boolean](32) /: onRules) {(rs, r) => rs(r) = true ; rs}
  def on (state :Set[Int], p :Int) = rules(ruleNo(p-2 to p+2 map state))
  def evolve (state :Set[Int]) = mkState(state.min-2 to state.max+2 map {p => (on(state, p), p)})
  def evolveN (state :Set[Int], n :Int) = (state /: (0 until n)) {(s, _) => evolve(s)}
  // we reach a steady state at iteration 99, after which everything just slides over one to the
  // right each iteration; so iterate to 100, then just add 49 billion and change to each key
  def evolve50B (state :Set[Int]) = evolveN(state, 100).map(_ + 49999999900L).sum
  def answer = (evolveN(initState, 20).sum, evolve50B(initState))
}
