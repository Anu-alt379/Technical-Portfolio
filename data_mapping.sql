-- data_mapping.sql
-- Purpose: Maps invoices between ClientERP and ApexPortal, ensuring data consistency
-- Created by Anubhav for apexanalytix portfolio

-- Create sample tables
CREATE TABLE ClientERP_Invoices (
    invoice_id VARCHAR(10),
    amount DECIMAL(10,2),
    date DATE
);

CREATE TABLE ApexPortal_Invoices (
    invoice_id VARCHAR(10),
    total DECIMAL(10,2),
    created_date DATE
);

-- Insert sample data
INSERT INTO ClientERP_Invoices VALUES
('INV001', 1000.50, '2025-04-01'),
('INV002', 2000.75, '2025-04-02'),
('INV003', 1500.00, '2025-04-03');

INSERT INTO ApexPortal_Invoices VALUES
('INV001', 1000.50, '2025-04-01'),
('INV002', 2000.00, '2025-04-02'),
('INV004', 3000.25, '2025-04-04');

-- Query to map matching invoices and flag discrepancies
SELECT 
    c.invoice_id,
    c.amount AS erp_amount,
    a.total AS portal_amount,
    CASE 
        WHEN c.amount = a.total THEN 'Match'
        ELSE 'Discrepancy'
    END AS status
FROM ClientERP_Invoices c
INNER JOIN ApexPortal_Invoices a
    ON c.invoice_id = a.invoice_id
    AND c.date = a.created_date
WHERE ABS(c.amount - a.total) <= 0.05 * c.amount OR c.amount = a.total;
