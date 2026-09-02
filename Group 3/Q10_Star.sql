USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 3 Star 3: 7-day Rolling Average by Product Category for 2008

WITH DailyCategorySales AS (
	SELECT
		d.DateKey,
		d.FullDateLabel,
		d.CalendarYear,
		p.ProductCategoryKey,
		p.ProductCategoryName,
		CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
		SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
	FROM
		star.FactSales f
		INNER JOIN star.DimDate d
			ON f.DateKey = d.DateKey
		INNER JOIN star.DimProduct p
			ON f.ProductKey = p.ProductKey
	WHERE 
		d.CalendarYear = 2008
	GROUP BY
		d.DateKey,
		d.FullDateLabel,
		d.CalendarYear,
		p.ProductCategoryKey,
		p.ProductCategoryName
)

SELECT
	DateKey,
	FullDateLabel,
	CalendarYear,
	ProductCategoryKey,
	ProductCategoryName,
	TotalAmount,
	TotalQuantity,
	CAST(
		AVG(TotalAmount) OVER (PARTITION BY ProductCategoryKey ORDER BY DateKey ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
		AS DECIMAL(19,4)
	) AS RollingAvgAmount,
	CAST(
		AVG(CAST(TotalQuantity AS DECIMAL(19,4))) OVER (PARTITION BY ProductCategoryKey ORDER BY DateKey ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
		AS DECIMAL(19,4)
	) AS RollingAvgQuantity
FROM DailyCategorySales