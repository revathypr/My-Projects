-- Start --

USE churn;


-- Data Cleaning --
-- Handling Missing Values and Outliers: --
/*   1.Impute mean for the following columns, and round off to the nearest integer if required:
 WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear, DaySinceLastOrder.
 */
 
 SET SQL_SAFE_UPDATES = 0;
 
 --  WarehouseToHome --
 
UPDATE customer_churn
SET WarehouseToHome = (
  SELECT * FROM (SELECT ROUND(AVG(WarehouseToHome)) FROM customer_churn WHERE WarehouseToHome IS NOT NULL) 
  AS temp_mean
)
WHERE WarehouseToHome IS NULL;

-- HourSpendOnApp --

UPDATE customer_churn
SET HourSpendOnApp = (
  SELECT * FROM (SELECT ROUND(AVG(HourSpendOnApp)) FROM customer_churn WHERE HourSpendOnApp IS NOT NULL) 
  AS temp_mean
)
WHERE HourSpendOnApp IS NULL;

-- OrderAmountHikeFromlastYear -- 

UPDATE customer_churn
SET OrderAmountHikeFromlastYear = (
 SELECT * FROM (SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) FROM Customer_churn WHERE OrderAmountHikeFromlastYear IS NOT NULL)
  AS temp_mean
  )
  WHERE OrderAmountHikeFromlastYear IS NULL;
 
 -- DaySinceLastOrder --

UPDATE customer_churn
SET DaySinceLastOrder = (
 SELECT * FROM (SELECT ROUND(AVG(DaySinceLastOrder)) FROM Customer_churn WHERE DaySinceLastOrder IS NOT NULL)
  AS temp_mean
  )
  WHERE DaySinceLastOrder IS NULL;
  
  /* 2.Impute mode for the following columns: Tenure, CouponUsed, OrderCount */
  
-- Tenure --

 -- Find the mode --
  SET @mode_val = (SELECT Tenure FROM customer_churn
                 WHERE Tenure IS NOT NULL GROUP BY Tenure ORDER BY count(*) DESC LIMIT 1 );
 SELECT @mode_val;
 
 -- Update the mode value --
 UPDATE customer_churn
 SET Tenure = @mode_val
 WHERE Tenure IS NULL;

 -- CouponUsed--
 SET @mode_val = (SELECT CouponUsed FROM customer_churn
                 WHERE CouponUsed IS NOT NULL GROUP BY CouponUsed ORDER BY count(*) DESC LIMIT 1 );
 SELECT @mode_val;
 
 -- Update the mode value --
 UPDATE customer_churn
 SET CouponUsed = @mode_val
 WHERE CouponUsed IS NULL;
 
 -- OrderCount --
 
 SET @mode_val = (SELECT OrderCount FROM customer_churn
                 WHERE OrderCount IS NOT NULL GROUP BY OrderCount ORDER BY count(*) DESC LIMIT 1 );
 SELECT @mode_val;
 
 -- Update the mode value --
 UPDATE customer_churn
 SET OrderCount = @mode_val
 WHERE OrderCount IS NULL;

/* 3.Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100. */

DELETE FROM customer_churn
WHERE WarehouseToHome > 100;

 -- Dealing with Inconsistencies:
 /* 4. Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and 
 “Mobile” in the 'PreferedOrderCat' column with “Mobile Phone” to ensure uniformity. */
 
 -- Replace "Phone" in PreferredLoginDevice with "Mobile Phone" 
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

SELECT DISTINCT PreferredLoginDevice FROM customer_churn;

-- Replace "Mobile" in PreferedOrderCat with "Mobile Phone"
UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

SELECT DISTINCT PreferedOrderCat FROM customer_churn;

/* 5.Standardize payment mode values: Replace "COD" with "Cash on Delivery" and 
"CC" with "Credit Card" in the PreferredPaymentMode column. */

-- Replace 'COD' with 'Cash on Delivery'
UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

-- Replace 'CC' with 'Credit Card'
UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

SELECT DISTINCT PreferredPaymentMode FROM customer_churn;

--------------------------------------------------------------------------------------------------------------------------

-- Data Transformation: --
 
 -- 1.Column Renaming:
 -- a.Rename the column "PreferedOrderCat" to "PreferredOrderCat".
 
 ALTER TABLE customer_churn
 RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;
 
 -- b.Rename the column "HourSpendOnApp" to "HoursSpentOnApp". --
 
 ALTER TABLE customer_churn
 RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;
 
 -- 2.Creating New Columns:
 /* a.Create a new column named ‘ComplaintReceived’ with values "Yes" if the corresponding value in the ‘Complain’
    is 1, and "No" otherwise. */
 
 ALTER TABLE customer_churn
 ADD COLUMN ComplaintReceived VARCHAR(50);
 
 UPDATE customer_churn
 SET ComplaintReceived =  IF(Complain=1,'Yes','No');
 
 /* b.Create a new column named 'ChurnStatus'. Set its value to “Churned” if the corresponding value
 in the 'Churn' column is 1, else assign “Active” */
 
 ALTER TABLE customer_churn
 ADD COLUMN ChurnStatus VARCHAR(20);
 
 UPDATE customer_churn
 SET ChurnStatus = IF(Churn=1,"Churned","Active");
 
 -- 3.Column Dropping: --
-- Drop the columns "Churn" and "Complain" from the table.
ALTER TABLE customer_churn
DROP COLUMN Churn,
DROP COLUMN Complain;

----------------------------------------------------------------------------------------------------------------------


