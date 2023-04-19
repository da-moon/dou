# Data Lab 💾

# Practice #1 - ETL practice - `Azure storage` + `Azure functions` + `Azure cosmosdb`

### Objective:

Create en ETL by developing an azure-function with python that consumes data from azure- storage and ingest the data into cosmosdb collection.

__Details:__

1. Download the file: <https://www.kaggle.com/datasets/poushalimukherjee/fifa-world-cup- qatar-2022>
2. Analyze the data, check how it’s structured, data types, etc. How many files does it have? What’s the total size for the data?
3. Create a `blob-storage-container` and upload the data there (make it private)
4. Create a `cosmosdb` database and `cosmosdb-container`.
   - You can use whatever name, and define `partition_key` for the field `teams_group`
5. Crate an azure-function app
   1. ETL Development - Objectives 
      - Using `azure sdk`, create a process (that will be hosted in an `azure-function`) that reads the `JSON` data and perform the below actions
        - Get every team and collect its statistics (Use OOP as much as possible. Ie: for
        casting JSON/dicts into a dataclass object)
        - Store every single team into cosmosdb with the below schema
           ```JSON
           { "id": "<TEAM_NAME_ABBR>", "name": "<TEAM_NAME>", "stats": {"<PERFORMANCE>"} }
           ```
6. Deploy your code to the `azure-function` app
7. Review execution
8. Query results on `cosmosdb` `data-explorer` view

__Extras:__
- Take a look into metrics provided by `azure`
- What other services we could integrate to `azure-functions` to get information about
execution?
- Which type of metrics we could export to `azure-dashboards`? And which would you use for
monitoring?
