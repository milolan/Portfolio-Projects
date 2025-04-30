-- DATA CLEANING

SELECT *
FROM layoffs;

-- Remove duplicates
-- Standardise the data
-- Null/Blank values
-- Remove unnecessary rows and columns

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, 'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, 'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num >1;

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
 `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off, 'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT*
FROM layoffs_staging2
WHERE row_num >1;

DELETE
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

-- Standardizing Data

SELECT DISTINCT (company)
FROM layoffs_staging2;

SELECT COMPANY,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company= TRIM(company);

SELECT DISTINCT (industry)
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry ='Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%';

SELECT distinct country,TRIM(TRAILING '.'FROM country)
from layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.'FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2
ORDER BY 1;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry is null
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company='Airbnb';

SELECT *
FROM layoffs_staging2
WHERE company='Carvana';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

UPDATE layoffs_staging2
SET industry= null
WHERE industry = '';

SELECT ST1.industry, ST2.industry
FROM layoffs_staging2 ST1
JOIN layoffs_staging2 ST2
	ON ST1.company=ST2.company
    AND ST1.location=ST2.location
WHERE ST1.industry IS NULL
AND ST2.industry IS NOT NULL;

UPDATE layoffs_staging2 ST1
JOIN layoffs_staging2 ST2
ON ST1.company=ST2.company
SET ST1.industry=ST2.industry
WHERE ST1.industry IS NULL
AND ST2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;