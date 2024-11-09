-- Create Student table
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL
);

-- Create Course table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL
);

-- Create Instructor table
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    InstructorName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL
);

-- Create StudentCourse table (relationship table)
CREATE TABLE StudentCourse (
    StudentID INT,
    CourseID INT,
    InstructorID INT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

-- Insert sample data into Student table
INSERT INTO Student (StudentID, StudentName) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- Insert sample data into Course table
INSERT INTO Course (CourseID, CourseName) VALUES
(101, 'Database Systems'),
(102, 'Operating Systems'),
(103, 'Network Security');

-- Insert sample data into Instructor table
INSERT INTO Instructor (InstructorID, InstructorName, Department) VALUES
(1001, 'Dr. Smith', 'Computer Science'),
(1002, 'Dr. Jones', 'Computer Science'),
(1003, 'Dr. White', 'Information Tech');

-- Insert sample data into StudentCourse table
INSERT INTO StudentCourse (StudentID, CourseID, InstructorID) VALUES
(1, 101, 1001),
(2, 102, 1002),
(3, 103, 1003),
(1, 102, 1002),
(2, 101, 1001);
