SELECT 
    -- Selecting columns from the final_transaction table
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    -- Retrieving branch information from the kantor_cabang table
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    -- Retrieving product information from the product table
    p.product_name,
    p.price AS actual_price,
    ft.discount_percentage,
    -- Calculating gross profit percentage based on product price
    CASE
        WHEN p.price <= 50000 THEN 0.1
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    -- Calculating net sales amount after applying discount
    (p.price * (1 - discount_percentage)) AS nett_sales,
    -- Calculating net profit amount after applying discount and gross profit percentage
    ((p.price * (1 - discount_percentage)) * CASE
        WHEN p.price <= 50000 THEN 0.1
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END) AS nett_profit,
    ft.rating AS rating_transaksi
FROM 
    -- Joining final_transaction table with kantor_cabang table based on branch_id
    `rakamin-kf-analytics-405.kimia_farma.final_transaction` ft
LEFT JOIN 
    -- Joining final_transaction table with product table based on product_id
    `rakamin-kf-analytics-405.kimia_farma.kantor_cabang` kc ON ft.branch_id = kc.branch_id
LEFT JOIN 
    `rakamin-kf-analytics-405.kimia_farma.product` p ON ft.product_id = p.product_id