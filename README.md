# World Layoffs Data Cleaning Project

This project demonstrates the process of cleaning and preparing a dataset related to layoffs worldwide. 
The goal is to ensure the dataset is structured, free of duplicates, and ready for analysis.

## Project Objectives
1. Remove duplicate records to ensure data integrity.
2. Standardize data fields for better insights.
3. Handle null values by either filling or dropping them, depending on the context.
4. Remove unnecessary columns to enhance readability.
5. Create a staging table to isolate and clean data systematically.

## Steps Performed

1. **Initial Exploration**
    - Query the `layoffs` table to get an overview of the dataset.

    ```sql
    SELECT * FROM layoffs;
    ```

2. **Staging Table**
    - Created a new table `layoffs_staging` to house the cleaned data.

    ```sql
    CREATE TABLE layoffs_staging LIKE layoffs;
    INSERT INTO layoffs_staging SELECT * FROM layoffs;
    ```

3. **Duplicate Removal**
    - Identified duplicates using the `ROW_NUMBER()` function and removed them:

    ```sql
    DELETE FROM layoffs_staging
    WHERE id NOT IN (
        SELECT MIN(id)
        FROM layoffs_staging
        GROUP BY company, industry, location, total_laid_off, percentage_laid_off, date, stage
    );
    ```

4. **Standardization**
    - Updated columns to standardize the format (e.g., case sensitivity, numeric precision).

5. **Null Value Handling**
    - Filled missing values where possible and dropped columns or rows otherwise.

6. **Finalization**
    - Removed unnecessary columns to streamline the dataset.

## Technologies Used
- **SQL**: For data cleaning and transformations.
- **Database**: MySQL.

## How to Use
1. Clone the repository.
2. Execute the SQL script `World layoffs data-cleaning. Project Query.sql` in your database environment.
3. Review the cleaned dataset in the `layoffs_staging` table.

## Learnings
- Importance of staging tables for isolating raw and cleaned data.
- Use of window functions like `ROW_NUMBER()` for duplicate handling.
- Trade-offs between filling and dropping null values.

## Author
**Yasin Arfaat**
- Data Analyst passionate about deriving insights from structured datasets.
