USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 3 Snowflake 4: 7-day Rolling Average by Geography for 2008

WITH DailyGeographySales AS (
	SELECT
		d.DateKey,
		d.FullDateLabel,
		g.GeographyKey,
		g.ContinentName,
		g.RegionCountryName,
		g.StateProvinceName,
		g.CityName,
		CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
		SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
	FROM
		snowflake.FactSales f
		INNER JOIN snowflake.DimDate d
			ON f.DateKey = d.DateKey
		INNER JOIN snowflake.DimStore s
			ON f.StoreKey = s.StoreKey
		LEFT JOIN snowflake.DimGeography g
			ON s.GeographyKey = g.GeographyKey
	WHERE 
		d.CalendarYear = 2008
	GROUP BY
		d.DateKey,
		d.FullDateLabel,
		g.GeographyKey,
		g.ContinentName,
		g.RegionCountryName,
		g.StateProvinceName,
		g.CityName
)

SELECT
	DateKey,
	FullDateLabel,
	GeographyKey,
	ContinentName,
	RegionCountryName,
	StateProvinceName,
	CityName,
	TotalAmount,
	TotalQuantity,
	CAST(
		AVG(TotalAmount) OVER (PARTITION BY GeographyKey ORDER BY DateKey ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
		AS DECIMAL(19,4)
	) AS RollingAvgAmount,
	CAST(
		AVG(CAST(TotalQuantity AS DECIMAL(19,4))) OVER (PARTITION BY GeographyKey ORDER BY DateKey ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
		AS DECIMAL(19,4)
	) AS RollingAvgQuantity
FROM DailyGeographySales