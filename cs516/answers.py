"""
If you modify anything besides the areas marked as *** CODE HERE *** then it is your responsibility to change it back. 
You may be unable to submit or face errors due to formatting errors or otherwise resulting from such changes.

This has been tested with python 3.8-3.10 on Unix and MacOS terminal (i.e. 'python3 answers.py').
"""

from pymongo import MongoClient 
from bson import json_util 

class Answers:

    def __init__(self):
        self.dblp = MongoClient("localhost", 27017)["dblp"]    
        self.article = self.dblp['Article']
        self.inproceedings = self.dblp['Inproceedings']

    def run(self):

        methods = [func for func in dir(self) if callable(getattr(self, func)) and func.startswith('q')]
        method_names = [str(func) for func in methods]
        choices = ['all'] + method_names 
        choice = None 
        while not choice in choices: 
             choice = input(f"Enter one of {choices}\n")

        qus = method_names if choice == "all" else [choice]

        for qu in qus: 
            func = getattr(self, qu)
            res = func() 
            if not isinstance(res, list):
                print(f"Please re-read all the formatting instructions for {qu}. For every question you must return a list.")
                break 
            file_name = f"{qu}.json"
            with open(file_name, 'w') as f: 
                # json_util.dumps is specially used instead of json.dumps because 'ObjectID' is not JSON serializable by default!
                    # however, for all of these questions (except sample q_test) you do NOT ever need to nor should return any ObjectID
                f.write(json_util.dumps(res, indent=4))
            print(f"Successfully ran {qu} and made {file_name}")
        
    def q_test(self):
        """
        Test query 
        """

        res = self.article.find({}).limit(10)

        # Res is a cursor! Make sure to read MongoDB documentation to be extra careful about what returns results directly (rare if any) and what returns a cursosr
        print(res) 

        return [_ for _ in res]

    def q2(self):
        """
        Counts of 'Article' and 'Inproceedings'
        End result must be an array containing an object of the form {'article_count': ..., 'inproceedings_count': ...}
        """

        # *** CODE HERE *** 
        article_count = self.article.count_documents({})
        inproceedings_count = self.inproceedings.count_documents({})

        return [{
            'article_count': article_count, 
            'inproceedings_count': inproceedings_count
        }]

    def q3(self):
        """
        Add a column 'area' to Inproceedings and return count of all area values (including 'UNKNOWN')
        End result must be an array containing an object of the form {'area': ..., 'count': ...}
        """

        # Provided for your convenience...
        area_to_title = {
            'Database': ['VLDB', 'ICDE', 'PODS', 'SIGMOD Conference'],
            'Theory': ['STOC', 'FOCS', 'SODA', 'ICALP'],
            'Systems': ['ISCA', 'HPCA', 'PLDI', 'SIGCOMM'],
            'ML-AI': ['ICML', 'NIPS', 'AAAI', 'IJCAI']
        }

        # *** CODE HERE *** 
        # set all defaults to unknown
        self.inproceedings.update_many({},{"$set":{"area": "UNKNOWN"}})

        # for each area
        for area in area_to_title:
            # going through each book title in each area
            for title in area_to_title[area]:
                # if the title matches, then update to the current area
                self.inproceedings.update_many({'booktitle': title}, {"$set":{"area": area}})
        
        ## WORKING ATTEMPT, WITHOUT AGGREGATION
        # # keep list of all areas, sorted in ascending order
        # areas = (list(area_to_title.keys()) + ["UNKNOWN"]).sort()
        # counts = []
        # # loop through areas and count documents in each area
        # for area in areas:
        #     counts.append(self.inproceedings.count_documents({"area":area}))

        # return [{'area': area, 'count': count} for (area,count) in zip(areas,counts)] 

        ## WORKING ATTEMPT, WITH AGGREGATION
        area_counts = self.inproceedings.aggregate([
            # no filtering, go through every observation
            {"$group": {'_id':"$area", '_count': {"$sum": 1}}},

            # change the names as desired, and in the desired order
            {"$project": {'_id':0, 'area': '$_id', 'count':'$_count'}},

            # sort alphabetically on area, for autograder
            {'$sort': {'area': 1}}
        ])

        return list(area_counts)

    def q4a(self):

        """
        Top 20 authors published most # Database papers (Inproceedings).
        Must be done in ONE aggregation.
        Result must be an array containing objects of the form {'author': ..., 'num_papers': ...} sorted in descending order by num_papers, any ties broken in ascending order by author.
        """

        # *** CODE HERE *** 
        db_author_counts = self.inproceedings.aggregate([
            # filter only Database papers
            {"$match": {"area": "Database"}},

            # unwind authors
            {"$unwind": "$authors"},

            # group by the authors, and count their papers
            {"$group": {"_id": "$authors", "_count": {"$sum":1}}},

            # change the names, and in the desired order
            {"$project": {"_id":0, "author": "$_id", "num_papers": "$_count"}},

            # sort descending on num_papers, then ascending on authors
            {"$sort": {"num_papers":-1, "author":1}},

            # only print first 20
            {"$limit": 20}
        ])

        return list(db_author_counts)

    def q4b(self):
        """
        Find # authors who published in exactly two areas (not counting UNKNOWN).
        Must be done in ONE aggregation.
        Result must be an array composed of objects of the structure {'author': ...} sorted in ascending order by author name.
        """

        # *** CODE HERE *** 
        two_area_authors = self.inproceedings.aggregate([
            # filter out Unknowns
            {"$match": {"area": {"$not": {"$eq": "UNKNOWN"}}}},

            # unwind the authors
            {"$unwind": "$authors"},

            # get area by author
            {"$group": {"_id": "$authors", "_areas": {"$addToSet": "$area"}}},

            # unwind the authors
            {"$unwind": "$_areas"},

            # count the areas for each author
            {"$group": {"_id": "$_id", "_area_count": {"$sum": 1}}},

            # filter out for people who have area count = 2
            {"$match": {"_area_count": {"$eq": 2}}}, 

            # project author names
            {"$project": {"_id": 0, "author": "$_id"}},

            # sort on authors names
            {"$sort": {"author": 1}}
        ])

        return list(two_area_authors)
    
    def q4c(self):
        """
        Find the top 5 authors who published the maximum number of journal papers since 2000 among the top 20 authors who published at least one conference 'Database' paper.
        Must be done in ONE aggregation.
        Result must be an array composed of objects of the structure {'author': ..., 'num_papers': ...} sorted in descending order of num_papers, ties broken in ascending order by author name.
        """
        
        # *** CODE HERE ***
        # copied from q4a
        db_pipeline = [
                # unwind authors
                {"$unwind": "$authors"},

                # filter only Database papers
                {"$match": {"area": "Database"}},

                # group by the authors, and count their papers
                {"$group": {"_id": "$authors", "_count": {"$sum":1}}},

                # change the names, and in the desired order
                {"$project": {"_id":0, "author": "$_id", "num_papers": "$_count"}},

                # sort descending on num_papers, then ascending on authors
                {"$sort": {"num_papers":-1, "author":1}},

                # only print first 20
                {"$limit": 20},

                # only new thing: include if author is in list
                {"$match": {"$expr": {"$eq": ["$$jauthor", "$author"]}}},
            ]

        max_authors = self.article.aggregate([
            # filter papers since 2000
            {"$match": {"year": {"$gte": 2000}}},

            # unwind the authors
            {"$unwind": "$authors"},

            # project author to save space
            {"$project": {"author": "$authors"}},

            # filter the authors through the first pipeline in the inproceedings table
            {"$lookup": 
                {
                    "from": "Inproceedings",
                    "let": {"jauthor": "$author"},
                    "pipeline": db_pipeline,
                    "as": "top_author"
                }
            },

            # filter out objects that have a top_author
            {"$match": {"top_author": {"$size": 1}}},

            # count the number of papers
            {"$group": {"_id": "$author", "_count": {"$sum": 1}}},

            # change the names, and in the desired order
            {"$project": {"_id":0, "author": "$_id", "num_papers": "$_count"}},

            # sort descending on num_papers, then ascending on authors
            {"$sort": {"num_papers":-1, "author":1}},

            # print only first 5
            {"$limit": 5}
        ])

        return list(max_authors)

if __name__ == "__main__":

    answers = Answers() 
    answers.run()