USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 2, Star Query 1: Monthly Sales and Quantity by Product Category

SELECT
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
	p.ProductCategoryKey,
	p.ProductCategoryName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM star.FactSales f
INNER JOIN star.DimDate d
	ON f.DateKey = d.DateKey
INNER JOIN star.DimProduct p
	ON f.ProductKey = p.ProductKey
GROUP BY
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
	p.ProductCategoryKey,
	p.ProductCategoryName;