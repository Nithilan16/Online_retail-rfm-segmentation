-- Calcul du RFM et scoring par quintiles, directement en SQL à partir de la table orders.
CREATE VIEW vw_customer_segments AS

WITH reference_date AS (
    SELECT DATE(MAX(invoice_date), '+1 day') AS ref_date
    FROM orders
),

rfm_base AS (
    SELECT
        o.customer_id,
        CAST(julianday((SELECT ref_date FROM reference_date)) - julianday(DATE(MAX(o.invoice_date))) AS INTEGER) AS recency,
        COUNT(DISTINCT o.invoice) AS frequency,
        SUM(o.total_price) AS monetary
    FROM orders o
    GROUP BY o.customer_id
),

rfm_scored AS (
    SELECT
        customer_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)

SELECT
    customer_id,
    recency,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS rfm_score_sum,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 4 AND f_score >= 3 THEN 'Clients fideles'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Nouveaux clients'
        WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'A risque'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Perdus'
        WHEN r_score = 3 THEN 'Clients réguliers'
        ELSE 'Autres'
    END AS segment_rfm
FROM rfm_scored;