-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values

/*
* Make a staging table for changes
*
SELECT * 
INTO layoffs_staging
FROM layoffs;
*/

-- Remove duplicates
WITH duplicate_cte AS
(
SELECT *
, ROW_NUMBER() OVER (
              PARTITION BY company, industry, total_laid_off, percentage_laid_off, [date], stage
			  , country, funds_raised_millions
              ORDER BY (SELECT NULL)
            ) AS DupRank
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE DupRank > 1;

-- Standardizing data
UPDATE layoffs_staging
SET company = TRIM(company);

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging
SET country = TRIM('.' FROM country)
WHERE country LIKE 'United States%';

UPDATE layoffs_staging
SET total_laid_off = CASE WHEN total_laid_off = 'NULL' OR total_laid_off = '' then NULL else total_laid_off End,
percentage_laid_off = CASE WHEN percentage_laid_off = 'NULL' OR percentage_laid_off = '' then NULL else percentage_laid_off End,
industry = CASE WHEN industry = 'NULL' OR industry = '' then NULL else industry End

-- Null or blank values
select *
from layoffs_staging
where industry IS NULL;

select *
from layoffs_staging
where company LIKE 'Bally%'

SELECT *
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE t1
SET t1.industry = t2.industry
FROM layoffs_staging t1
JOIN layoffs_staging t2 
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND T2.industry IS NOT NULL;

select *
from layoffs_staging
where total_laid_off is NULL
AND percentage_laid_off is NULL
order by 1;

DELETE
from layoffs_staging
where total_laid_off is NULL
AND percentage_laid_off is NULL;