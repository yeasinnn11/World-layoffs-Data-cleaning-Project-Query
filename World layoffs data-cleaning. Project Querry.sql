-- ----------------------------First Look to the dataset-------------------------------------------------------

USE world_layoffs;

SELECT 
    *
FROM
    layoffs;
    
-- -------------------------------------Process for cleaning-----------------------------------------------------
/*
1. Removeing Duplicates if presented 
2. Standardize the data for better insight
3. Try to Fill null value if possible 
   without effacting the insight result
   or drop it, if possible.
4. Remove unncessary column from dataset 
   to make the data more readble.
5. 
*/

-- ------------------Creating another table name layoffs_staging to clean the data------------------------------

CREATE TABLE layoffs_staging 
LIKE layoffs;

-- Inserting dataset to layoffs_staging

INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT * 
FROM layoffs_staging;


-- Removing Duplicats

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, indursty, 
location, indursty, total_laid_off, 
percentage_laid_off,
'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, 
               total_laid_off, percentage_laid_off, 
               `date`, stage, country, funds_raised_millions
           ) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;




CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT * 
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, 
total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


SELECT * 
FROM layoffs_staging2;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

-- -----------------------------------------Standardizing data-------------------------------------------------

SELECT company, TRIM(company) AS company
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT Country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2 
SET country = 'United States'
WHERE country LIKE 'United States%';


-- alternative way

UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- Coverting date text format to date format

SELECT *
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2 
SET industry = NULL
WHERE industry = '';



SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;


SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

DELETE
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;
        
        
SELECT 
    *
FROM
    layoffs_staging2;