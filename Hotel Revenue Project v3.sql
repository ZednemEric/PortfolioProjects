
With hotels as (
Select * from [dbo].['2018$']
Union
Select * from [dbo].['2019$']
Union
Select * from [dbo].['2020$'])

/* -- exploring the yearly sales trend

select 
arrival_date_year,
hotel, 
round(sum(stays_in_week_nights+stays_in_weekend_nights)*adr),2) as revenue
from hotels 
group by arrival_date_year, hotel */

Select * from hotels 
left join market_segment$
on hotels.market_segment = market_segment$.market_segment
left join 
dbo.meal_cost$
on meal_cost$.meal = hotels.meal