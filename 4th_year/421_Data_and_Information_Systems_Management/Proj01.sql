
BEGIN TRANSACTION;

CREATE PARTITION FUNCTION monthlyConsumptionYears(CHAR(4))  
AS RANGE LEFT FOR VALUES (2020, 2021, 2022, 2023);  

CREATE PARTITION SCHEME monthlyConsumptionYearsPartition
AS PARTITION monthlyConsumptionYears  
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);

ALTER TABLE Energy.MonthlyConsumption DROP CONSTRAINT PK_MonthlyConsumption;

CREATE CLUSTERED INDEX PK_MonthlyConsumption
ON Energy.MonthlyConsumption (Year, Month, DistrictMunicipalityParishCode, VoltageLevel)
ON monthlyConsumptionYearsPartition(Year);

COMMIT TRANSACTION;

/*
SELECT * FROM sys.filegroups

SELECT Year, COUNT(*) FROM Energy.MonthlyConsumption
GROUP BY Year

SELECT * FROM sys.partitions as p
ORDER BY p.rows DESC
*/


SELECT * FROM sys.partitions as p
WHERE 
	p.rows IN (
		SELECT COUNT(*) FROM Energy.MonthlyConsumption
	) OR p.rows IN (
		SELECT COUNT(*) FROM Energy.MonthlyConsumption
		GROUP BY Year
	)
ORDER BY p.rows DESC


