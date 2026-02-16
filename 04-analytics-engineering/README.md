# Module 4 Homework: Analytics Engineering with dbt

In this homework, we'll use the dbt project in `04-analytics-engineering/taxi_rides_ny/` to transform NYC taxi data and answer questions by querying the models.

## Setup

1. Set up your dbt project following the [setup guide](../../../04-analytics-engineering/setup/)
2. Load the Green and Yellow taxi data for 2019-2020 into your warehouse
3. Run `dbt build --target prod` to create all models and run tests

> **Note:** By default, dbt uses the `dev` target. You must use `--target prod` to build the models in the production dataset, which is required for the homework queries below.

After a successful build, you should have models like `fct_trips`, `dim_zones`, and `fct_monthly_zone_revenue` in your warehouse.

## Question 1. dbt Lineage and Execution

Given a dbt project with the following structure:

```
models/
├── staging/
│   ├── stg_green_tripdata.sql
│   └── stg_yellow_tripdata.sql
└── intermediate/
    └── int_trips_unioned.sql (depends on stg_green_tripdata & stg_yellow_tripdata)
```

If you run `dbt run --select int_trips_unioned`, what models will be built?

- `stg_green_tripdata`, `stg_yellow_tripdata`, and `int_trips_unioned` (upstream dependencies)
- Any model with upstream and downstream dependencies to `int_trips_unioned`
- `int_trips_unioned` only
- `int_trips_unioned`, `int_trips`, and `fct_trips` (downstream dependencies)

### ANSWER

-> `int_trips_unioned` only

It executes only that one model called int_trips_unioned against my targets. It does not run its upstream dependencies unless we add a + prefix


---

## Question 2. dbt Tests

You've configured a generic test like this in your `schema.yml`:

```yaml
columns:
  - name: payment_type
    data_tests:
      - accepted_values:
          arguments:
            values: [1, 2, 3, 4, 5]
            quote: false
```

Your model `fct_trips` has been running successfully for months. A new value `6` now appears in the source data.

What happens when you run `dbt test --select fct_trips`?

- dbt will skip the test because the model didn't change
- dbt will fail the test, returning a non-zero exit code
- dbt will pass the test with a warning about the new value
- dbt will update the configuration to include the new value

### ANSWER

--> dbt will fail the test, returning a non-zero exit code

the accepted_values test verifies if in my current data on table int_trips_unioned has any values different from the ones declared in the values argument, Accordingly to below, the test failed when 5 is missing from the accepted values

18:27:22  Failure in test accepted_values_fct_trips_payment_type__False__1__2__3__4 (models\marts\schema.yml)
18:27:22    Got 1 result, configured to fail if != 0

my verification on bigquery:

select distinct(payment_type) from nytaxi.int_trips_unioned

[{
  "payment_type": "1"
}, {
  "payment_type": "2"
}, {
  "payment_type": "4"
}, {
  "payment_type": "5"
}, {
  "payment_type": "3"
}]


---

## Question 3. Counting Records in `fct_monthly_zone_revenue`

After running your dbt project, query the `fct_monthly_zone_revenue` model.

What is the count of records in the `fct_monthly_zone_revenue` model?

- 12,998
- 14,120
- 12,184
- 15,421

### ANSWER

SELECT count(*)
FROM nytaxi_prod.fct_monthly_zone_revenue
LIMIT 1000

--> 12,184

After adding the service_type in the fct_trips and then adding it to the group by in in the fct_monthly_zone_revenue

---

## Question 4. Best Performing Zone for Green Taxis (2020)

Using the `fct_monthly_zone_revenue` table, find the pickup zone with the **highest total revenue** (`revenue_monthly_total_amount`) for **Green** taxi trips in 2020.

Which zone had the highest revenue?

- East Harlem North
- Morningside Heights
- East Harlem South
- Washington Heights South

### ANSWER

--> East Harlem North

In this case we have to consider only green taxis for the 2020 year and group by pick_zone_name, ordering desc the monthly_total_sum

SELECT
      service_type,
      pickup_zone_name,
      sum(monthly_total_amount) as total_sum
FROM nytaxi_prod.fct_monthly_zone_revenue
WHERE EXTRACT(YEAR FROM  revenue_month) = 2020
and service_type = 'green'
group by 1,2
order by 3 desc

---

## Question 5. Green Taxi Trip Counts (October 2019)

Using the `fct_monthly_zone_revenue` table, what is the **total number of trips** (`total_monthly_trips`) for Green taxis in October 2019?

- 500,234
- 350,891
- 384,624
- 421,509

### ANSWER

--> 384,624

For this exercise I had to create a new field called total_monthly_trips in the fct_monthly_trips_revenue
This new field is the count of rows in the fct_trips table
Then I created a sql to recover the total sum of total_monthly_trips filtering only green taxi trips for october 2019

SELECT SUM(total_monthly_trips)
FROM nytaxi_prod.fct_monthly_zone_revenue
WHERE EXTRACT(YEAR FROM revenue_month) = 2019
  AND EXTRACT(MONTH FROM revenue_month) = 10
  AND service_type = 'green'



---

## Question 6. Build a Staging Model for FHV Data

Create a staging model for the **For-Hire Vehicle (FHV)** trip data for 2019.

1. Load the [FHV trip data for 2019](https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv) into your data warehouse
2. Create a staging model `stg_fhv_tripdata` with these requirements:
   - Filter out records where `dispatching_base_num IS NULL`
   - Rename fields to match your project's naming conventions (e.g., `PUlocationID` → `pickup_location_id`)

What is the count of records in `stg_fhv_tripdata`?

- 42,084,899
- 43,244,693
- 22,998,722
- 44,112,187

### ANSWER

For this one I had to get data from the source and upload it to my gcp bucket, then I had to create new table stg_fhv_tripdata in production envitornment, created the model as a staging to filter out null values and rename some fields. Then I updated the profile.yaml to have one more profile called fhv_prod.
Finally, it was just a matter to execute the sql below to find the total quantity of records

SELECT
  count(*)
FROM `fhv_prod.stg_fhv_tripdata`

-> 43244693


---

## Submitting the solutions

- Form for submitting: <https://courses.datatalks.club/de-zoomcamp-2026/homework/hw4>

My solution: <LINK>

Free course by @DataTalksClub: https://github.com/DataTalksClub/data-engineering-zoomcamp/
