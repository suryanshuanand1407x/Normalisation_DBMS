-- First, drop existing tables if they exist (in reverse order due to foreign key constraints)
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS LibraryBranch;

-- Create Author table
CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL,
    CONSTRAINT uk_author_name UNIQUE (AuthorName)
);

-- Create Member table
CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100) NOT NULL,
    CONSTRAINT uk_member_name UNIQUE (MemberName)
);

-- Create LibraryBranch table
CREATE TABLE LibraryBranch (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(50) NOT NULL,
    CONSTRAINT uk_branch_name UNIQUE (BranchName)
);

-- Create Book table
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    BookTitle VARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    CONSTRAINT fk_book_author FOREIGN KEY (AuthorID) 
        REFERENCES Author(AuthorID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Create Transaction table
CREATE TABLE Transaction (
    TransactionID INT PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    BranchID INT NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transaction_member FOREIGN KEY (MemberID) 
        REFERENCES Member(MemberID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_transaction_book FOREIGN KEY (BookID) 
        REFERENCES Book(BookID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_transaction_branch FOREIGN KEY (BranchID) 
        REFERENCES LibraryBranch(BranchID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Create indexes for better query performance
CREATE INDEX idx_book_author ON Book(AuthorID);
CREATE INDEX idx_book_title ON Book(BookTitle);
CREATE INDEX idx_transaction_member ON Transaction(MemberID);
CREATE INDEX idx_transaction_book ON Transaction(BookID);
CREATE INDEX idx_transaction_branch ON Transaction(BranchID);
CREATE INDEX idx_transaction_date ON Transaction(TransactionDate);

-- Insert sample data
-- Insert Authors
INSERT INTO Author (AuthorID, AuthorName) VALUES
    (301, 'Alice Smith'),
    (302, 'Bob Brown'),
    (303, 'Charlie Green');

-- Insert Members
INSERT INTO Member (MemberID, MemberName) VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Davis');

-- Insert Library Branches
INSERT INTO LibraryBranch (BranchID, BranchName) VALUES
    (1, 'Central Branch'),
    (2, 'East Branch');

-- Insert Books
INSERT INTO Book (BookID, BookTitle, AuthorID) VALUES
    (201, 'Database Systems', 301),
    (202, 'Network Security', 302),
    (203, 'Data Mining', 301),
    (204, 'Operating Systems', 303);

-- Insert Transactions
INSERT INTO Transaction (TransactionID, MemberID, BookID, BranchID, TransactionDate) VALUES
    (1, 101, 201, 1, CURRENT_TIMESTAMP),
    (2, 102, 202, 2, CURRENT_TIMESTAMP),
    (3, 101, 203, 1, CURRENT_TIMESTAMP),
    (4, 103, 201, 1, CURRENT_TIMESTAMP),
    (5, 102, 204, 2, CURRENT_TIMESTAMP);

-- Create views for common queries
CREATE VIEW BookDetails AS
SELECT 
    b.BookID,
    b.BookTitle,
    a.AuthorID,
    a.AuthorName
FROM Book b
JOIN Author a ON b.AuthorID = a.AuthorID;

CREATE VIEW TransactionDetails AS
SELECT 
    t.TransactionID,
    t.TransactionDate,
    m.MemberID,
    m.MemberName,
    b.BookID,
    b.BookTitle,
    a.AuthorName,
    lb.BranchName
FROM Transaction t
JOIN Member m ON t.MemberID = m.MemberID
JOIN Book b ON t.BookID = b.BookID
JOIN Author a ON b.AuthorID = a.AuthorID
JOIN LibraryBranch lb ON t.BranchID = lb.BranchID;

-- Add some utility functions
CREATE OR REPLACE FUNCTION get_member_transactions(p_member_id INT)
RETURNS TABLE (
    TransactionID INT,
    BookTitle VARCHAR(200),
    TransactionDate TIMESTAMP,
    BranchName VARCHAR(50)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.TransactionID,
        b.BookTitle,
        t.TransactionDate,
        lb.BranchName
    FROM Transaction t
    JOIN Book b ON t.BookID = b.BookID
    JOIN LibraryBranch lb ON t.BranchID = lb.BranchID
    WHERE t.MemberID = p_member_id
    ORDER BY t.TransactionDate DESC;
END;
$$ LANGUAGE plpgsql;
