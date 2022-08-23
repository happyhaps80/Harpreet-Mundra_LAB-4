CREATE DEFINER=`root`@`localhost` PROCEDURE `service_types`()
BEGIN
SELECT sup.SUPP_ID, sup.SUPP_NAME, avg(suprating.RAT_RATSTARS) as AvgRating,
CASE 
	WHEN avg(suprating.RAT_RATSTARS) = 5 then "Excellent Service"
    WHEN avg(suprating.RAT_RATSTARS) > 4 then "Good Service"
    WHEN avg(suprating.RAT_RATSTARS) > 2 then "Average Service"
else "Average Service"
END as type_of_service
FROM supplier as sup inner join (
SELECT sp.PRICING_ID, sp.SUPP_ID, spr.RAT_RATSTARS FROM supplier_pricing as sp inner join (
SELECT r.ORD_ID, r.RAT_RATSTARS, ors.PRICING_ID FROM rating as r 
inner join (SELECT ORD_ID, PRICING_ID FROM orders) as ors on ors.ORD_ID = r.ORD_ID ) as spr on spr.PRICING_ID = sp.PRICING_ID) as suprating on suprating.SUPP_ID = sup.SUPP_ID group by sup.SUPP_ID;
END