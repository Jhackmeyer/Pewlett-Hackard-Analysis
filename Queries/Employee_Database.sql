SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY (e.emp_no);

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY emp_no, to_date DESC;

-- Table for retiring counts by title
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;


-- Table for mentorship eligibility
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.dept_no,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

--Add department name to department count table
SELECT dc.count,
dc.dept_no,
d.dept_name
FROM dept_count as dc
INNER JOIN departments as d
ON (dc.dept_no = d.dept_no)
ORDER BY count;

-- Total number of employees by department
SELECT COUNT(de.emp_no), de.dept_no, d.dept_name
INTO dept_count_name
FROM dept_employees as de
INNER JOIN departments as d
on (de.dept_no = d.dept_no)
GROUP BY de.dept_no, d.dept_name
ORDER BY de.dept_no;

-- Mentorship counts by title
SELECT COUNT(emp_no),
	title
INTO mentor_count_titles
FROM mentorship_eligibility
GROUP BY title
ORDER BY title;

-- Retiring counts by title, alphabetically 
SELECT * FROM retiring_titles
ORDER BY title;

-- Mentorship counts by department
SELECT COUNT(me.emp_no),
	d.dept_no,
	d.dept_name
INTO mentor_by_dept
FROM mentorship_eligibility as me
INNER JOIN dept_employees as de
ON (me.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (de.to_date = '9999-01-01')
GROUP BY d.dept_no;


-- Retiring counts by department
SELECT COUNT(rt.emp_no),
	d.dept_no,
	d.dept_name
INTO retire_by_dept
FROM retirement_titles as rt
INNER JOIN dept_employees as de
ON (rt.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no)
WHERE (rt.to_date = '9999-01-01')
GROUP BY de.dept_no, d.dept_no
ORDER BY de.dept_no;

-- Ratio of Retirees to Mentors
SELECT rd.count as count_retiring, md.count as count_mentors, md.title, rd.count/md.count as ratio_title
FROM mentor_count_titles as md
INNER JOIN retiring_titles as rd
ON (rd.title = md.title);

-- Ratio of Retirees to Mentors by Department
SELECT rd.count as count_retiring, md.count as count_mentors,rd.dept_name, rd.count/md.count as ratio_dept
FROM mentor_by_dept as md
INNER JOIN retire_by_dept as rd
ON (rd.dept_no = md.dept_no);