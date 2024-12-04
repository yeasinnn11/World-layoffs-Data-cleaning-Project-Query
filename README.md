# World Layoffs Data Cleaning Project

This project outlines a comprehensive data-cleaning process performed on a dataset containing global layoffs.  
The objective is to ensure that the dataset is cleaned, standardized, and prepared for further analysis.

---

## Project Objectives

1. **Duplicate Removal**: Eliminate repeated records to maintain data integrity.  
2. **Standardization**: Unify column formats such as trimming spaces, correcting values, and ensuring consistency.  
3. **Null Handling**: Address missing values to either fill or remove them based on their significance.  
4. **Column Optimization**: Drop unnecessary columns and update data types for clarity and usability.

---

## Cleaning Process

### 1. **Creating a Staging Table**
A staging table `layoffs_staging` was created to work on a copy of the raw data.

```sql
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging
SELECT * FROM layoffs;
```

---

### 2. **Removing Duplicates**
- Identified duplicate rows using the `ROW_NUMBER()` function and removed them.

```sql
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, 
               total_laid_off, percentage_laid_off, 
               `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_staging
)
DELETE
FROM layoffs_staging2
WHERE row_num > 1;
```

---

### 3. **Standardizing Data**
#### - Trim Spaces
- Removed trailing and leading spaces from company names and other fields.

```sql
UPDATE layoffs_staging2
SET company = TRIM(company);
```

#### - Standardize Industry Values
- Updated inconsistent industry names to a standard format.

```sql
UPDATE layoffs_staging2 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

#### - Normalize Country Names
- Ensured country names are consistent.

```sql
UPDATE layoffs_staging2 
SET country = 'United States'
WHERE country LIKE 'United States%';
```

#### - Convert Dates
- Transformed date fields from text to proper date formats.

```sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
```

---

### 4. **Handling Null Values**
- Found and handled null records in significant columns. Missing industries were updated based on other records of the same company.

```sql
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;
```

- Removed rows with `NULL` in both `total_laid_off` and `percentage_laid_off` columns.

```sql
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
    AND percentage_laid_off IS NULL;
```

---

## Technologies Used
- **SQL**: For data cleaning and transformations.
- **Database**: MySQL.

---

## How to Use
1. Clone this repository to your local system.  
2. Load the `World layoffs data-cleaning. Project Query.sql` into your database system.  
3. Run the script to view and manipulate the cleaned data in `layoffs_staging2`.

---

## Learnings
- Proper use of window functions like `ROW_NUMBER()` for identifying duplicates.
- Techniques for standardizing and normalizing messy data.
- Effective handling of missing or null values in datasets.

---

## Author
**Yasin Arfaat**  
- A passionate data analyst experienced in cleaning and transforming real-world datasets.

--- 
