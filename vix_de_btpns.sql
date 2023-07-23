CREATE TABLE customers_data AS 
	SELECT cdh.*, cd.Card_Category, ed.Education_Level, md.Marital_Status, sd.status  from customer_data_history cdh
	LEFT JOIN category_db cd ON cdh.card_categoryid = cd.id 
	LEFT JOIN education_db ed ON cdh.Educationid = ed.id 
	LEFT JOIN marital_db md ON cdh.Maritalid = md.id 
	LEFT JOIN status_db sd ON cdh.idstatus = sd.id 
	
--set foreign key 
ALTER TABLE customer_data_history ADD FOREIGN KEY (card_categoryid)
REFERENCES category_db(id)
	
SELECT *FROM customers_data cd  LIMIT 5

-- total of customers
SELECT COUNT(*) FROM customers_data cd 

-- number of customers based on their status 
SELECT status, COUNT(status) as cnt_customer, ROUND (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_cust_status
FROM customers_data cd 
GROUP BY status 
ORDER BY status DESC 


-- CTE card category  
WITH card_cat AS (
	SELECT Card_Category, status, COUNT(Card_Category) as cnt_category
	FROM customers_data
	GROUP BY 1, 2  
	ORDER BY 2  DESC 
)
SELECT *FROM card_cat


-- total card_category with status = existing customer
select Card_Category, count (card_category) tot_card from customers_data cd 
WHERE status = 'Existing Customer'
GROUP BY Card_Category 
ORDER BY tot_card DESC  

-- total card_category with status = attrited customer
select Card_Category, count (card_category) tot_card from customers_data cd 
WHERE status = 'Attrited Customer'
GROUP BY Card_Category 
ORDER BY tot_card DESC  

-- number of customers based on their gender 
SELECT Gender , status, COUNT(Gender) cust_by_gender from customers_data cd 
GROUP BY 1,2  
ORDER BY 3  DESC


-- number of customers based on their gender and status = existing customer
SELECT Gender , COUNT(Gender) cust_by_gender from customers_data cd 
WHERE status = 'Existing Customer'
GROUP BY Gender  
ORDER BY Gender  DESC


-- number of customers based on their gender and status = Attrited customer
SELECT Gender , COUNT(Gender) cust_by_gender from customers_data cd 
WHERE status = 'Attrited Customer'
GROUP BY Gender  
ORDER BY cust_by_gender  DESC



-- number of customers based on their marital status and status 
SELECT Marital_Status, status,  COUNT(Marital_Status) cust_by_marital from customers_data cd 
GROUP BY 1,2  
ORDER BY 3  DESC

-- number of customers based on their marital status and status = existing customer
SELECT Marital_Status  , COUNT(Marital_Status) cust_by_marital from customers_data cd 
WHERE status = 'Existing Customer'
GROUP BY Marital_Status  
ORDER BY cust_by_marital  DESC


-- number of customers based on their marital status and status = attrited customer
SELECT Marital_Status  , COUNT(Marital_Status) cust_by_marital from customers_data cd 
WHERE status = 'Attrited Customer'
GROUP BY Marital_Status  
ORDER BY cust_by_marital  DESC

-- number of customers based on their education
SELECT Education_Level , status , COUNT(Education_Level) cust_by_edu from customers_data cd 
GROUP BY 1,2   
ORDER BY 3  DESC

-- number of customers based on their education status and status = existing customer
SELECT Education_Level  , COUNT(Education_Level) cust_by_edu from customers_data cd 
WHERE status = 'Existing Customer'
GROUP BY Education_Level  
ORDER BY cust_by_edu  DESC

-- number of customers based on their education status and status = attrited customer
SELECT Education_Level  , COUNT(Education_Level) cust_by_edu from customers_data cd 
WHERE status = 'Attrited Customer'
GROUP BY Education_Level  
ORDER BY cust_by_edu  DESC

-- number of customers based on income
SELECT Income_Category, COUNT(Income_Category) tot_cust FROM customers_data cd 
GROUP BY 1 
ORDER BY 2 DESC


-- number of customers based on income and status = existing customer
SELECT Income_Category, status, COUNT(Income_Category) tot_cust_exst FROM customers_data cd 
WHERE status ='Existing Customer'
GROUP BY 1,2 
ORDER BY 3 DESC

-- number of customers based on income and status = attrited customer
SELECT Income_Category, status, COUNT(Income_Category) tot_cust_att FROM customers_data cd 
WHERE status ='Attrited Customer'
GROUP BY 1 
ORDER BY 3 DESC


SELECT Customer_Age, COUNT(ClientNum) tot_age_cust from customers_data cd 
GROUP BY Customer_Age 
ORDER BY Customer_Age  ASC




-- customer based on age. <30 = twenty, <40 = thirty, <50 = forty, <60 = fifty, <70 = sixty, else seventy
WITH age_segmentation AS (
	SELECT *, CASE WHEN Customer_Age < 30 THEN 'Twenty'
					WHEN Customer_Age < 40 THEN 'Thirty'
					WHEN Customer_Age < 50 THEN 'Forty'
					WHEN Customer_Age < 60 THEN 'Fifty'
					WHEN Customer_Age < 70 THEN 'Sixty'
					ELSE 'Seventy'
				END AS age_group
	FROM customers_data
)

--SELECT *FROM age_segmentation

--SELECT age_group, COUNT(age_group) tot_group_age  FROM age_Segmentation
--GROUP BY 1
--ORDER BY 2 DESC  


--SELECT age_group, COUNT(age_group) tot_group_age  FROM Segmentation
--GROUP BY age_group 
--ORDER BY tot_group_age DESC 

SELECT age_group, status, COUNT(age_group) tot_group_age  FROM age_segmentation
WHERE status = 'Attrited Customer'
GROUP BY 1
ORDER BY 3 DESC 

-- Income based on age
SELECT Income_Category, age_group, COUNT(age_group) AS cnt_age 
FROM  age_segmentation
GROUP BY age_group
Order By cnt_age DESC




-- income based on age and status
SELECT Income_Category, age_group, COUNT(age_group) AS cnt_age 
FROM  Segmentation
WHERE status = 'Attrited Customer'
GROUP BY 2
Order By 3 DESC


SELECT month_book_group, status, COUNT(month_book_group) cnt_month FROM month_book_segmentation 
WHERE status = 'Attrited Customer'
GROUP BY 2,1
ORDER BY 3 DESC 

SELECT Months_Inactive_12_mon, COUNT(Months_Inactive_12_mon) FROM customers_data cd 
WHERE status = 'Attrited Customer'
GROUP BY Months_Inactive_12_mon


WITH month_book_segmentation AS (
	SELECT *, 
			CASE WHEN Months_on_book <= 12 THEN 'Less than 1 year'
					WHEN Months_on_book <=24 THEN '1-2 years'
					WHEN Months_on_book <= 36 THEN '2-3 years'
					WHEN Months_on_book <=48 THEN '3-4 years'
				ELSE 'More than 4 years'
				END AS month_book_group
	FROM customers_data
)

-- SELECT *FROM month_book_segmentation

SELECT Income_Category, month_book_group, COUNT(month_book_group) AS cnt_month 
FROM  month_book_segmentation
GROUP BY 1,2
Order By 3 DESC


-- income based on age and status
SELECT Income_Category, age_group, COUNT(age_group) AS cnt_age 
FROM  Segmentation
WHERE status = 'Attrited Customer'
GROUP BY 2
Order By 3 DESC


-- inactive customers in 12 months
SELECT Months_Inactive_12_mon, status, COUNT(Months_Inactive_12_mon) cnt_inactive_mnt FROM customers_data cd 
WHERE status = 'Attrited Customer'
GROUP BY 1,2
ORDER BY 3 DESC

-- contacts customer in 12 months
SELECT Contacts_Count_12_mon, COUNT(Contacts_Count_12_mon) cnt_contact FROM customers_data cd 
GROUP BY 1
ORDER BY 2 DESC 

SELECT Contacts_Count_12_mon, status , COUNT(Contacts_Count_12_mon) cnt_contact FROM customers_data cd 
WHERE status = 'Attrited Customer'
GROUP BY 1,2
ORDER BY 3 DESC 



-- transaction amount
WITH trx_amt AS (
	SELECT status ,Card_Category , MIN(Total_Trans_Amt) min_trx, MAX(Total_Trans_Amt) max_trx, SUM(Total_Trans_Amt) tot_trx, 
	MEDIAN(Total_Trans_Amt) median_trx, AVG(Total_Trans_Amt) avg_trx
	FROM customers_data cd 
	GROUP BY 1,2
	ORDER BY 1
)
SELECT *FROM trx_amt

-- freq transaction 
SELECT Total_Trans_Amt,  Total_Trans_Ct FROM customers_data cd 
WHERE status ='Attrited Customer'
GROUP BY 1,2
ORDER BY 1 DESC

-- freq transaction 
SELECT MIN(Total_Trans_Ct) min_freq, MAX(Total_Trans_Ct) max_freq, SUM(Total_Trans_Ct) tot_freq, 
	MEDIAN(Total_Trans_Ct) median_freq, ROUND(AVG(Total_Trans_Ct) , 2) avg_freq FROM customers_data cd 
--WHERE status ='Attrited Customer'
GROUP BY 1,2
ORDER BY 3 DESC

-- freq transaction
WITH freq_trx AS (
	SELECT  MIN(Total_Trans_Ct) min_freq, MAX(Total_Trans_Ct) max_freq, SUM(Total_Trans_Ct) tot_freq, 
	MEDIAN(Total_Trans_Ct) median_freq, ROUND(AVG(Total_Trans_Ct) , 2) avg_freq
	FROM customers_data cd 
	GROUP BY 1
	ORDER BY 1
)
SELECT *FROM freq_trx


SELECT  DISTINCT Contacts_Count_12_mon  FROM customers_data cd 
SELECT DISTINCT Months_Inactive_12_mon FROM customers_data cd2 