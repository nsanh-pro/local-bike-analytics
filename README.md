# local-bike-analytics: Databird Analytics Engineer Bootcamp final case

The goal of this project was to implement a simplified end-to-end analytics solution for a fictional bike selling company named _Local Bike_, using the knowledge learned from the [Databird Analytics Engineer Bootcamp course](https://www.data-bird.co/formation-data-engineer/analytics-engineer-databird-datagen).
The following tools have been used:

<img width="1239" height="129" alt="image" src="https://github.com/user-attachments/assets/4c506512-1adb-487f-8c0e-8caaf87deb48" />

Note: the source data are sample CSV files that have been uploaded to Google BigQuery in a specific dataset for the purpose of this educational project. The source operational database model is described in the following diagram:

<img width="696" height="555" alt="image" src="https://github.com/user-attachments/assets/02dec934-9e20-4b73-9ffc-b3dc53818629" />


# What I have learned and implemented in this project
## Bootstrapping a dbt project in dbt Cloud
- Configuring a target git repository
- Configuring the target datawarehouse: Google BigQuery. Required the configuration of a Google Cloud Platform Service Account to allow dbt to use Google BigQuery as the target datawarehouse
- Configuration files:
  - dbt_project.yml: project configuration, such as materialization type per target schema, persist documentation in the target datawarehouse for table and column description.
  - source.yml: setting up sources
  - packages.yml: to list dbt packages to install using `dbt deps`, such as `codegen` or `dbt_utils`
  - schema.yml: for each subfolder in `\models`, describing models, columns and generic tests. Part of the documentation has been generated using `codegen` package, VS Code and GitHub Copilot. 
   
## Implementing a medaillon architecture

<img width="1746" height="689" alt="image" src="https://github.com/user-attachments/assets/56b9277e-5082-4bc1-8ed3-c2eec530eeb9" />

### Staging / Bronze Layer
From Raw Data using `{{ source() }}` jinjas, create bronze mdodels with the following transformations:
- Data cleansing
- Data type conversion
- Deduplicating raw data

These models are meant to be used as source for Silver models.
Materialization type: views.

### Core / Silver Layer
From Bronze models using `{{ ref() }}` jinjas, create silver models with the following transformations:
- Adding common business rules and calculations
- Star schema modeling with dimension and fact tables:
  - A Date dimension has been generated using the `dbt_utils` package.
  - Date surrogate keys have been created in fact tables using _dbt macros_, stored in the `\macros` folder

These models are meant to be used as source for Silver models.
Materialization type: tables (as they would be often queried).

Note: This layer has been used to create a Power BI semantic model, which can be seen as a Gold Layer itself.

<img width="956" height="767" alt="image" src="https://github.com/user-attachments/assets/48d203a8-32e9-4830-805d-c00b94a7e36d" />

The following report has been created using this Power BI semantic model:

<img width="1920" height="1032" alt="image" src="https://github.com/user-attachments/assets/0ea98cd9-70c8-44e4-ac46-30756095c09c" />

### Gold / Mart Layer
From Silver models using `{{ ref() }}` jinjas, create gold models with the following transformations:
- Ready-to-use models for Self Service BI tools, such as Power BI, Looker Studio, Metabase, Tableau ...
- Specific calculations and KPIs

These gold models are supposed to be directly used by end users, without the need for them to handle relationships.
Materialization type: tables (as they would be often queried).

In the following capture, we can see that the `mrt_top_100_customer` is used. The end user only has to do some drag and drop to create its report.

<img width="1911" height="938" alt="image" src="https://github.com/user-attachments/assets/01f45e11-6ed4-4a33-b0ff-95aa4b08b2d9" />

## Using GitHub + dbt CI features
### dbt tests
During the course, we have seen different kind of tests:
- Generic tests
- Singular tests 

I did not write any singular test for this project, but we did study them during the course, with alert and error behavior handling.
Also, we have tried packages such as `dbt_utils` and `dbt_expectations` to automatize more complex tests in a modular fashion.

### dbt CI job
Every Pull Request on this project triggers a specific dbt job to validate the modified content.

dbt configuration:

<img width="1563" height="609" alt="image" src="https://github.com/user-attachments/assets/39afb676-a46e-47fe-90b8-b713dfb3a08a" />

git configuration on the main branch so that a pull request may be merged only if the CI job is successful:

<img width="757" height="357" alt="image" src="https://github.com/user-attachments/assets/5eb692f0-c008-4aff-a416-c6773c07b089" />

The [#9 Pull Request](https://github.com/nsanh-pro/local-bike-analytics/pull/9) is a perfect example of this feature: we can see below that the first batch of commits were not validated by the CI job, so I had to do a new commit to fix the code before the merge to main was possible.

<img width="1337" height="791" alt="image" src="https://github.com/user-attachments/assets/0386bd19-ab98-4aba-a198-faafb42e439a" />




