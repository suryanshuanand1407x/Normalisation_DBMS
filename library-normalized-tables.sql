-- Drop existing tables if they exist (reverse order due to foreign keys)
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Author;

-- Create Author table
CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL
);

-- Create Member table
CREATE TABLE Member (
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100) NOT NULL
);

-- Create Book table
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    BookTitle VARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Create Transaction table
CREATE TABLE Transaction (
    TransactionID INT PRIMARY KEY,
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    LibraryBranch VARCHAR(50) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Insert sample data
INSERT INTO Author (AuthorID, AuthorName) VALUES
    (301, 'Alice Smith'),
    (302, 'Bob Brown'),
    (303, 'Charlie Green');

INSERT INTO Member (MemberID, MemberName) VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Emily Davis');

INSERT INTO Book (BookID, BookTitle, AuthorID) VALUES
    (201, 'Database Systems', 301),
    (202, 'Network Security', 302),
    (203, 'Data Mining', 301),
    (204, 'Operating Systems', 303);

INSERT INTO Transaction (TransactionID, MemberID, BookID, LibraryBranch) VALUES
    (1, 101, 201, 'Central Branch'),
    (2, 102, 202, 'East Branch'),
    (3, 101, 203, 'Central Branch'),
    (4, 103, 201, 'Central Branch'),
    (5, 102, 204, 'East Branch');

-- Create indexes for better query performance
CREATE INDEX idx_book_author ON Book(AuthorID);
CREATE INDEX idx_transaction_member ON Transaction(MemberID);
CREATE INDEX idx_transaction_book ON Transaction(BookID);
CREATE INDEX idx_book_title ON Book(BookTitle);
CREATE INDEX idx_member_name ON Member(MemberName);
