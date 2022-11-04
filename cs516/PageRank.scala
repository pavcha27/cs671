import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
// Do NOT use different Spark libraries.

object PageRank {
    def main(args: Array[String]) {
        val input_dir = "sample_input"
        val links_file = input_dir + "/links-simple-sorted.txt"
        val titles_file = input_dir + "/titles-sorted.txt"
        val num_partitions = 10
        val iters = 10

        val conf = new SparkConf()
            .setAppName("PageRank")
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

        // set these since they will be used over and over
        val link_tuples = links.collect()
        val title_tuples = titles.collect()

        // number of links
        val m: Int = link_tuples.size

        // number of pages
        val n: Int = title_tuples.size

        // damping factor
        val d: Double = 0.85

        // initial value is just (1-d)*100/N
        val initial: Double = (1-d)*100.0/n

        // initialize to 100/N for each page, N = number of elements in titles
        var pageRank: Array[(Long, (String, Double))] = title_tuples.map(t => (t._1, (t._2, 100.0/n)))

        // save the number of outlinks, to access later
        var outs: Array[Int] = new Array[Int](n)
        for (i <- 0 until m) {
            val node: Int = link_tuples(i)._1.toInt - 1
            outs(node) += 1
        }

        /* PageRank */
        for (i <- 1 to iters) {
            var newPageRank: Array[(Long, (String, Double))] = title_tuples.map(t => (t._1, (t._2, initial)))
            // for each x, we want to update its value, using the formula
            for (j <- 0 until n) {
                // current page title
                val pageName: String = newPageRank(j)._2._1

                // we have set the initial value already; we need to do the summation
                var sum: Double = 0.0

                // go through every link
                for (k <- 0 until m) {
                    // if there is a inlink for x
                    if (link_tuples(k)._2.toInt-1 == j) {
                        // for every node y that is pointing to x, do PageRank/Out for y
                        val y: Int = link_tuples(k)._1.toInt - 1
                        sum += pageRank(y)._2._2/outs(y)
                    }
                }
                
                // newPageRank = initial + d*summation, from formula
                newPageRank(j) = (j+1, (pageName, initial + d*sum))
            }

            pageRank = newPageRank.clone()
        }

        var total: Double = 0.0
        for (pr <- pageRank) {
            total = total + pr._2._2
        }
        pageRank = pageRank.map(pr => (pr._1, (pr._2._1, ((pr._2._2*100.0)/total))))

        println("[ PageRank 1 ]")
        pageRank
            .sortWith(_._2._2 > _._2._2)
            .take(10)
            .foreach(println)
        
        println("")
    }
}
