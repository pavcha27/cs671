import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
// Do NOT use different Spark libraries.

object NoInOutLink {
    def main(args: Array[String]) {
        val input_dir = "sample_input"
        val links_file = input_dir + "/links-simple-sorted.txt"
        val titles_file = input_dir + "/titles-sorted.txt"
        val num_partitions = 10

        val conf = new SparkConf()
            .setAppName("NoInOutLink")
            .setMaster("local[*]")
            .set("spark.driver.memory", "1g")
            .set("spark.executor.memory", "2g")

        val sc = new SparkContext(conf)

        val links = sc
            .textFile(links_file, num_partitions)
            .map(line => line.split(": "))                                          // separates In Link
            .flatMap(arr => arr(1).split(" ").map(out_link => (arr(0), out_link)))  // for each Out Link, map the In Link to it

        val titles = sc
            .textFile(titles_file, num_partitions)
            .zipWithIndex()             // automatically creates index for line counter!
            .map(t => (t._2+1, t._1))   // all I have to do is switch the index with the String, to match output

        /* No Outlinks */
        // initialize to all titles, then filter using the filters below to check the appropriate linkage
        val no_outlinks: List[(Long, String)] = titles
            .collect()
            .toList
            .filter(title => outlink_check(title, links.collect().toList))
        println("[ NO OUTLINKS 1 ]")
        no_outlinks
            .sortWith(_._1.toInt < _._1.toInt) // ascending order
            .take(10.min(no_outlinks.size)) // first ten elements
            .foreach(println) // printed to output
        

        /* No Inlinks */
        // initialize to all titles, then filter using the filters below to check the appropriate linkage
        val no_inlinks: List[(Long, String)] = titles
            .collect()
            .toList
            .filter(title => inlink_check(title, links.collect().toList))
        println("\n[ NO INLINKS 1 ]")
        no_inlinks
            .sortWith(_._1.toInt < _._1.toInt) // ascending order
            .take(10.min(no_inlinks.size)) // first ten elements
            .foreach(println) // printed to output
        
        println("")
    }

    def outlink_check (title: (Long, String), links: List[(String, String)]) : Boolean = {
        // if title number appears as first number in link, then it has an outlink
        for (link <- links) {
            if (title._1.toInt == link._1.toInt) {
                return false
            }
        }
        
        return true
    }

    def inlink_check (title: (Long, String), links: List[(String, String)]) : Boolean = {
        // if title number appears as second number in link, then it has an inlink
        for (link <- links) {
            if (title._1.toInt == link._2.toInt) {
                return false
            }
        }
        
        return true
    }
}
