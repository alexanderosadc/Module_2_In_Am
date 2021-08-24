USE ACDB;

SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[pack_id], [packages].[speed] 
FROM [customers] 
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id];

SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[pack_id] AS packNumber, [packages].[speed] 
FROM [customers] 
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id] 
WHERE [packages].[pack_id] = 22 OR [packages].[pack_id] = 27;

SELECT [packages].[pack_id], [packages].[speed], [packages].[monthly_payment], [sectors].[sector_name]
FROM [packages] INNER JOIN [sectors] ON [packages].[sector_id] = [sectors].[sector_id];

SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[speed], [packages].[monthly_payment],
		[sectors].[sector_name]
FROM [customers] 
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
INNER JOIN [sectors] ON [packages].[sector_id] = [sectors].[sector_id];

SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[speed], [packages].[monthly_payment],
		[sectors].[sector_name]
FROM [customers] 
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
INNER JOIN [sectors] ON [packages].[sector_id] = [sectors].[sector_id]
WHERE [sectors].[sector_name] LIKE 'business';

SELECT [customers].[Last_Name], [customers].[First_Name], [customers].[Join_Date],[packages].[pack_id], 
[packages].[speed], [sectors].[sector_name]
FROM [customers] 
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
INNER JOIN [sectors] ON [packages].[sector_id] = [sectors].[sector_id]
WHERE [sectors].[sector_name] LIKE 'private' 
AND [customers].[Join_Date] LIKE '2006%';



SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[speed], [packages].[monthly_payment]
FROM [customers] 
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id];

SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[speed], [packages].[monthly_payment]
FROM [customers] 
LEFT OUTER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id];

SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[speed], [packages].[monthly_payment]
FROM [customers] 
RIGHT OUTER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id];

SELECT [customers].[First_Name], [customers].[Last_Name], [packages].[speed], [packages].[monthly_payment]
FROM [customers] 
FULL OUTER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id];

SELECT [sectors].[sector_name], 
(SELECT COUNT(packages.pack_id) 
FROM packages 
WHERE packages.monthly_payment > 50 
	AND packages.sector_id = sectors.sector_id)
FROM [sectors]