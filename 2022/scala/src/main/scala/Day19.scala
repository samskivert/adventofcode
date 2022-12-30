object Day19 extends Day(19):

  case class Cost (mat0 :Int, mat1 :Int, mat2 :Int)

  case class State (mat0 :Int, mat1 :Int, mat2 :Int, mat3 :Int,
                    bot0 :Int, bot1 :Int, bot2 :Int, bot3 :Int):
    def collect () =
      State(mat0 + bot0, mat1 + bot1, mat2 + bot2, mat3 + bot3, bot0, bot1, bot2, bot3)
    def canMake (cost :Cost) =
      mat0 >= cost.mat0 && mat1 >= cost.mat1 && mat2 >= cost.mat2
    def make (cost :Cost, bb :Int) =
      val nbot0 = bot0 + (if bb == 0 then 1 else 0)
      val nbot1 = bot1 + (if bb == 1 then 1 else 0)
      val nbot2 = bot2 + (if bb == 2 then 1 else 0)
      val nbot3 = bot3 + (if bb == 3 then 1 else 0)
      State(mat0 - cost.mat0, mat1 - cost.mat1, mat2 - cost.mat2, mat3, nbot0, nbot1, nbot2, nbot3)

  case class Blueprint (id :Int, costs :Seq[Cost]):
    def quality = geodes(24) * id
    def geodes (minutes :Int) =
      var best = 0
      val (max0, max1, max2) = (costs.map(_.mat0).max, costs(2).mat1, costs(3).mat2)
      def search (state :State, minutes :Int) :Unit =
        val nstate = state.collect()
        val nminutes = minutes - 1
        val rest = nstate.mat3 + nstate.bot3*nminutes
        if rest > best then best = rest
        if nminutes == 0 || rest + (nminutes * (nminutes-1))/2 < best then return
        var ii = costs.size-1 ; while ii >= 0 do
          if !(ii == 2 && state.bot2 >= max2) &&
             !(ii == 1 && state.bot1 >= max1) &&
             !(ii == 0 && state.bot0 >= max0) &&
             state.canMake(costs(ii)) then search(nstate.make(costs(ii), ii), nminutes)
          ii -= 1
        search(nstate, nminutes)
      search(State(0, 0, 0, 0, 1, 0, 0, 0), minutes)
      best

  val pattern = (
    """Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. """ +
    """Each obsidian robot costs (\d+) ore and (\d+) clay. """ +
    """Each geode robot costs (\d+) ore and (\d+) obsidian.""").r

  def parse (input :String) = pattern.findFirstMatchIn(input) match
    case None => Blueprint(0, Seq())
    case Some(m) => Blueprint(m.group(1).toInt, Seq(
      Cost(m.group(2).toInt, 0, 0), Cost(m.group(3).toInt, 0, 0),
      Cost(m.group(4).toInt, m.group(5).toInt, 0), Cost(m.group(6).toInt, 0, m.group(7).toInt)))

  override def answer1 (input :Seq[String]) = input.map(parse).map(_.quality).sum
  override def answer2 (input :Seq[String]) = input.take(3).map(parse).map(_.geodes(32)).product
