USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Baseline Star: Total Sales and Quantity by Promotion and Channel


SELECT
	c.ChannelKey,
	c.ChannelName,
	pr.PromotionKey,
	pr.PromotionName,
	CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
	SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
FROM 
	star.FactSales f
	INNER JOIN star.DimPromotion pr
	ON f.PromotionKey = pr.PromotionKey
	INNER JOIN star.DimChannel c
	ON f.Channelkey = c.ChannelKey
GROUP BY
	c.ChannelKey,
	c.ChannelName,
	pr.PromotionKey,
	pr.PromotionName;