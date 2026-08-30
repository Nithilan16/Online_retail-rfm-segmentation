-- Schéma relationnel de la base online_retail (Documente la structure créée depuis pandas (to_sql) en section 8)

CREATE TABLE IF NOT EXISTS products (
    stock_code TEXT PRIMARY KEY,
    description TEXT
);

CREATE TABLE IF NOT EXISTS orders (
    invoice TEXT,
    stock_code TEXT,
    quantity INTEGER,
    invoice_date TEXT,
    price REAL,
    customer_id REAL,
    total_price REAL,
    FOREIGN KEY (stock_code) REFERENCES products(stock_code)
);

CREATE TABLE IF NOT EXISTS customer_segments_python (
    customer_id REAL PRIMARY KEY,
    recency INTEGER,
    frequency INTEGER,
    monetary REAL,
    rfm_score TEXT,
    segment_rfm TEXT,
    cluster_kmeans INTEGER
);