-------AVERAGE CUSTOMER LOOK LIKE------

SELECT *
FROM (
	SELECT Count (YEAR_QUERY) AS NUM_YEAR, (2014 - YEAR_QUERY) as Age
	FROM 
		(SELECT (YEAR (CAST (Year_birth as date))) as YEAR_QUERY
		FROM dbo.marketing_campaign_1) SUB1
	GROUP BY YEAR_QUERY) SUB
ORDER BY Age DESC

------- HOW MANY CUSTOMER EACH MARITAL STATUS-------

SELECT Count (Marital), Marital
FROM (
	SELECT Marital_repalce, REPLACE(REPLACE(Marital_repalce,'together','Coupled'),'married','Coupled') as Marital
	FROM (
		SELECT Marital_status, REPLACE(REPLACE(REPLACE (Marital_status,'divorced', 'Single'),'Alone','Single'),'Widow','Single') as Marital_repalce
		FROM dbo.marketing ) sub1) sub2
WHERE Marital In ('Coupled','Single')
GROUP BY Marital

------MINOR OF CUSTOMER -------

SELECT COUNT (ID) as Num_customer, CHILD
FROM (
	SELECT ID, SUM (Kidhome + Teenhome) AS CHILD
	FROM dbo.marketing
	GROUP BY ID) SUB
GROUP BY CHILD

------- HOW MANY CUSTOMER EACH EDUCATION STATUS-------

SELECT DISTINCT Education, Count (ID) as Amount
FROM dbo.marketing
GROUP BY Education

-------REMOVE INCOME IS NULL------

SELECT CAST (Income AS int)
FROM dbo.marketing
WHERE Income != 0
ORDER BY Income DESC

-------REMOVE OUTLINERS OF INCOME-------

DECLARE @StdDev INT
DECLARE @Avg INT

SELECT
@StdDev = STDEV (Cast (Income as Int)),
@Avg = AVG (Cast (Income as Int))
FROM dbo.marketing

SELECT *
FROM (
	SELECT CAST (income as int) as Income
	FROM dbo.marketing
) sub_1
WHERE 
   Income > @Avg - 3*@StdDev AND
   Income < @Avg + 3*@StdDev
 ORDER BY Cast (Income as Int) ASC

-------PEAK OF ENROLLMENT------


SELECT Count (DATE_ENROLL), DATE_ENROLL
FROM (
	SELECT LEFT (Dt_customer, 7) AS DATE_ENROLL
	FROM DBO.marketing) SUB
GROUP BY DATE_ENROLL
ORDER BY DATE_ENROLL


---------WHAT PRODUCT AND CHANNELS OF REVENUE ARE BEST PERFORMING-------
------------THE TOTAL REVENUE OF REVENUE FROM EACH OF PRODUCTS---------
SELECT SUM (MntWines) AS MNT_WINES,
		SUM (Mntfishproducts) AS MNT_FISH,
		SUM (MntFruits) AS MNT_FRUITS,
		SUM (Mntmeatproducts) AS MNT_MEAT,
		SUM (MntsweetProducts) AS MNT_SWEET, 
		SUM (Mntgoldprods) AS MNT_GOLD
FROM dbo.marketing

------THE TOTAL QUANTITY OF PURCHASES FROM EACH OF THE CHANNELS-------
SELECT SUM (NumCatalogPurchases) AS NumCatalogPurchases,
		SUM (NumWebPurchases ) AS NumWebPurchases ,
		SUM (NumStorePurchases) AS NumStorePurchases
FROM dbo.marketing


--------ACCEPTED CAMPAIGN-------

SELECT SUM (AcceptedCmp1) AcceptedCmp1 ,
	SUM (AcceptedCmp2) AcceptedCmp2, 
	SUM (AcceptedCmp3) AcceptedCmp3, 
	SUM (AcceptedCmp4) AcceptedCmp4, 
	SUM (AcceptedCmp5) AcceptedCmp5, 
	SUM (Response) Accepted_Last_Cmp
FROM dbo.acceptedcampaign
