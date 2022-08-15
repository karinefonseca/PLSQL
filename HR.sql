
--EXEMPLO DE PROCEDURE--

CREATE OR REPLACE PROCEDURE SP_CONFERE_NM_FUNCIONARIO (P_ID_FUNCIONARIO NUMBER, P_NM_FUNCIONARIO VARCHAR2) IS

V_NM_FUNCIONARIO employees.first_name%Type;
BEGIN

SELECT first_name
INTO V_NM_FUNCIONARIO
FROM employees
WHERE employee_id = 102;

IF V_NM_FUNCIONARIO <> ‘LEX’ THEN
DBMS_OUTPUT.put_line(V_NM_FUNCIONARIO);
ELSE
DBMS_OUTPUT.put_line(‘NOK’);
END IF;

END SP_CONFERE_NM_FUNCIONARIO


--Função PIVOT--

SELECT e.manager_id, e.department_id, 
       count(e.employee_id) 
  FROM hr.employees e
 GROUP BY e.manager_id, e.department_id
 ORDER BY e.manager_id, e.department_id;

SELECT * FROM
 (SELECT manager_id, department_id, 
         employee_id 
    FROM hr.employees
 )
PIVOT
 (
 COUNT(employee_id)
 FOR department_id IN (10, 20, 30, 50, 60, 80, 90)
 )
ORDER BY manager_id

SELECT e.manager_id, d.department_name, 
       count(e.employee_id) 
  FROM hr.employees e
 INNER JOIN hr.departments d
    ON e.department_id = d.department_id
 GROUP BY e.manager_id, d.department_name
 ORDER BY e.manager_id, d.department_name;
   
WITH valores_pivot
AS
(
  SELECT e.manager_id manager_id, d.department_name department_name, 
         e.employee_id qtd_empregados
  FROM hr.employees e
 INNER JOIN hr.departments d
    ON e.department_id = d.department_id
)
SELECT * FROM valores_pivot
  PIVOT
 (
   COUNT(qtd_empregados)
   FOR department_name IN ('IT', 'Administration', 'Executive', 'Marketing',
                           'Purchasing', 'Sales', 'Shipping') 
 )
 ORDER BY manager_id;

--TO_CHAR--

SELECT to_char(hire_date, 'YYYYMMDD') AS "TO_CHAR"
  FROM hr.employees;

--TO_DATE--

SELECT to_date(hire_date, 'YYYYMMDD') AS "TO_DATE"
  FROM dual;

--STDDEV--

SELECT department_id AS DPTO,
       hire_date,
       last_name,
       salary,
       STDDEV(salary) OVER (ORDER BY hire_date) AS STDDEV
  FROM hr.employees
 WHERE department_id IN (60);
 
SELECT department_id AS DPTO,
       hire_date,
       last_name,
       salary,
       STDDEV(salary) 
        OVER (PARTITION BY department_id ORDER BY hire_date) AS STDDEV
  FROM hr.employees
 WHERE department_id IN (60, 30, 40);

--ROUND--

SELECT first_name,
       salary / 2.7,
 round(salary / 2.7) AS ROUND,
  FROM hr.employees
 WHERE job_id ='IT_PROG';

--TRUNC--

SELECT first_name,
       salary / 2.7,
 round(salary / 2.7) AS ROUND,
 trunc(salary / 2.7) AS TRUNC
  FROM hr.employees
 WHERE job_id ='IT_PROG';
