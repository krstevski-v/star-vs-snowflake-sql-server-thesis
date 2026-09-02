USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 2, Snowflake Query 1: Monthly Sales and Quantity by Product Category

SELECT
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
	pc.ProductCategoryKey,
	pc.ProductCategoryName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM snowflake.FactSales f
INNER JOIN snowflake.DimDate d
	ON f.DateKey = d.DateKey
INNER JOIN snowflake.DimProduct p
	ON f.ProductKey = p.ProductKey
LEFT JOIN snowflake.DimProductSubcategory ps
	ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN snowflake.DimProductCategory pc
	ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY
	d.CalendarYear,
	d.CalendarMonth,
	d.CalendarMonthLabel,
	pc.ProductCategoryKey,
	pc.ProductCategoryName;