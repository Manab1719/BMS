-- Bank Management System - authoritative schema.
-- The Python code in src/ expects EXACTLY these table and column names.

CREATE DATABASE IF NOT EXISTS bank_system;
USE bank_system;

CREATE TABLE IF NOT EXISTS accounts (
    account_id              INT AUTO_INCREMENT PRIMARY KEY,
    name                    VARCHAR(100)   NOT NULL,
    email                   VARCHAR(100)   NOT NULL,
    contact_number          VARCHAR(20)    NOT NULL,
    balance                 DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    last_txn_type           VARCHAR(20)    DEFAULT NULL,
    last_txn_amount         DECIMAL(12, 2) DEFAULT NULL,
    last_txn_date           DATETIME       DEFAULT NULL
);

-- ---------------------------------------------------------------------------
-- MIGRATION - run these ONLY if you already have an `accounts` table.
-- Check what you actually have first:  DESCRIBE accounts;
-- ---------------------------------------------------------------------------

-- 1. If your primary key column is named `id` instead of `account_id`, the
--    deposit/withdraw/balance queries will crash. Rename it:
-- ALTER TABLE accounts CHANGE COLUMN id account_id INT AUTO_INCREMENT;

-- 2. Add the columns for contact number and most-recent-transaction details:
-- ALTER TABLE accounts
--     ADD COLUMN contact_number  VARCHAR(20)    NOT NULL DEFAULT '' AFTER email,
--     ADD COLUMN last_txn_type   VARCHAR(20)    DEFAULT NULL,
--     ADD COLUMN last_txn_amount DECIMAL(12, 2) DEFAULT NULL,
--     ADD COLUMN last_txn_date   DATETIME       DEFAULT NULL;
