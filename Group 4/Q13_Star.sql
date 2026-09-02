USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 4 Star 2: Total Sales by Year, Product Category, Product Subcategory, Geography, Promotion and Channel


SELECT
	d.CalendarYear,
	p.ProductCategoryName,
	p.ProductSubcategoryName,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName,
	c.ChannelName,
	pr.PromotionName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM 
	star.FactSales f
	INNER JOIN star.DimDate d
	ON f.DateKey = d.DateKey
	INNER JOIN star.DimProduct p
	ON f.ProductKey = p.ProductKey
	INNER JOIN star.DimStore s
	ON f.StoreKey = s.StoreKey
	INNER JOIN star.DimChannel c
	ON f.Channelkey = c.ChannelKey
	INNER JOIN star.DimPromotion pr
	ON f.PromotionKey = pr.PromotionKey
GROUP BY
	d.CalendarYear,
	p.ProductCategoryKey,
	p.ProductCategoryName,
	p.ProductSubcategoryKey,
	p.ProductSubcategoryName,
	s.GeographyKey,
	s.ContinentName,
	s.RegionCountryName,
	s.StateProvinceName,
	s.CityName,
	c.ChannelKey,
	c.ChannelName,
	pr.PromotionKey,
	pr.PromotionName;