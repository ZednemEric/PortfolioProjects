--#1 finding the maximum quantity sold in transaction --
select max(Quantity),
count(*)
from [dbo].[TR_OrderDetails$]s;

--#2 find the DISTINCT products in all the transactions--

Select DISTINCT ProductID, Quantity
FROM [dbo].[TR_OrderDetails$]
WHERE Quantity = 3
order by ProductID asc, Quantity desc;
--#3 Select Unique PropertyIds
Select Distinct
PropertyID
FROM [dbo].[TR_OrderDetails$]

#4
Select ProductCategory, Count(*) as COUNT
FROM [dbo].[TR_Products$]
Group by ProductCategory
Order by 2 DESC;

#5 - What state has the most locations 
Select PropertyState, Count(*) as COUNT
FROM [dbo].[TR_PropertyInfo$]
Group by PropertyState
Order by 2 DESC;
--#6 fint the top 5 product IDs that did the maximum in sales in terms of quantity
Select TOP 5 ProductID, SUM(Quantity) as Total_Sold -- TOP 5 selects top 5 in sql server--
FROM [dbo].[TR_OrderDetails$]
Group By ProductID
Order by 2 desc;
--#7 Find the top 5 property IDs that did maximum quantity--
Select TOP 5 PropertyID, SUM(Quantity) as Total_Sold -- TOP 5 selects top 5 in sql server--
FROM [dbo].[TR_OrderDetails$]
Group By PropertyID
Order by 2 DESC; -- 2 refers to 2nd column--
-- joining multiple tables --
SELECT p.ProductName,
p.ProductCategory,
p.Price,
o.*
From [dbo].[TR_OrderDetails$] as o
LEFT JOIN [dbo].[TR_Products$] as p on o.ProductID = p.ProductID;

--find the top 5 products that did maximum quantity--
SELECT p.ProductName,
sum(o.quantity) as Total_Quantity
From [dbo].[TR_OrderDetails$] as o
LEFT JOIN [dbo].[TR_Products$] as p on o.ProductID = p.ProductID
Group by p.ProductName
Order by 2 DESC;

--find the top 5 products that did maximum sales--
SELECT TOP 5
p.ProductName,
sum(o.quantity*p.price) as Sales
From [dbo].[TR_OrderDetails$] as o
LEFT JOIN [dbo].[TR_Products$] as p on o.ProductID = p.ProductID
Group by p.ProductName
Order by 2 DESC;
--find the top 5 Cities that did maximum sales--
SELECT TOP 5
pid.PropertyCity,
sum(o.Quantity*p.price) as Sales
From [dbo].[TR_OrderDetails$] as o
LEFT JOIN [dbo].[TR_Products$] as p on o.ProductID = p.ProductID
LEFT JOIN [dbo].[TR_PropertyInfo$] as pid on o.PropertyID = pid."Prop ID"
Group by pid.PropertyCity
Order by Sales Desc;
-- FInd the top 5 products in each of the cities--
SELECT TOP 5
pid.PropertyCity,
p.ProductName,
sum(o.Quantity*p.price) as Sales
From [dbo].[TR_OrderDetails$] as o
LEFT JOIN [dbo].[TR_Products$] as p on o.ProductID = p.ProductID
LEFT JOIN [dbo].[TR_PropertyInfo$] as pid on o.PropertyID = pid."Prop ID"
Where pid.PropertyCity = 'Arlington'
Group by pid.PropertyCity, p.ProductName
Order by Sales Desc;


