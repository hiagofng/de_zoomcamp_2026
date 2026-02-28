# Module 5 Homework: Data Platforms with Bruin

In this homework, we'll use the Bruin project in `05-data-platforms/` to build data pipelines with DuckDB and answer questions about Bruin concepts and commands.

## Setup

1. Install Bruin CLI following the [official documentation](https://github.com/bruin-data/bruin)
2. Navigate to the project directory and review the `.bruin.yml` configuration
3. Run `bruin run --full-refresh` to create all tables from scratch

After a successful run, you should have tables like `staging.trips` and `reports.trips_report` in your DuckDB database.

---

## Question 1. Bruin Pipeline Structure

In a Bruin project, what are the required files/directories?

- `.bruin.yml` and `assets/`
- `.bruin.yml` and `pipeline.yml` (assets can be anywhere)
- `.bruin.yml` and `pipeline/` with `pipeline.yml` and `assets/`
- `pipeline.yml` and `assets/` only

### ANSWER

--> `.bruin.yml` and `pipeline/` with `pipeline.yml` and `assets/`

Its required to have the .bruin.yml at the project root level because it defines environments and connections
also, its required a pipeline.yml for each pipeline stage to define pipeline name, schedule, start date, default connections and variables
Therefore, we should also have assets/ which contains the actual data transformation logics either a .sql or a .py for python based assets

---

## Question 2. Materialization Strategies

Which incremental strategy is best for processing a specific interval period by deleting and inserting data for that time period?

- `append` - always add new rows
- `replace` - truncate and rebuild entirely
- `time_interval` - incremental based on a time column
- `view` - create a virtual table only

### ANSWER

--> `time_interval`

Because time_interval strategy takes the run's start/end dates, deletes all existing row in that time window (base on the incremental_key column) then inserts the freshly computed rows for that same period, avoiding duplicating data in subsequent runs.

---

## Question 3. Pipeline Variables

How do you override the `taxi_types` variable to only process yellow taxis?

- `bruin run --taxi-types yellow`
- `bruin run --var taxi_types=yellow`
- `bruin run --var 'taxi_types=["yellow"]'`
- `bruin run --set taxi_types=["yellow"]`

### ANSWER

--> `bruin run --var 'taxi_types=["yellow"]`

Because bruin uses the --var flag to override pipeline variables and since taxi_types is defined as an array in pipeline.yml, the value must be passed as a JSON array.

---

## Question 4. Running with Dependencies

Which command runs a modified asset plus all downstream assets?

- `bruin run ingestion.trips --all`
- `bruin run ingestion/trips.py --downstream`
- `bruin run pipeline/trips.py --recursive`
- `bruin run --select ingestion.trips+`

### ANSWER

--> `bruin run ingestion/trips.py --downstream`

running the command --downstream preceded by an asset, it runs the specified asset and all the assets that depend on it, following the dependency chain.

---

## Question 5. Quality Checks

Which quality check ensures `pickup_datetime` never has NULL values?

- `name: unique`
- `name: not_null`
- `name: positive`
- `name: accepted_values, value: [not_null]`

### ANSWER

--> `name: not_null`

in the staging phase we have a quality check for pickup_datetime that is called not_null

---

## Question 6. Lineage and Dependencies

Which Bruin command visualizes the dependency graph?

- `bruin graph`
- `bruin dependencies`
- `bruin lineage`
- `bruin show`

### ANSWER

--> `bruin lineage`

If we run this command for a specific asset path it is shown the dependencie graph, either upstream and/or downstream

---

## Question 7. First-Time Run

What flag ensures tables are created from scratch on a new DuckDB database?

- `--create`
- `--init`
- `--full-refresh`
- `--truncate`

### ANSWER

--> `--full-refresh`

the command full-refresh ignores any incremental logic and recreates all tables from scratch

---

## Submitting the solutions

- Form for submitting: <https://courses.datatalks.club/de-zoomcamp-2026/homework/hw5>

My solution: <LINK>

Free course by @DataTalksClub: https://github.com/DataTalksClub/data-engineering-zoomcamp/
