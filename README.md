# Bank Management System

A command-line banking application written in Python with a MySQL backend. It manages
customer accounts and the money in them: opening an account, viewing and updating the
account holder's details, depositing, withdrawing, and checking balances. Every account
record also carries the details of its most recent transaction.

## Features

- **Create Account** — registers a holder with name, email, contact number, and an opening balance.
- **View Accounts** — lists every account with its holder details, balance, and last transaction.
- **Deposit Money** — credits an account and records the transaction.
- **Withdraw Money** — debits an account, refusing the withdrawal if funds are insufficient.
- **Check Balance** — shows the current balance and the most recent transaction for one account.
- **Update Account Details** — changes a holder's name, email, or contact number.

Every deposit and withdrawal stamps the account with the transaction type, amount, and
timestamp, so the latest activity is always visible alongside the balance.

## Tech Stack

| Component | Used |
|---|---|
| Language | Python 3 |
| Database | MySQL |
| Driver | `mysql-connector-python` |
| Interface | Command line |

## Project Structure

```
BMS/
├── README.md
├── schema.sql          # Database and table definition (+ migration notes)
└── src/
    ├── main.py         # Entry point
    ├── menu.py         # Menu loop and choice dispatch
    ├── acc_ops.py      # Account operations and input validation
    └── db_config.py    # MySQL connection settings
```

## Prerequisites

- Python 3.8 or newer
- A running MySQL server
- The MySQL connector:

```bash
pip install mysql-connector-python
```

## Setup

### 1. Create the database and table

Run the schema from the project root:

```bash
mysql -u root -p < schema.sql
```

This creates the `bank_system` database and the `accounts` table.

> **Already have an `accounts` table?** Run `DESCRIBE accounts;` first and compare it
> against the schema. The bottom of `schema.sql` has commented `ALTER` statements for
> two cases: renaming a primary key column from `id` to `account_id`, and adding the
> `contact_number` and last-transaction columns to an older table. Existing rows will
> have a blank contact number and no transaction history until they are updated.

### 2. Configure the connection

Credentials are read from environment variables so that no password is stored in the
source code. Set them once on your machine:

**Windows (PowerShell)** — `setx` persists the variable, so open a new terminal afterwards:

```powershell
setx DB_PASSWORD "your_password"
```

**macOS / Linux** — add to your `~/.bashrc` or `~/.zshrc`:

```bash
export DB_PASSWORD="your_password"
```

`DB_HOST`, `DB_USER`, and `DB_NAME` can be set the same way if your setup differs from
the defaults of `localhost`, `root`, and `bank_system`.

## Running

```bash
python src/main.py
```

The menu loops until you choose Exit:

```
 Bank Management System
1. Create Account
2. View Account
3. Deposite Money
4. Withraw Money
5. Check Balance
6. Update Account Details
7. Exit
```

Note the account ID printed when you create an account — the deposit, withdraw,
balance, and update options all identify an account by that number.

## Database Schema

Table: `accounts`

| Column | Type | Notes |
|---|---|---|
| `account_id` | `INT` | Primary key, auto-increment |
| `name` | `VARCHAR(100)` | Account holder's name |
| `email` | `VARCHAR(100)` | Account holder's email |
| `contact_number` | `VARCHAR(20)` | Account holder's phone number |
| `balance` | `DECIMAL(12,2)` | Current balance, defaults to `0.00` |
| `last_txn_type` | `VARCHAR(20)` | `OPENING`, `DEPOSIT`, or `WITHDRAWAL` |
| `last_txn_amount` | `DECIMAL(12,2)` | Amount of the most recent transaction |
| `last_txn_date` | `DATETIME` | When the most recent transaction happened |

The column names here are what the queries in `acc_ops.py` expect. If the table is
created with different names, those queries will fail.

## Input Validation

- Account IDs must be whole numbers; anything else is re-prompted.
- Deposit and withdrawal amounts must be numeric and greater than zero.
- The opening balance must be numeric and may be zero, but not negative.
- Contact numbers must contain 7 to 15 digits, optionally with `+`, spaces, or dashes.
- Deposits, withdrawals, balance checks, and updates all report "Account Not Found"
  rather than silently doing nothing when the ID does not exist.
- Withdrawals are rejected with "Insufficient Balance!" when the amount exceeds the balance.
- On the update screen, leaving a field blank keeps its current value, so a single
  detail can be changed on its own.

## Current Limitations

These are known and deliberate for the scope of this project:

- **Only the most recent transaction is kept.** Each new deposit or withdrawal
  overwrites the previous one. A full statement would need a separate `transactions`
  table keyed on `account_id`.
- **There is no authentication.** Anyone running the program can act on any account ID.
- **Accounts cannot be closed or deleted** through the menu.
- **No transfers between accounts.**
- Each operation opens and closes its own connection rather than pooling.
