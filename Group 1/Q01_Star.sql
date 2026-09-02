USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- Group 1 Star Query 1: Total Sales and Quantity by Product Subcategory

SELECT 
	p.ProductSubcategoryKey,
	p.ProductSubcategoryName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM
	star.FactSales f 
	INNER JOIN star.DimProduct p 
	ON f.ProductKey = p.ProductKey 
GROUP BY 
	p.ProductSubcategoryKey,
	p.ProductSubcategoryName;