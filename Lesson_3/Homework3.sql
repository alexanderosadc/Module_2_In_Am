USE ACDB;

SELECT COUNT(customers.Customer_Id) AS [NrOfCustomers], [packages].[speed]
FROM [customers] 
INNER JOIN packages ON customers.pack_id = packages.pack_id
GROUP BY [packages].[speed];

SELECT [packages].[speed], COUNT([customers].[Customer_Id]) AS [userNumbers]
FROM [customers]
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
GROUP BY [packages].[speed]
HAVING [packages].[speed] LIKE '10%'
ORDER BY [packages].[speed];

CREATE TABLE PerspectiveCustomers
(
	[Id] INT NOT NULL IDENTITY(1, 1),
	[First_Name] NVARCHAR(30),
	[Last_Name] NVARCHAR(30),
	[main_phone_num] NVARCHAR(30), 
	[monthly_payment] NVARCHAR(50)
);

INSERT INTO PerspectiveCustomers ([customers].[First_Name], [customers].[Last_Name], 
									[customers].[main_phone_num], [packages].[monthly_payment])
SELECT [customers].[First_Name], [customers].[Last_Name], 
		[customers].[main_phone_num], [packages].[monthly_payment]
FROM [customers] 
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
WHERE [packages].[monthly_payment] = (SELECT MAX([packages].[monthly_payment]) FROM [packages]);

TRUNCATE TABLE [PerspectiveCustomers];

DELETE [customers]
FROM [customers]
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
WHERE [packages].[monthly_payment] < 30;

UPDATE [packages]
	SET [packages].[monthly_payment] = [packages].[monthly_payment] + 20
FROM [customers]
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
WHERE [customers].[City] = 'Chisinau';

MERGE INTO [PerspectiveCustomers] AS PcTarget
USING [customers] AS CustSource
ON [PcTarget].[Id] = [CustSource].[Customer_Id]
WHEN MATCHED
	THEN UPDATE SET [PcTarget].[Last_Name] = [CustSource].[Last_Name]
WHEN NOT MATCHED BY TARGET
	THEN INSERT ([First_Name], [Last_Name]) VALUES ('default', 'default')
WHEN NOT MATCHED BY SOURCE
	THEN DELETE;