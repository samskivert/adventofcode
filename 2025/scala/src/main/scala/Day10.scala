object Day10 extends Day(10) {

  case class Machine (target :Int, buttons :Seq[Int], joltage :Seq[Int])

  def parse (line :String) = {
    def strip (part :String) = part.slice(1, part.length-1)
    def toNums (part :String) = strip(part).split(",").map(_.toInt).toSeq
    def toButton (nums :Seq[Int]) = nums.foldLeft(0)((m, b) => m | (1 << b))
    val parts = line.split(" ")
    Machine(Integer.parseInt(strip(parts(0)).replace('.', '0').replace('#', '1').reverse, 2),
            parts.slice(1, parts.length-1).map(toNums).map(toButton).toSeq, toNums(parts.last))
  }

  def configLights (m :Machine) :Int = {
    def loop (ii :Int, state :Int, presses :Int) :Int = {
      val nstate = state ^ m.buttons(ii)
      if (nstate == m.target) presses+1
      else if (ii == m.buttons.size-1) 9999
      else Math.min(loop(ii+1, state, presses), loop(ii+1, nstate, presses+1))
    }
    loop(0, 0, 0)
  }

  override def answer1 (input :Seq[String]) = input.map(parse).map(configLights).sum

  def configJoltage (m :Machine) :Int = {
    def parityPresses (remain :Seq[Int]) = {
      val target = remain.indices.foldLeft(0)((m, ii) => m | ((remain(ii) & 0x1) << ii))
      def add (ii :Int, state :Int, presses :List[Int]) :Seq[List[Int]] =
        if (ii == m.buttons.size) Seq()
        else {
          val nstate = state ^ m.buttons(ii)
          val npresses = m.buttons(ii) :: presses
          val rest = add(ii+1, state, presses) ++ add(ii+1, nstate, npresses)
          if (nstate == target) npresses +: rest else rest
        }
      if (target == 0) add(0, 0, Nil) :+ List() else add(0, 0, Nil)
    }

    def apply (ps :List[Int], target :Seq[Int]) :Seq[Int] =
      target.indices.map(ii => (target(ii) - ps.count(b => (b & (1 << ii)) != 0)) / 2)

    def loop (remain :Seq[Int]) :Int = {
      if (remain.exists(_ < 0)) 9999
      else if (!remain.exists(_ > 0)) 0
      else parityPresses(remain).foldLeft(9999)(
        (minp, ps) => minp.min(ps.length + 2 * loop(apply(ps, remain))))
    }
    loop(m.joltage)
  }

  override def answer2 (input :Seq[String]) = input.map(parse).map(configJoltage).sum
}
