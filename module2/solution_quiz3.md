1) Backfill @workflow_kestra_quiz1.yaml from period betweeb 2020-01-01 and 2025-12-31 for green taxi

2) execute command in google cloud shell:

hiagoiug@cloudshell:~ (project-c92681f2-4463-49ea-9cf)$ gsutil cat gs://de_zoomcamp-bucket01/green_tripdata_*.csv | wc -l
1734063