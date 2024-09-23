-- Creating database for the project
create database library_database;
-- Using the created library to store the tables.
use library_database;

-- Creating tables in the database

-- Creating publisher table

create table tbl_publisher(
publisher_PublisherName varchar(200) primary key,
publisher_PublisherAddress varchar(200),
publisher_PublisherPhone varchar(225)
);

-- Creating borrower table

create table tbl_borrower(
borrower_CardNo int primary key,
borrower_BorrowerName varchar(200),
borrower_BorrowerAddress varchar(200),
borrower_BorrowerPhone int);

-- Creating library_branch table

create table tbl_library_branch(
library_branch_BranchID int auto_increment primary key,
library_branch_BranchName varchar(200),
library_branch_BranchAddress varchar(200)
);

-- Creating book table

create table tbl_book(
book_BookID int primary key,
book_Title varchar(200),
book_PublisherName varchar(200),
foreign key (book_PublisherName) references tbl_publisher(publisher_PublisherName) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Creating book_authors table

create table tbl_book_authors(
book_authors_AuthorID int auto_increment primary key,
book_authors_BookID int,
book_authors_AuthorName varchar(200),
foreign key (book_authors_BookID) references tbl_book(book_bookID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Creating book_copies table

create table tbl_book_copies(
book_copies_CopiesID int auto_increment primary key,
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_Of_Copies int,
foreign key (book_copies_BookID) references tbl_book(book_bookID) ON UPDATE CASCADE ON DELETE CASCADE,
foreign key (book_copies_BranchID) references tbl_library_branch(library_branch_BranchID) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Creating book_loans table

create table tbl_book_loans(
book_loans_LoansID int auto_increment primary key,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int,
book_loans_DateOut date,
book_loans_DueDate date,
foreign key (book_loans_BookID) references tbl_book(book_bookID) ON UPDATE CASCADE ON DELETE CASCADE,
foreign key (book_loans_BranchID) references tbl_library_branch(library_branch_BranchID) ON UPDATE CASCADE ON DELETE CASCADE,
foreign key (book_loans_CardNo) references tbl_borrower(borrower_CardNo) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Task Questions

-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

select book_copies_No_Of_Copies
from tbl_library_branch as tbl_lib_brnch 
join tbl_book_copies as tbl_bok_cpes 
on tbl_lib_brnch.library_branch_BranchID = tbl_bok_cpes.book_copies_BranchID
join tbl_book as tbl_bok on tbl_bok_cpes.book_copies_BookID = tbl_bok.book_BookID
where book_Title = "The Lost Tribe" and library_branch_BranchName = "Sharpstown";


-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select library_branch_BranchName,sum(book_copies_No_Of_Copies) as no_of_copies
from tbl_library_branch as tbl_lib_brnch 
left join tbl_book_copies as tbl_bok_cpes 
on tbl_lib_brnch.library_branch_BranchID = tbl_bok_cpes.book_copies_BranchID
join tbl_book as tbl_bok on tbl_bok_cpes.book_copies_BookID = tbl_bok.book_BookID
where book_Title = "The Lost Tribe"
group by library_branch_BranchName;

-- 3. Retrieve the names of all borrowers who do not have any books checked out.

select borrower_BorrowerName from tbl_borrower
where borrower_CardNo not in (select book_loans_CardNo from tbl_book_loans);

-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address. 

select book_Title,borrower_BorrowerName,borrower_BorrowerAddress
from tbl_borrower as tbl_borwr 
join tbl_book_loans as tbl_bok_lns on tbl_borwr.borrower_CardNo = tbl_bok_lns.book_loans_CardNo
join tbl_library_branch as tbl_lib_brnch on tbl_bok_lns.book_loans_BranchID = tbl_lib_brnch.library_branch_BranchID
join tbl_book as tbl_bok on tbl_bok_lns.book_loans_BookID = tbl_bok.book_BookID
where library_branch_BranchName = "Sharpstown" and book_loans_DueDate = STR_TO_DATE('2/3/18', '%d/%m/%y');

-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select library_branch_BranchName,count(book_loans_BookID) as count_books_sold_out 
from tbl_library_branch as tbl_lib_brnch join tbl_book_loans as tbl_bok_lns 
on tbl_lib_brnch.library_branch_BranchID = tbl_bok_lns.book_loans_BranchID
group by library_branch_BranchName;


-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select borrower_BorrowerName,borrower_BorrowerAddress,count(book_loans_CardNo) as number_of_books_checked_out
from tbl_borrower as tbl_brwr join tbl_book_loans as tbl_bok_lns
on tbl_brwr.borrower_CardNo = tbl_bok_lns.book_loans_CardNo
group by borrower_BorrowerName,borrower_BorrowerAddress having number_of_books_checked_out >5;

-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select book_Title,book_copies_No_Of_Copies,library_branch_BranchName
from tbl_book_authors as tbl_bok_autrs join tbl_book as tbl_bok on tbl_bok_autrs.book_authors_BookID = tbl_bok.book_BookID 
join tbl_book_copies as tbl_bok_cpes on tbl_bok.book_BookID = tbl_bok_cpes.book_copies_BookID
join tbl_library_branch as tbl_lib_brnch on tbl_bok_cpes.book_copies_BranchID = tbl_lib_brnch.library_branch_BranchID
where book_authors_AuthorName = "Stephen King" and library_branch_BranchName = "Central";


