USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 3 Star 1: Product Category Ranking by Monthly Sales for 2008

WITH MonthlyCategorySales AS (
	SELECT
		d.CalendarYear,
		d.CalendarMonth,
		d.CalendarMonthLabel,
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
		d.CalendarYear,
		d.CalendarMonth,
		d.CalendarMonthLabel,
		p.ProductCategoryKey,
		p.ProductCategoryName
)

SELECT
	CalendarYear,
	CalendarMonth,
	CalendarMonthLabel,
	ProductCategoryKey,
	ProductCategoryName,
	TotalAmount,
	TotalQuantity,
	ROW_NUMBER() OVER (PARTITION BY CalendarYear, CalendarMonth ORDER BY TotalAmount DESC, ProductCategoryKey ASC) AS CategoryRank
FROM MonthlyCategorySales;