USE ContosoRetailDW;
GO

-- Product-based queries
CREATE NONCLUSTERED INDEX IX_star_FactSales_ProductKey
ON star.FactSales (ProductKey)
INCLUDE (SalesAmount, SalesQuantity);

CREATE NONCLUSTERED INDEX IX_snowflake_FactSales_ProductKey
ON snowflake.FactSales (ProductKey)
INCLUDE (SalesAmount, SalesQuantity);
GO


-- Store / Geography-based queries
CREATE NONCLUSTERED INDEX IX_star_FactSales_StoreKey
ON star.FactSales (StoreKey)
INCLUDE (SalesAmount, SalesQuantity);

CREATE NONCLUSTERED INDEX IX_snowflake_FactSales_StoreKey
ON snowflake.FactSales (StoreKey)
INCLUDE (SalesAmount, SalesQuantity);
GO


-- Date + Product queries
CREATE NONCLUSTERED INDEX IX_star_FactSales_DateKey_ProductKey
ON star.FactSales (DateKey, ProductKey)
INCLUDE (SalesAmount, SalesQuantity);

CREATE NONCLUSTERED INDEX IX_snowflake_FactSales_DateKey_ProductKey
ON snowflake.FactSales (DateKey, ProductKey)
INCLUDE (SalesAmount, SalesQuantity);
GO


-- Date + Store / Geography queries
CREATE NONCLUSTERED INDEX IX_star_FactSales_DateKey_StoreKey
ON star.FactSales (DateKey, StoreKey)
INCLUDE (SalesAmount, SalesQuantity);

CREATE NONCLUSTERED INDEX IX_snowflake_FactSales_DateKey_StoreKey
ON snowflake.FactSales (DateKey, StoreKey)
INCLUDE (SalesAmount, SalesQuantity);
GO


-- Combined Product + Geography queries
CREATE NONCLUSTERED INDEX IX_star_FactSales_StoreKey_ProductKey
ON star.FactSales (StoreKey, ProductKey)
INCLUDE (SalesAmount, SalesQuantity);

CREATE NONCLUSTERED INDEX IX_snowflake_FactSales_StoreKey_ProductKey
ON snowflake.FactSales (StoreKey, ProductKey)
INCLUDE (SalesAmount, SalesQuantity);
GO


-- Complex multi-dimension query
CREATE NONCLUSTERED INDEX IX_star_FactSales_Date_Store_Product_Channel_Promotion
ON star.FactSales (DateKey, StoreKey, ProductKey, ChannelKey, PromotionKey)
INCLUDE (SalesAmount, SalesQuantity);

CREATE NONCLUSTERED INDEX IX_snowflake_FactSales_Date_Store_Product_Channel_Promotion
ON snowflake.FactSales (DateKey, StoreKey, ProductKey, ChannelKey, PromotionKey)
INCLUDE (SalesAmount, SalesQuantity);
GO


-- Date filtering / grouping support
CREATE NONCLUSTERED INDEX IX_star_DimDate_CalendarYear_DateKey
ON star.DimDate (CalendarYear, DateKey)
INCLUDE (CalendarMonth, CalendarMonthLabel, FullDateLabel);

CREATE NONCLUSTERED INDEX IX_snowflake_DimDate_CalendarYear_DateKey
ON snowflake.DimDate (CalendarYear, DateKey)
INCLUDE (CalendarMonth, CalendarMonthLabel, FullDateLabel);
GO