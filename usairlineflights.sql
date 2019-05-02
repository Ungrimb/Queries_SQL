CREATE VIEW `usairlineflights2`.`1_TOTAL` AS SELECT COUNT(*) AS TOTAL FROM flights;

CREATE VIEW `usairlineflights2`.`2_delay` AS
    SELECT 
        `usairlineflights2`.`flights`.`Origin` AS `Origin`,
        AVG(`usairlineflights2`.`flights`.`DepDelay`) AS `Retraso_Salida`,
        AVG(`usairlineflights2`.`flights`.`ArrDelay`) AS `Retraso_Llegada`
    FROM
        `usairlineflights2`.`flights`
    GROUP BY `usairlineflights2`.`flights`.`Origin`
    ORDER BY `usairlineflights2`.`flights`.`Origin`;
	
CREATE VIEW `usairlineflights2`.`3_month` AS
    SELECT 
        `usairlineflights2`.`flights`.`Origin` AS `Origin`,
        `usairlineflights2`.`flights`.`colYear` AS `DateYear`,
        `usairlineflights2`.`flights`.`colMonth` AS `DateMonth`,
        `usairlineflights2`.`flights`.`ArrDelay` AS `ArrDelay`
    FROM
        `usairlineflights2`.`flights`
    ORDER BY `usairlineflights2`.`flights`.`Origin` , `usairlineflights2`.`flights`.`colYear` , `usairlineflights2`.`flights`.`colMonth`;
	

	CREATE VIEW `usairlineflights2`.`4_city` AS
    SELECT 
        `usairlineflights2`.`usairports`.`City` AS `Origin`,
        `usairlineflights2`.`flights`.`colYear` AS `DateYear`,
        `usairlineflights2`.`flights`.`colMonth` AS `DateMonth`,
        `usairlineflights2`.`flights`.`ArrDelay` AS `ArrDelay`
    FROM
        (`usairlineflights2`.`flights`
        JOIN `usairlineflights2`.`usairports` ON ((`usairlineflights2`.`usairports`.`IATA` = `usairlineflights2`.`flights`.`Origin`)))
    ORDER BY `usairlineflights2`.`usairports`.`City` , `usairlineflights2`.`flights`.`colYear` , `usairlineflights2`.`flights`.`colMonth`;

CREATE VIEW `5_cancelation` AS
    SELECT 
        `f`.`UniqueCarrier` AS `UniqueCarrier`,
        `f`.`colYear` AS `colYear`,
        `f`.`colMonth` AS `colMonth`,
        AVG((`f`.`ArrDelay` + `f`.`DepDelay`)) AS `avg_delay`,
        SUM(`f`.`Cancelled`) AS `totalcanceled`
    FROM
        (`flights` `f`
        JOIN `carriers` ON ((`f`.`UniqueCarrier` = `carriers`.`CarrierCode`)))
    GROUP BY `f`.`UniqueCarrier` , `f`.`colYear` , `f`.`colMonth`
    ORDER BY SUM(`f`.`Cancelled`) DESC;
	

CREATE VIEW `6_airtime` AS
    SELECT 
        `f`.`TailNum` AS `TailNum`,
        SUM(`f`.`Distance`) AS `totalDistance`
    FROM
        `flights` `f`
    WHERE
        (`f`.`TailNum` <> ' ')
    GROUP BY `f`.`TailNum`
    ORDER BY SUM(`f`.`Distance`) DESC
    LIMIT 10;
	

CREATE VIEW `7_retardo` AS
    SELECT 
        `flights`.`UniqueCarrier` AS `UniqueCarrier`,
        AVG(`flights`.`ArrDelay`) AS `avgDelay`
    FROM
        `flights`
    GROUP BY `flights`.`UniqueCarrier`
    HAVING (`avgDelay` > 10)
    ORDER BY AVG(`flights`.`DepDelay`) DESC;