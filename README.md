# README

To test file import and output file generation, you need to specify the input and output file names as environment variables in your .env file.
Then, from the Rails console, run the import job, which will import all the data, validate it, and generate the output file with the results.

```bash
$ cp .env.sample .env.development
$ bundle exec rails db:setup
$ bundle exec rails c
> FundLoadAttempts::ImportFileJob.new.perform
```

I didn’t cover the entire code with unit tests, as it would have taken more than 4 hours.
Instead, I wrote unit tests for several key files so you can evaluate my code style and adherence to RSpec best practices.


Since the input files can be extremely large, we use a main ImportFileJob background job that parses the file and enqueues a background job for processing each individual line.
Once the entire file is read and all line-processing jobs have been enqueued, we know the total number of lines that need to be processed.
Then, each line is processed by an ImportLineJob.
After that, another AdjudicateJob background job is triggered to validate the data according to all the rules specified in the task description.
Once the last line of the file has been validated, we’re ready to generate the output file output.txt.
At that point, a GenerateAdjudicateReportJob is triggered, which creates the result file.

The process works as a sequence of four background jobs:

Step 1: ImportFileJob - parses the input file.
Step 2: Enqueue ImportLineJob background jobs to import each attempt.
Step 3: Enqueue AdjudicateJob jobs to validate each imported attempt.
Step 4: Once all attempts are validated, enqueue GenerateAdjudicateReportJob to generate the output file.
