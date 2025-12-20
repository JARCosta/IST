

IF OBJECT_ID ('Energy.energy', 'view') IS NOT NULL
   DROP VIEW Energy.energy;
GO
CREATE VIEW Energy.energy WITH SCHEMABINDING AS
	SELECT [DistrictMunicipalityParishCode],
		[District],
		[Municipality],
		[Parish],
		SUM([ActiveEnergy]) AS [ActiveEnergy],
		COUNT_BIG(*) AS COUNT
	FROM [Energy].[MonthlyConsumption]
	GROUP BY [DistrictMunicipalityParishCode],
		[District],
		[Municipality],
		[Parish];
GO
CREATE UNIQUE CLUSTERED INDEX IX_DistrictMunicipalityParishCode
   ON Energy.energy (DistrictMunicipalityParishCode);
GO


IF OBJECT_ID ('Energy.contracts', 'view') IS NOT NULL
   DROP VIEW Energy.contracts;
GO
CREATE VIEW Energy.contracts WITH SCHEMABINDING AS
	SELECT [DistrictMunicipalityParishCode],
		[District],
		[Municipality],
		[Parish],
		SUM([NumberContracts]) AS [NumberContracts],
		COUNT_BIG(*) AS COUNT
	FROM [Energy].[ActiveContracts]
	GROUP BY [DistrictMunicipalityParishCode],
		[District],
		[Municipality],
		[Parish];
GO
CREATE UNIQUE CLUSTERED INDEX IX_DistrictMunicipalityParishCode
   ON Energy.contracts (DistrictMunicipalityParishCode);
GO


SELECT [Energy].[DistrictMunicipalityParishCode],
	[Energy].[District],
	[Energy].[Municipality],
	[Energy].[Parish],
	[Energy].[ActiveEnergy],
	[Contracts].[NumberContracts],
	[Energy].[ActiveEnergy] / [Contracts].[NumberContracts] AS EnergyPerContract
FROM Energy.energy as [Energy], Energy.contracts as [Contracts]
WHERE [Energy].[DistrictMunicipalityParishCode] =
	[Contracts].[DistrictMunicipalityParishCode]
ORDER BY [Energy].[District],
	[Energy].[Municipality],
	[Energy].[Parish]

OPTION (LOOP JOIN) /*27.6459*/
OPTION (MERGE JOIN)/*579.201*/
OPTION (HASH JOIN) /*518.119*/

/* OPTION (LOOP JOIN, MERGE JOIN, HASH JOIN) */
/*			27.6459		579.201		518.119*/
