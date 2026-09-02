USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 1 Star Query 2: Total Sales and Quantity by Product Category 

SELECT 
	p.ProductCategoryKey,
	p.ProductCategoryName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM
	star.FactSales f 
	INNER JOIN star.DimProduct p 
	ON f.ProductKey = p.ProductKey 
GROUP BY 
	p.ProductCategoryKey,
	p.ProductCategoryName;
