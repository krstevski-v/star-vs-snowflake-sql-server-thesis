USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 2, Star Query 3: Daily Sales and Quantity by Product Category for 2008

SELECT
	d.DateKey,
	d.FullDateLabel,
	p.ProductCategoryKey,
	p.ProductCategoryName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM star.FactSales f
INNER JOIN star.DimDate d
	ON f.DateKey = d.DateKey
INNER JOIN star.DimProduct p
	ON f.ProductKey = p.ProductKey
WHERE
	d.CalendarYear = 2008
GROUP BY
	d.DateKey,
	d.FullDateLabel,
	p.ProductCategoryKey,
	p.ProductCategoryName;