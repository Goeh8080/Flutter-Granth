// Standalone sample; not part of the app build.
object GranthList {
  def main(args: Array[String]): Unit = {
    val granths = List("Gita", "Kabir Sagar", "Ved")
    granths.zipWithIndex.foreach { case (g, i) => println(s"${i + 1}. $g") }
  }
}
// Granth list sample Granth lis
