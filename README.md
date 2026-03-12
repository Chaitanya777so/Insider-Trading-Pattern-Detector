Updated documentation
Insider Trading Pattern Detection System

## Overview

This project is a **SQL-based financial data analysis system** designed to detect **potential insider trading patterns** in stock markets.

The system analyzes:

* Stock trades
* Corporate announcements
* Stock price movements

By comparing trades made **before corporate announcements** with **price changes after announcements**, the system identifies traders who may have made suspicious profits.

---

## Objective

The goal of this project is to simulate a **market surveillance system** similar to those used by financial regulators to detect suspicious trading behavior.

The system focuses on identifying:

* Trades executed **before major announcements**
* Abnormal trading volumes
* Profits generated due to price movement after announcements

---

## Database Schema

The project uses the following tables:

### 1. Traders

Stores information about traders.

| Column    | Description              |
| --------- | ------------------------ |
| trader_id | Unique trader identifier |
| name      | Trader name              |
| country   | Country of trader        |

---

### 2. Companies

Stores company information.

| Column       | Description               |
| ------------ | ------------------------- |
| company_id   | Unique company identifier |
| company_name | Name of the company       |
| sector       | Industry sector           |

---

### 3. Announcements

Stores corporate announcements that may influence stock prices.

| Column            | Description                     |
| ----------------- | ------------------------------- |
| announcement_id   | Unique announcement identifier  |
| company_id        | Company making the announcement |
| announcement_date | Date of announcement            |
| announcement_type | Type of event                   |

---

### 4. Trades

Stores trading activity by traders.

| Column     | Description             |
| ---------- | ----------------------- |
| trade_id   | Unique trade identifier |
| trader_id  | Trader executing trade  |
| company_id | Company stock traded    |
| trade_date | Date of trade           |
| trade_type | Buy/Sell                |
| quantity   | Number of shares traded |
| price      | Trade price             |

---

### 5. Stock Prices

Stores stock price data for companies.

| Column      | Description             |
| ----------- | ----------------------- |
| price_id    | Unique price identifier |
| company_id  | Company identifier      |
| price_date  | Date of price record    |
| close_price | Closing stock price     |

---

## Key SQL Analysis Queries

### 1. Detect Trades Before Announcements

Identifies traders who traded before a corporate announcement.

### 2. High Volume Trades Before Announcements

Detects unusually large trades executed before important announcements.

### 3. Profit Calculation After Announcement

Calculates profits made by traders if stock prices increased after the announcement.

### 4. Suspicious Trader Ranking

Ranks traders based on the **total profit generated from pre-announcement trades** using SQL window functions.

---

## Technologies Used

* SQL (Oracle Database)
* Relational Database Design
* Analytical SQL Queries
* Window Functions (`RANK()`)

---

## Example Output

The system ranks traders based on suspicious profit patterns:

| trader_id | total_profit | suspicion_rank |
| --------- | ------------ | -------------- |
| 2         | 1470000      | 1              |
| 1         | 295000       | 2              |
| 4         | 120000       | 3              |
| 3         | 20000        | 4              |

Higher profit after announcements may indicate **potential insider trading behavior**.

---

## How to Run the Project

1. Open Oracle SQL Developer
2. Run the SQL script
3. Tables will be created automatically
4. Sample data will be inserted
5. Analytical queries will generate the results

---

## Project Structure

```
Insider-Trading-Pattern-Detection
│
├── insider_trading_detection.sql
└── README.md
```

---

## Author

Chaitanya Sonowal
Indian Institute of Technology Roorkee
