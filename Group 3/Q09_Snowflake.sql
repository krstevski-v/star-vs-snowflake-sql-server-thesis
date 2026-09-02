USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 3 Snowflake 2: Geography Ranking by Monthly Sales for 2008

WITH MonthlyGeographySales AS (
	SELECT
		d.CalendarYear,
		d.CalendarMonth,
		d.CalendarMonthLabel,
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
		d.CalendarYear,
		d.CalendarMonth,
		d.CalendarMonthLabel,
		g.GeographyKey,
		g.ContinentName,
		g.RegionCountryName,
		g.StateProvinceName,
		g.CityName
)

SELECT
	CalendarYear,
	CalendarMonth,
	CalendarMonthLabel,
	GeographyKey,
	ContinentName,
	RegionCountryName,
	StateProvinceName,
	CityName,
	TotalAmount,
	TotalQuantity,
	ROW_NUMBER() OVER (PARTITION BY CalendarYear, CalendarMonth ORDER BY TotalAmount DESC, GeographyKey ASC) AS GeographyRank
FROM MonthlyGeographySales;