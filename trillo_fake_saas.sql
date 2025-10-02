-- =======================================================
-- Ensure database 'trillo' exists and switch to it
-- =======================================================
CREATE DATABASE IF NOT EXISTS trillo;
USE trillo;

-- =======================================================
-- Drop and create 'teams' table, then bulk load from CSV
-- =======================================================
DROP TABLE IF EXISTS trillo.teams;

-- Create 'teams' table with standard columns
CREATE TABLE IF NOT EXISTS teams (
    team_id   UInt32,
    team_name String,
    created_at String
) ENGINE = MergeTree()
ORDER BY team_id;

-- Load teams data from external CSV file
INSERT INTO teams
SELECT
    toUInt32(team_id),
    team_name,
    created_at
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0004mn3fo44wph5n/faEBe9dtNrQrc4Kd/Acme200TeamsDatabase/teams_table.csv',
    'CSV',
    'team_id String, team_name String, created_at String')
SETTINGS input_format_skip_unknown_fields = 1;

-- =======================================================
-- Drop and create 'users' table, then bulk load from CSV
-- =======================================================
DROP TABLE IF EXISTS trillo.users;

CREATE TABLE IF NOT EXISTS users (
    user_id   UInt32,
    username  String,
    email     String,
    team_id   UInt32,
    created_at String
) ENGINE = MergeTree()
ORDER BY user_id;

-- Load users data from external CSV file with headers
INSERT INTO users
SELECT
    toUInt32(user_id),
    username,
    email,
    toUInt32(team_id),
    created_at
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7ua8xd0004mn3fo44wph5n/faEBe9dtNrQrc4Kd/Acme200TeamsDatabase/users_table.csv',
    'CSVWithNames',
    'user_id String, username String, email String, team_id String, created_at String')
SETTINGS input_format_skip_unknown_fields = 1;

-- =======================================================
-- Create 'events' table and load directly from CSV
-- =======================================================
CREATE TABLE IF NOT EXISTS events ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0002o13jw0iekpbd/faEBe9dtNrQrc4Kd/AcmeStartupData/events.csv',
    'CSV'
);

-- =======================================================
-- Create 'tickets' table and load from CSV
-- =======================================================
CREATE TABLE IF NOT EXISTS tickets ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0002o13jw0iekpbd/faEBe9dtNrQrc4Kd/AcmeStartupData/tickets.csv',
    'CSV'
);

-- =======================================================
-- Create 'nps_responses' table for NPS survey data
-- =======================================================
CREATE TABLE IF NOT EXISTS nps_responses ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0002o13jw0iekpbd/faEBe9dtNrQrc4Kd/AcmeStartupData/nps_responses.csv',
    'CSV'
);

-- =======================================================
-- Create 'transactions' table for payments and purchases
-- =======================================================
CREATE TABLE IF NOT EXISTS transactions ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0002o13jw0iekpbd/faEBe9dtNrQrc4Kd/AcmeStartupData/transactions.csv',
    'CSV'
);

-- =======================================================
-- Create 'subscriptions' table for recurring user plans
-- =======================================================
CREATE TABLE IF NOT EXISTS subscriptions ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0002o13jw0iekpbd/faEBe9dtNrQrc4Kd/AcmeStartupData/subscriptions.csv',
    'CSV'
);

-- =======================================================
-- Create 'webhooks' table for external system events
-- =======================================================
CREATE TABLE IF NOT EXISTS webhooks ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT *
FROM url(
    'https://data.synehq.com/gateway/0/files/kole/sandbox/cmg7qud4z0002o13jw0iekpbd/faEBe9dtNrQrc4Kd/AcmeStartupData/webhooks.csv',
    'CSV'
);

-- =======================================================
-- List all tables in the 'trillo' database
-- =======================================================
SHOW TABLES;
