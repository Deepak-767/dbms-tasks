# Task 5 – Payment Transaction Management

## Objective
Manage payments linked to orders and demonstrate payment status, transaction mode, validation and reporting.

## Database
`task5_payment_db`

## Included
- Payment master table
- Order-to-payment relationship
- Positive transaction amount constraint
- Successful, failed and pending payment reports
- Payment-mode and status counts
- Retry/update operation for a failed payment

## Correction applied
The earlier source exercise attempted to update a non-existent Payment_ID. This version updates an existing failed transaction and uses consistent `Successful` status values.

## How to run
Run `Task5_Payment_Transaction.sql` in MySQL 8.0+.
