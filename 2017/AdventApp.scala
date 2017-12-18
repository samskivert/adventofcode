import scala.io.Source
import scala.collection.mutable.{BitSet => MBitSet, ArrayBuffer}

abstract class AdventApp {
  /** A map for doing memoized calculations. */
  abstract class MemoMap[K,V] extends collection.mutable.HashMap[K,V] {
    override def apply (k :K) = getOrElseUpdate(k, compute(k))
    protected def compute (k :K) :V
  }

  /** A map for doing memoized calculations with two args. */
  abstract class MemoMap2[K1,K2,V] extends collection.mutable.HashMap[(K1,K2),V] {
    def apply (k1 :K1, k2 :K2) = getOrElseUpdate((k1, k2), compute(k1, k2))
    protected def compute (k1 :K1, k2 :K2) :V
  }

  /** Reads the first line from the supplied source file. */
  def readline (file :String) :String =
    Source.fromFile(file).getLines().next.stripLineEnd

  /** Reads all lines from the supplied source file, stripping line endings. */
  def readlines (file :String) :Iterator[String] =
    Source.fromFile(file).getLines().map(_.stripLineEnd)

  // computes and returns the solution
  def answer :Any

  /** The main entry point for an Advent solution. Just calls `answer`. */
  def main (args :Array[String]) :Unit = {
    println(answer)
  }
}
