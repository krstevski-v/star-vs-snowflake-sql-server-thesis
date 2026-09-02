USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 2, Snowflake Query 3: Daily Sales and Quantity by Product Category for 2008

SELECT
	d.DateKey,
	d.FullDateLabel,
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
WHERE
	d.CalendarYear = 2008
GROUP BY
	d.DateKey,
	d.FullDateLabel,
	pc.ProductCategoryKey,
	pc.ProductCategoryName;