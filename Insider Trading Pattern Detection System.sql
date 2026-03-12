BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE trades CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE announcements CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE stock_prices CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE insiders CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE companies CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE traders CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
CREATE TABLE traders (
    trader_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    country VARCHAR2(50)
);
CREATE TABLE companies (
    company_id NUMBER PRIMARY KEY,
    company_name VARCHAR2(100),
    sector VARCHAR2(50)
);
CREATE TABLE announcements (
    announcement_id NUMBER PRIMARY KEY,
    company_id NUMBER,
    announcement_date DATE,
    announcement_type VARCHAR2(50),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);
CREATE TABLE trades (
    trade_id NUMBER PRIMARY KEY,
    trader_id NUMBER,
    company_id NUMBER,
    trade_date DATE,
    trade_type VARCHAR2(10),
    quantity NUMBER,
    price NUMBER,
    FOREIGN KEY (trader_id) REFERENCES traders(trader_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);
CREATE TABLE stock_prices (
    price_id NUMBER PRIMARY KEY,
    company_id NUMBER,
    price_date DATE,
    close_price NUMBER,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);
INSERT INTO companies VALUES (1,'Reliance','Energy');
INSERT INTO companies VALUES (2,'Tesla','Automobile');
INSERT INTO companies VALUES (3,'Apple','Technology');

DELETE FROM traders;

INSERT INTO traders VALUES (1,'Rahul','India');
INSERT INTO traders VALUES (2,'Alex','USA');
INSERT INTO traders VALUES (3,'Priya','India');
INSERT INTO traders VALUES (4,'John','UK');

SELECT * FROM traders;
----------------
INSERT INTO announcements VALUES
(1,1,DATE '2024-01-12','Earnings');

INSERT INTO announcements VALUES
(2,2,DATE '2024-02-10','Acquisition');

INSERT INTO announcements VALUES
(3,3,DATE '2024-03-15','Product Launch');

SELECT * FROM announcements;
----------------------
INSERT INTO trades VALUES
(1,1,1,DATE '2024-01-10','BUY',500,2400);

INSERT INTO trades VALUES
(2,2,1,DATE '2024-01-11','BUY',3000,2405);

INSERT INTO trades VALUES
(3,3,2,DATE '2024-02-08','BUY',400,690);

INSERT INTO trades VALUES
(4,4,2,DATE '2024-02-09','BUY',2000,700);

INSERT INTO trades VALUES
(5,1,3,DATE '2024-03-14','BUY',1500,180);

SELECT * FROM trades;
-----------------
INSERT INTO stock_prices VALUES
(1,1,DATE '2024-01-10',2400);

INSERT INTO stock_prices VALUES
(2,1,DATE '2024-01-13',2600);

INSERT INTO stock_prices VALUES
(3,2,DATE '2024-02-09',700);

INSERT INTO stock_prices VALUES
(4,2,DATE '2024-02-11',760);

INSERT INTO stock_prices VALUES
(5,3,DATE '2024-03-14',180);

INSERT INTO stock_prices VALUES
(6,3,DATE '2024-03-16',210);
INSERT INTO stock_prices VALUES
(7,1,DATE '2024-01-14',2700);

SELECT * FROM stock_prices;
-------------------------
SELECT 
    t.trade_id,
    t.trader_id,
    t.company_id,
    t.trade_date,
    a.announcement_date
FROM trades t
JOIN announcements a
ON t.company_id = a.company_id
WHERE t.trade_date < a.announcement_date;


SELECT 
t.trader_id,
c.company_name,
SUM(t.quantity) AS total_shares
FROM trades t
JOIN companies c
ON t.company_id = c.company_id
JOIN announcements a
ON t.company_id = a.company_id
WHERE t.trade_date < a.announcement_date
GROUP BY t.trader_id, c.company_name
HAVING SUM(t.quantity) > 1000;

SELECT 
t.trader_id,
c.company_name,
t.quantity,
t.price AS buy_price,
sp.close_price AS price_after_announcement,
(t.quantity * (sp.close_price - t.price)) AS profit
FROM trades t
JOIN companies c
ON t.company_id = c.company_id
JOIN announcements a
ON t.company_id = a.company_id
JOIN stock_prices sp
ON sp.company_id = t.company_id
WHERE t.trade_date < a.announcement_date
AND sp.price_date = (
    SELECT MIN(price_date)
    FROM stock_prices
    WHERE company_id = t.company_id
    AND price_date > a.announcement_date
);
SELECT * FROM stock_prices;

SELECT
    trader_id,
    SUM(profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS suspicion_rank
FROM
(
    SELECT
        t.trader_id,
        (t.quantity * (sp.close_price - t.price)) AS profit
    FROM trades t
    JOIN announcements a
        ON t.company_id = a.company_id
    JOIN stock_prices sp
        ON t.company_id = sp.company_id
    WHERE t.trade_date < a.announcement_date
    AND sp.price_date > a.announcement_date
) profit_data
GROUP BY trader_id;