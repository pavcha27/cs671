import org.apache.spark.SparkConf
import org.apache.spark.SparkContext

object WordCount {
    def main(args: Array[String]) {
        val conf = new SparkConf()
            .setMaster("local[*]")
            .setAppName("WordCount")

        val sc = new SparkContext(conf)

        // Read in the input text file.
        // Then, for each line in the text file, apply remove_punctuation() function.
        val lines_rdd = sc
            .textFile("YOUR_INPUT_FILE.txt") // {pass in your own input file}
            .map(remove_punctuation)

        // For each data (line string) in lines_rdd, split it into words.
        // Then, filter out empty strings.
        val words_rdd = lines_rdd
            .flatMap( line => line.split("\\s+") )
            .filter( word => word != "" )

        // For each data (word string) in words_rdd, create a (word,1) tuple.
        // Then, count the number of occurrences for each word.
        val wordcounts_rdd = words_rdd
            .map( word => (word, 1) )
            .reduceByKey( (a,b) => (a + b) )

        // Print the top 15 words which occurs the most.
        wordcounts_rdd
            .takeOrdered(10)(Ordering[Int].reverse.on(x => x._2))
            .foreach(println)
    }
    def remove_punctuation(line: String): String = {
        line.toLowerCase
            .replaceAll("""[\p{Punct}]""", " ")
            .replaceAll("""[^a-zA-Z]""", " ")
    }
}