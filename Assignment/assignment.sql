use hr;
-- 1/ first_name starts with 'S'
select first_name, last_name, job_id, salary from employees
where first_name like 'S%';

-- 2/ employees with highest salary
select employee_id, first_name, last_name, job_id, salary
from employees
where salary = (select max(salary) from employees);

-- 3/ employees with second highest salary
select employee_id, first_name, last_name, job_id, salary
from employees
where salary = (
	select distinct salary 
    from employees
    order by salary desc
	limit 1 offset 1
);

-- 4/ employees with third highest salary
select employee_id, first_name, last_name, job_id, salary
from employees
where salary = (
	select distinct salary 
    from employees
    order by salary desc
	limit 1 offset 2
);

-- 5/ employees together with direct manager
select	concat_ws(' ', e.first_name, e.last_name) as employee,
		e.salary as emp_sal,
        concat_ws(' ', m.first_name, m.last_name) as manager,
        m.salary as mgr_sal
from employees e
join employees m
on e.manager_id = m.employee_id;

-- 6/ manager names with number of direct employees
select	m.employee_id,
		concat_ws(' ', m.first_name, m.last_name) as manager_name,
        count(*) as number_of_reportees
from employees m
join employees e
on m.employee_id = e.manager_id
group by manager_name, m.employee_id
order by number_of_reportees desc;

-- 7/ departments with number of employees
select	d.department_name,
		count(*) as emp_count
from departments d
join employees e
on d.department_id = e.department_id
group by d.department_name
order by emp_count desc;

-- 8/ number of new employees by year
select	YEAR(y.hire_date) as hired_year,
		count(*) as employees_hired_count
from employees y
group by hired_year
order by employees_hired_count desc;

-- 10/ divide employees into 3 salary groups: low, mid, high
select	min(e.salary) as min_sal,
		max(e.salary) as max_sal,
        floor(avg(e.salary)) as avg_sal
from employees e;

select	concat_ws(' ', e.first_name, e.last_name) as employee,
		e.salary,
case
	when e.salary < 5000 then 'low'
    when e.salary < 10000 then 'mid'
    else 'high'
end as salary_level
from employees e
order by e.salary;

-- 11/ format phone number
select	concat_ws(' ', e.first_name, e.last_name) as employee,
		replace(e.phone_number,'.','-') as phone_number
from employees e;

-- 12/ employees hired in 08-1994
select	concat_ws(' ', e.first_name, e.last_name) as employee,
		e.hire_date
from employees e
where YEAR(e.hire_date) = '1994'
and MONTH(e.hire_date) = '08';

-- 13/ employees who have salary higher than average
set @avg_salary = 
(
	select avg(salary) from employees
);

select	concat_ws(' ', e.first_name, e.last_name) as name,
		e.employee_id,
        d.department_name,
        e.department_id,
        e.salary
from employees e
join departments d
on e.department_id = d.department_id
where e.salary > @avg_salary
order by e.department_id;

-- 14/ max salary in each department
select	d.department_id,
		d.department_name,
        max(e.salary) as maximum_salary
from departments d
join employees e
on d.department_id = e.department_id
group by d.department_id, d.department_name
order by d.department_id;

-- 15/ 5 employees with lowest salary
select	e.first_name, e.last_name, e.employee_id,
		e.salary
from employees e
order by e.salary limit 5;

-- 17/ employees hired after 15th
select	lower(e.first_name) as name,
		reverse(lower(e.first_name)) as name_in_reverse
from employees e;

select	e.employee_id,
		concat_ws(' ', e.first_name, e.last_name) as employee,
        e.hire_date
from employees e
where DAY(e.hire_date) > 15;

-- 18/ manager and employee not on the same department
select	concat_ws(' ', m.first_name, m.last_name) as manager,
		concat_ws(' ', e.first_name, e.last_name) as employee,
        m.department_id as mgr_dept,
        e.department_id as emp_dept
from employees m
join employees e
on m.employee_id = e.manager_id
where m.department_id != e.department_id
order by manager;