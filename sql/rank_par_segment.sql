-- Classement des clients par CA au sein de leur segment RFM

SELECT
    customer_id,
    segment_rfm,
    monetary,
    RANK() OVER (PARTITION BY segment_rfm ORDER BY monetary DESC) AS rang_dans_segment
FROM vw_customer_segments
ORDER BY segment_rfm, rang_dans_segment
LIMIT 20;