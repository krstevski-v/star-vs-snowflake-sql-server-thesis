USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 1 Snowflake Query 1: Total Sales and Quantity by Product Subcategory

SELECT 
	ps.ProductSubcategoryKey,
	ps.ProductSubcategoryName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM
	snowflake.FactSales f 
	INNER JOIN snowflake.DimProduct p 
	ON f.ProductKey = p.ProductKey 
	LEFT JOIN snowflake.DimProductSubcategory ps
	ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
GROUP BY 
	ps.ProductSubcategoryKey,
	ps.ProductSubcategoryName;