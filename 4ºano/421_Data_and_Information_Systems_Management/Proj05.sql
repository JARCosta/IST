SELECT [Parish], [Year], SUM([ActiveEnergy]) AS [ActiveEnergy]
FROM [Energy].[MonthlyConsumption]
WHERE [Municipality] = 'Lisboa'
AND [Month] = '06'
GROUP BY [Parish], [Year]
ORDER BY [Parish], [Year]

