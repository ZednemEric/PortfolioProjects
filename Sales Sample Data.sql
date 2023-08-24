/****** Script for SelectTopNRows command from SSMS  ******/

-- Inspecting Data -- 
SELECT TOP (1000) [ORDERNUMBER]
      ,[QUANTITYORDERED]
      ,[PRICEEACH]
      ,[ORDERLINENUMBER]
      ,[SALES]
      ,[ORDERDATE]
      ,[STATUS]
      ,[QTR_ID]
      ,[MONTH_ID]
      ,[YEAR_ID]
      ,[PRODUCTLINE]
      ,[MSRP]
      ,[PRODUCTCODE]
      ,[CUSTOMERNAME]
      ,[PHONE]
      ,[ADDRESSLINE1]
      ,[ADDRESSLINE2]
      ,[CITY]
      ,[STATE]
      ,[POSTALCODE]
      ,[COUNTRY]
      ,[TERRITORY]
      ,[CONTACTLASTNAME]
      ,[CONTACTFIRSTNAME]
      ,[DEALSIZE]
  FROM [Portfolio Project ].[dbo].[sales_data_sample]

  -- Checking Unique Values
select distinct STATUS from [dbo].[sales_data_sample] -- NICE TO PLOT IN TABLEAU
select distinct YEAR_ID from [dbo].[sales_data_sample]
select distinct PRODUCTLINE froM [dbo].[sales_data_sample]-- NICE TO PLOT
select distinct COUNTRY from [dbo].[sales_data_sample] -- NICE TO PLOT
select distinct DEALSIZE from [dbo].[sales_data_sample]-- NICE TO PLOT
select distinct TERRITORY from [dbo].[sales_data_sample]-- NICE TO PLOT

select distinct MONTH_ID from [dbo].[sales_data_sample]
WHERE YEAR_ID = 2005 -- shows that they only operated for 5 months in 2005, this explains the lower revenue for 2005


-- ANALYSIS 
--Let's start by grouping sales by productline

Select PRODUCTLINE, sum(sales) Revenue
from dbo.sales_data_sample
group by PRODUCTLINE
ORDER BY 2 desc

Select YEAR_ID, sum(sales) Revenue
from dbo.sales_data_sample
group by YEAR_ID
ORDER BY 2 desc

select DEALSIZE, sum(sales) Revenue
from [dbo].[sales_data_sample]
group by DEALSIZE
order by 2 desc

-- what was the best month for sales in a specific year? how much was earned that month? 

select month_id, sum(sales) Revenue, Count(ordernumber) Frequency
from [dbo].[sales_data_sample]
WHERE YEAR_ID = 2003 -- CHANGE TO SEE THE REST
group by MONTH_ID
order by 2 DESC

-- It seems as if november is the best month. Let's see what the most popular products are in november

select month_id, productline, sum(sales) Revenue, Count(ordernumber) Frequency
from [dbo].[sales_data_sample]
WHERE YEAR_ID = 2003 AND MONTH_ID = 11-- CHANGE TO SEE THE REST
group by MONTH_ID, PRODUCTLINE
order by 3 DESC

-- who is our best customer (this could be best answered by RFM)
DROP TABLE IF EXISTS #rfm
;with rfm as 
(
	select 
		CUSTOMERNAME, 
		sum(sales) MonetaryValue,
		avg(sales) AvgMonetaryValue,
		count(ORDERNUMBER) Frequency,
		max(ORDERDATE) last_order_date,
		(select max(ORDERDATE) from [dbo].[sales_data_sample]) max_order_date,
		DATEDIFF(DD, max(ORDERDATE), (select max(ORDERDATE) from [dbo].[sales_data_sample])) Recency
	from [Portfolio Project ].[dbo].[sales_data_sample]
	group by CUSTOMERNAME
),
rfm_calc as
(

	select r.*,
		NTILE(4) OVER (order by Recency desc) rfm_recency,
		NTILE(4) OVER (order by Frequency) rfm_frequency,
		NTILE(4) OVER (order by MonetaryValue) rfm_monetary
	from rfm r
)
select 
	c.*, rfm_recency+ rfm_frequency+ rfm_monetary as rfm_cell,
	cast(rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_monetary  as varchar)rfm_cell_string
into #rfm
from rfm_calc c

select CUSTOMERNAME , rfm_recency, rfm_frequency, rfm_monetary,
	case 
		when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
		when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven�t purchased lately) slipping away
		when rfm_cell_string in (311, 411, 331) then 'new customers'
		when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
		when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
		when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
	end rfm_segment

from #rfm
-- What products are most often sold together?
--select * from [dbo].[sales_data_sample] where ORDERNUMBER =  10411

select distinct OrderNumber, stuff(

	(select ',' + PRODUCTCODE
	from [dbo].[sales_data_sample] p
	where ORDERNUMBER in 
		(

			select ORDERNUMBER
			from (
				select ORDERNUMBER, count(*) rn
				FROM [Portfolio Project ].[dbo].[sales_data_sample]
				where STATUS = 'Shipped'
				group by ORDERNUMBER
			)m
			where rn = 3
		)
		and p.ORDERNUMBER = s.ORDERNUMBER
		for xml path (''))

		, 1, 1, '') ProductCodes

from [dbo].[sales_data_sample] s
order by 2 desc


---EXTRAs----
--What city has the highest number of sales in a specific country
select city, sum (sales) Revenue
from [Portfolio Project ].[dbo].[sales_data_sample]
where country = 'UK'
group by city
order by 2 desc



---What is the best product in United States?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from [Portfolio Project ].[dbo].[sales_data_sample]
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc
