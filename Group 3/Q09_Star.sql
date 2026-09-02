USE ContosoRetailDW;
GO

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

GO

-- Group 3 Star 2: Geography Ranking by Monthly Sales for 2008

WITH MonthlyGeographySales AS (
	SELECT
		d.CalendarYear,
		d.CalendarMonth,
		d.CalendarMonthLabel,
		s.GeographyKey,
		s.ContinentName,
		s.RegionCountryName,
		s.StateProvinceName,
		s.CityName,
		CAST(SUM(f.SalesAmount) AS DECIMAL(19,4)) AS TotalAmount,
		SUM(CAST(f.SalesQuantity AS BIGINT)) AS TotalQuantity
	FROM
		star.FactSales f
		INNER JOIN star.DimDate d
			ON f.DateKey = d.DateKey
		INNER JOIN star.DimStore s
			ON f.StoreKey = s.StoreKey
	WHERE 
		d.CalendarYear = 2008
	GROUP BY
		d.CalendarYear,
		d.CalendarMonth,
		d.CalendarMonthLabel,
		s.GeographyKey,
		s.ContinentName,
		s.RegionCountryName,
		s.StateProvinceName,
		s.CityName
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