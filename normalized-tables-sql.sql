-- Drop tables if they exist (in reverse order of creation to handle foreign keys)
DROP TABLE IF EXISTS StudentCourse;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Instructor;

-- Create Student table (BCNF)
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL
);

-- Create Course table (BCNF)
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL
);

-- Create Instructor table (BCNF)
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    InstructorName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL
);

-- Create StudentCourse table (BCNF)
CREATE TABLE StudentCourse (
    StudentID INT,
    CourseID INT,
    InstructorID INT NOT NULL,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Insert sample data
INSERT INTO Student (StudentID, StudentName) VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie');

INSERT INTO Course (CourseID, CourseName) VALUES
    (101, 'Database Systems'),
    (102, 'Operating Systems'),
    (103, 'Network Security');

INSERT INTO Instructor (InstructorID, InstructorName, Department) VALUES
    (1001, 'Dr. Smith', 'Computer Science'),
    (1002, 'Dr. Jones', 'Computer Science'),
    (1003, 'Dr. White', 'Information Tech');

INSERT INTO StudentCourse (StudentID, CourseID, InstructorID) VALUES
    (1, 101, 1001),
    (2, 102, 1002),
    (3, 103, 1003),
    (1, 102, 1002),
    (2, 101, 1001);

-- Create indexes for better query performance
CREATE INDEX idx_student_name ON Student(StudentName);
CREATE INDEX idx_course_name ON Course(CourseName);
CREATE INDEX idx_instructor_name ON Instructor(InstructorName);
CREATE INDEX idx_studentcourse_instructor ON StudentCourse(InstructorID);
