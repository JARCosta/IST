SELECT * FROM [Energy].[MonthlyConsumption]

/*
Since the column Year in used in the primary key clustered index,
it's presence in not necessary in a new index,
it is important to note that the table is already ordered by year due to the clustered index.
Also,
*/

DROP INDEX IF EXISTS IX_Month_Municipality ON Energy.MonthlyConsumption
CREATE NONCLUSTERED INDEX IX_Month_Municipality ON Energy.MonthlyConsumption (Month, Municipality) INCLUDE (ActiveEnergy)

DROP INDEX IF EXISTS IX_Parish_ActiveEnergy ON Energy.MonthlyConsumption
CREATE NONCLUSTERED INDEX IX_Parish_ActiveEnergy ON Energy.MonthlyConsumption (Parish, ActiveEnergy)
DROP INDEX IF EXISTS IX_Parish ON Energy.MonthlyConsumption
CREATE NONCLUSTERED INDEX IX_Parish ON Energy.MonthlyConsumption (Parish)

DROP INDEX IF EXISTS IX_Month_Municipality_Recomended ON Energy.MonthlyConsumption
CREATE NONCLUSTERED INDEX IX_Month_Municipality_Recomended ON Energy.MonthlyConsumption (Month, Municipality) INCLUDE (Parish, ActiveEnergy)

DROP INDEX IF EXISTS IX_Month_Municipality_Parish ON Energy.MonthlyConsumption
CREATE NONCLUSTERED INDEX IX_Month_Municipality_Parish ON Energy.MonthlyConsumption (Month, Municipality, Parish) INCLUDE (ActiveEnergy)

DROP INDEX IF EXISTS IX_Month_Municipality_Parish_NoInc ON Energy.MonthlyConsumption
CREATE NONCLUSTERED INDEX IX_Month_Municipality_Parish_NoInc ON Energy.MonthlyConsumption (Month, Municipality, Parish)


SELECT [Parish], [Year], SUM([ActiveEnergy]) AS [ActiveEnergy]
FROM [Energy].[MonthlyConsumption]
WITH (INDEX(IX_Parish))
WHERE [Municipality] = 'Lisboa'
 AND [Month] = '06'
GROUP BY [Parish], [Year]
ORDER BY [Parish], [Year]


DBCC SHOW_STATISTICS ('Energy.MonthlyConsumption', 'PK_MonthlyConsumption');
DBCC SHOW_STATISTICS ('Energy.MonthlyConsumption', 'IX_Month_Municipality_Recomended');
DBCC SHOW_STATISTICS ('Energy.MonthlyConsumption', 'IX_Month_Municipality_Parish');
