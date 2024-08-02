-- 코드를 입력하세요
WITH ABLE_CAR AS(
    SELECT DISTINCT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY AS RH
    WHERE NOT EXISTS (
        SELECT 1
        FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY AS R
        WHERE 
            R.CAR_ID = RH.CAR_ID 
            AND R.END_DATE >= '2022-11-01' 
            AND R.START_DATE <= '2022-11-30'
    )
)
,
DISCOUNT AS (
    SELECT *
    FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN 
    WHERE DURATION_TYPE = '30일 이상'
)

SELECT 
    A.CAR_ID, C.CAR_TYPE,
    ROUND((DAILY_FEE * (1-DISCOUNT_RATE*0.01) * 30), 0) AS FEE
FROM ABLE_CAR A
JOIN CAR_RENTAL_COMPANY_CAR C ON C.CAR_ID = A.CAR_ID
JOIN DISCOUNT D ON D.CAR_TYPE = C.CAR_TYPE
WHERE 
    C.CAR_TYPE IN ('세단', 'SUV') 
    AND (DAILY_FEE * (1-DISCOUNT_RATE*0.01) * 30) > 500000 
    AND (DAILY_FEE * (1-DISCOUNT_RATE*0.01) * 30) < 2000000
ORDER BY FEE DESC, CAR_TYPE, CAR_ID DESC;