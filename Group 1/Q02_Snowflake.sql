USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 1 Snowflake Query 2: Total Sales and Quantity by Product Category

SELECT 
	pc.ProductCategoryKey,
	pc.ProductCategoryName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM
	snowflake.FactSales f 
	INNER JOIN snowflake.DimProduct p 
	ON f.ProductKey = p.ProductKey 
	LEFT JOIN snowflake.DimProductSubcategory ps
	ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
	LEFT JOIN snowflake.DimProductCategory pc 
	ON ps.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY 
	pc.ProductCategoryKey,
	pc.ProductCategoryName;