use NORTHWND
go

-- KPI's --
-- 1.Net Sales --
CREATE VIEW TotalSales AS
select SUM((UnitPrice * Quantity)*(1-discount)) as Revenue
from [Order Details]

-- 2.Count of Customers--
CREATE VIEW custcount AS
select  count (distinct customerid) as Count_of_Customers
from Customers

-- 3.count of orders --
CREATE VIEW orderscount  AS
select count (distinct orderid) as Count_of_Orders
from orders

-- 4.Avg days to ship the order --
CREATE VIEW shipping_days  AS
SELECT AVG(DATEDIFF(day, orderdate , shippeddate)) as avg_shipping_days
FROM orders


--Revenue report--
--1.Net profit--(adding column with 7% profit margin)
alter table [order details]
add ProfitPerUnit money

UPDATE [order details]
set ProfitPerUnit = (UnitPrice*(1-discount))*0.07
from [order details]

CREATE VIEW netProfit AS
select sum (ProfitPerUnit*Quantity) as Total_net_profit
from [Order Details] 

--2.Total Discounts in $--
CREATE VIEW totalDisc AS
select SUM((UnitPrice * Quantity)*discount) as total_discounts_$
from [Order Details]

--3.Shipping Cost--
CREATE VIEW shippingCost AS
select sum (freight) as total_shipping_cost
from orders

--Customers Report--
--1.avg net sales per customer--
CREATE VIEW avgCustmerSales AS
select sum((unitPrice*quantity)*(1-discount)) / count(customerid) as avg_revenue_per_customer
from [Order Details],Customers

--2.avg profit per customer --
CREATE VIEW avgCustomerProfit  AS
select sum(Profitperunit*quantity) / (count(customerid)) as avg_profit_per_customer
from [Order Details],Customers

--3.avg shipping cost per customer--
CREATE VIEW avgShippingCost AS
select sum(freight) / COUNT(customers.CustomerID) as avg_shippingcost_per_customer
from Orders, Customers

--Products report--
--1.Net profit per order 
CREATE VIEW NetProfitPerOrder AS
select orderId, sum(profitperunit*quantity) as net_profit
from [Order Details]
group by orderid


--2.Shipping cost per order 
CREATE VIEW FreightCostPerOrder AS
select orderId,sum(freight) as freight_cost
from Orders
group by  orderid


--3.Net sales per order 
CREATE VIEW NetSalesPerOrder AS
select orderid, sum((profitperunit/0.07)*quantity) as RevenuePerOrder
from [Order Details]
group by orderid


--4.count of products 
CREATE VIEW ProductsCount AS
select count(distinct productid) as count_of_products
from products

--5.count of categories 
CREATE VIEW CtegoryCount AS
select count(distinct categoryid)as count_of_categories
from categories

--6.percentage of discontinued products and products are selling
CREATE VIEW discontinued_ratio AS
SELECT CAST(SUM(CASE WHEN discontinued = 1 THEN 1 ELSE 0 END) AS Float) / COUNT(productid) 
AS discontinued_ratio
FROM products

--Employee Report
--1.net sales per employee or avg
CREATE VIEW sales_per_Emp AS
select salesperson, sum (extendedprice) as net_sales_per_employee
from invoices
group by salesperson

CREATE VIEW AvgSales_per_Emp AS
select salesperson, avg (extendedprice) as avg_sales_per_employee
from invoices
group by salesperson

--2.count Orders per employee or avg 
CREATE VIEW order_per_emp AS
select salesperson, count (distinct orderid) as orders_per_employee
from invoices
group by salesperson

CREATE VIEW avgOrders_per_emp AS
SELECT AVG(order_count) AS average_orders_per_employee
FROM (SELECT salesperson,COUNT(orderid) AS order_count
        FROM invoices
        GROUP BY salesperson) AS order_counts


--3.count of employees 
CREATE VIEW Emp_Count AS
select count (distinct employeeId)as count_of_employee from Employees 

--4.count of supervisors 
CREATE VIEW SupervisorsCount AS
select count (distinct reportsto) as supervisors 
from employees 


--Shippers Report--
--1.Shipping cost by order 
select * from freightPerOrder


--2.Avg days to ship 
select * from shipping_days

