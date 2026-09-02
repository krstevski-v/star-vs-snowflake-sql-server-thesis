USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 3 Snowflake 3: 7-day Rolling Average by Product Category for 2008

WITH DailyCategorySales AS (
	SELECT
		d.DateKey,
		d.FullDateLabel,
		d.CalendarYear,
		pc.ProductCategoryKey,
		pc.ProductCategoryName,
		CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
		SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
	FROM
		snowflake.FactSales f
		INNER JOIN snowflake.DimDate d
			ON f.DateKey = d.DateKey
		INNER JOIN snowflake.DimProduct p
			ON f.ProductKey = p.ProductKey
		LEFT JOIN snowflake.DimProductSubcategory ps
			ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
		LEFT JOIN snowflake.DimProductCategory pc
			ON ps.ProductCategoryKey = pc.ProductCategoryKey
	WHERE 
		d.CalendarYear = 2008
	GROUP BY
		d.DateKey,
		d.FullDateLabel,
		d.CalendarYear,
		pc.ProductCategoryKey,
		pc.ProductCategoryName
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
FROM DailyCategorySales;