-- EXPLORATORY DATA ANALYSIS--
SELECT * 
FROM layoffs_stage2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_stage2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)
FROM layoffs_stage2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_stage2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_stage2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`),SUM(total_laid_off)
FROM layoffs_stage2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage,SUM(total_laid_off)
FROM layoffs_stage2
GROUP BY stage
ORDER BY 2 DESC;

SELECT MONTH(`date`)
FROM layoffs_stage2;

SELECT SUBSTRING(`date`,6,2) AS `Month`,SUM(total_laid_off)
FROM layoffs_stage2
GROUP BY `Month` 
ORDER BY 1;

SELECT SUBSTRING(`date`,1,7) AS `Month_Year`,SUM(total_laid_off)
FROM layoffs_stage2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month_Year`
ORDER BY 1 ASC ;

WITH Rolling_Total AS
(
SELECT SUBSTRING( `date`,1,7) AS `MONTH`,SUM(total_laid_off) AS total_off
FROM layoffs_stage2
WHERE SUBSTRING( `date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`, total_off,SUM(total_off) OVER(ORDER BY `MONTH` ) AS ROLLING_TOTAL
FROM Rolling_Total;

SELECT company, SUM(total_laid_off)
FROM layoffs_stage2
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY 2 DESC;

SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stage2
WHERE total_laid_off IS NOT NULL
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


WITH Company_Year(Company, Years, Total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stage2
WHERE total_laid_off IS NOT NULL
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5;
