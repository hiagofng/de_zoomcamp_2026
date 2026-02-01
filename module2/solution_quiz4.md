1) Backfill @workflow_kestra_quiz1.yaml from period betweeb 2021-03-01 and 2023-03-31 23:59:59 for green taxi

2) execute command in google cloud shell:

hiagoiug@cloudshell:~ (project-c92681f2-4463-49ea-9cf)$ gsutil cat gs://de_zoomcamp-bucket01/yellow_tripdata_2021-03.csv | wc -l
1925153