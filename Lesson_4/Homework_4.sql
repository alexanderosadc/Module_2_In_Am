USE ACDB;
-- Calculates average payment per City for internet
SELECT DISTINCT [outsideCustomer].[City],
		(
			SELECT AVG(CAST([insidePackage].[monthly_payment] AS DECIMAL))
			FROM [customers] AS [insideCustomer]
			INNER JOIN [packages] AS [insidePackage]
			ON [insideCustomer].[pack_id] = [insidePackage].[pack_id]
			WHERE [insideCustomer].[City] = [outsideCustomer].[City]
		) AS [averagePayment] 
FROM [customers] AS [outsideCustomer]
ORDER BY [averagePayment] DESC;

-- Inserts into new table all perspective customers - who have maximum payment package for the internet
INSERT INTO PerspectiveCustomers 
		(
			[customers].[First_Name], 
			[customers].[Last_Name], 
			[customers].[main_phone_num], 
			[packages].[monthly_payment]
		)
SELECT		[customers].[First_Name], 
			[customers].[Last_Name], 
			[customers].[main_phone_num], 
			[packages].[monthly_payment]
FROM [customers]
INNER JOIN [packages] ON [customers].[pack_id] = [packages].[pack_id]
WHERE [packages].[monthly_payment] = (SELECT MAX([packages].[monthly_payment]) FROM [packages]);

-- Calculates number of customers per city having payment package > 100 dollars. Orders by number of customers in the city.
SELECT COUNT([outsideCustomers].[Customer_Id]) AS [NumberOfCustomers], [outsideCustomers].[City]
FROM [customers] AS [outsideCustomers]
GROUP BY [outsideCustomers].[City]
HAVING 
(
	SELECT SUM([packages].[monthly_payment])
	FROM [customers] AS [insideCustomer]
	INNER JOIN [packages]
	ON [insideCustomer].[pack_id] = [packages].[pack_id]
	WHERE [insideCustomer].[City] = [outsideCustomers].[City]
) > 100
ORDER BY [NumberOfCustomers] DESC;

-- IN works on single column
-- SELECTS customers whos First Name and Last Name corresponds with customers who are in the Perspective Customer table.
SELECT [customers].[First_Name], [customers].[Last_Name], [customers].[main_phone_num]
FROM [customers] 
WHERE [customers].[First_Name] IN
						(
							SELECT [PerspectiveCustomers].[First_Name]
							FROM [PerspectiveCustomers]
						)
						AND [customers].[Last_Name] IN
						(
							SELECT [PerspectiveCustomers].[Last_Name]
							FROM [PerspectiveCustomers]
						);

-- EXISTS can work with multiple columns
-- SELECTS customers who are present in the Perspective Customer table and in customers table. Orders by customers by first name
SELECT [customers].[First_Name], [customers].[Last_Name], [customers].[main_phone_num]
FROM [customers] 
WHERE EXISTS
			(
				SELECT [PerspectiveCustomers].[First_Name], [PerspectiveCustomers].[Last_Name]
				FROM [PerspectiveCustomers]
				WHERE [PerspectiveCustomers].[Id] = [customers].[Customer_Id]
			)
ORDER BY [customers].[First_Name];

-- Selects customers who are present in the perspective customers and telephone starrts with 548. 
-- if in the customer table if at least one number starts with 548 returns the result
SELECT [PerspectiveCustomers].[First_Name], [PerspectiveCustomers].[Last_Name], [PerspectiveCustomers].[main_phone_num]
FROM [PerspectiveCustomers] 
WHERE [PerspectiveCustomers].[main_phone_num] = ANY
			(
				SELECT [customers].[main_phone_num]
				FROM [customers] 
				WHERE [customers].[main_phone_num] LIKE '548%'
			)
ORDER BY [PerspectiveCustomers].[First_Name];

-- Selects customers who are present in the perspective customers and telephone starrts with 548. 
-- if all customers main phone number have 548 returns true
SELECT [PerspectiveCustomers].[First_Name], [PerspectiveCustomers].[Last_Name], [PerspectiveCustomers].[main_phone_num]
FROM [PerspectiveCustomers] 
WHERE [PerspectiveCustomers].[main_phone_num] = ALL
			(
				SELECT [customers].[main_phone_num]
				FROM [customers] 
				WHERE [customers].[main_phone_num] LIKE '548%'
			)
ORDER BY [PerspectiveCustomers].[First_Name];


-- Selects customers who are present in the perspective customers and telephone starrts with 548. 
-- if all Perspective customers main phone number has digits
SELECT [customers].[First_Name], [customers].[Last_Name], [customers].[main_phone_num]
FROM [customers] 
WHERE [customers].[main_phone_num] = ALL
			(
				SELECT [PerspectiveCustomers].[main_phone_num]
				FROM [PerspectiveCustomers] 
				WHERE [PerspectiveCustomers].[main_phone_num] NOT LIKE  '%[^0-9]%'
			)
ORDER BY [customers].[First_Name];

SELECT [customers].[City], [customers].[First_Name], [customers].[Last_Name],
CASE [customers].[City]
		WHEN 'Phoenix' THEN CONCAT('+373.', [customers].[main_phone_num])
		WHEN 'Seattle' THEN CONCAT('+380.', [customers].[main_phone_num])
		ELSE [customers].[main_phone_num]
		END AS PhoneNumbersWithCode	
FROM [customers]