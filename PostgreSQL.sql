/*
PostgreSQL
    Схема:
    projects — проекты (id, название, город, даты, бюджет)
    cities — города (id, название)
    contractors — подрядчики (id, название, специализация)
    project_contractors — связь проектов и подрядчиков (id проекта, id подрядчика, сумма договора)
    employees — сотрудники (id, ФИО, должность, зарплата, отдел)
    departments — отделы (id, название)
    project_employees — участие сотрудников в проектах (id проекта, id сотрудника, роль, часы)
    materials — материалы (id, название, цена за единицу)
    project_materials — материалы в проектах (id проекта, id материала, количество)
    stages — этапы проекта (id, проект, название, плановые и фактические даты)
*/

CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- отделы
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- сотрудники
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    position VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    department_id INTEGER REFERENCES departments(id)
);

-- подрядчики
CREATE TABLE contractors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

-- материалы
CREATE TABLE materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- проекты
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    city_id INTEGER REFERENCES cities(id),
    start_date DATE NOT NULL,
    end_date DATE,
    budget DECIMAL(15, 2) NOT NULL
);

-- таблица связи проектов и подрядчиков
CREATE TABLE project_contractors (
    project_id INTEGER REFERENCES projects(id),
    contractor_id INTEGER REFERENCES contractors(id),
    contract_amount DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (project_id, contractor_id)
);

-- таблица участия сотрудников в проектах
CREATE TABLE project_employees (
    project_id INTEGER REFERENCES projects(id),
    employee_id INTEGER REFERENCES employees(id),
    role VARCHAR(100) NOT NULL,
    hours INTEGER NOT NULL,
    PRIMARY KEY (project_id, employee_id)
);

-- материалы в проектах
CREATE TABLE project_materials (
    project_id INTEGER REFERENCES projects(id),
    material_id INTEGER REFERENCES materials(id),
    quantity DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (project_id, material_id)
);

-- этапы проекта
CREATE TABLE stages (
    id SERIAL PRIMARY KEY,
    project_id INTEGER REFERENCES projects(id),
    name VARCHAR(100) NOT NULL,
    planned_start_date DATE NOT NULL,
    planned_end_date DATE NOT NULL,
    actual_start_date DATE,
    actual_end_date DATE
);


/*
Задачи	
    Вывести список строительных объектов и количество подрядчиков, работающих на каждом объекте.	1
    Определить сотрудников, которые участвовали более чем в трёх проектах одновременно.	2
    Для каждого строительного объекта вывести общую стоимость использованных материалов и количество различных типов материалов.	3
    Найти подрядчиков, у которых средняя стоимость выполненных работ выше средней стоимости по всем подрядчикам.	4
    Для каждого проекта определить этап, на котором было задействовано наибольшее количество сотрудников.	5
    Вывести список объектов, где суммарная продолжительность задержек по этапам превышает 30 дней.	6
    Для каждого подрядчика определить его самый крупный по стоимости проект.	7
    Определить материалы, которые использовались в проектах не менее чем в пяти разных городах.	8
    Для каждого сотрудника вывести его зарплату и позицию в рейтинге зарплат внутри отдела.	9
    Определить проекты, в которых ежемесячный объём выполненных работ последовательно увеличивался в течение трёх месяцев подряд.	10
*/



/* 1. Список объектов и количество подрядчиков на каждом */
SELECT 
    p.title, 
    COUNT(pc.contractor_id) AS contractors_count
FROM projects p
LEFT JOIN project_contractors pc ON p.id = pc.project_id
GROUP BY p.id, p.title;


/* 2. Сотрудники, участвовавшие более чем в трёх проектах одновременно (упрощенный вариант) */
SELECT 
    e.full_name, 
    COUNT(DISTINCT p1.id) AS simultaneous_projects
FROM employees e
JOIN project_employees pe1 ON e.id = pe1.employee_id
JOIN projects p1 ON pe1.project_id = p1.id
JOIN project_employees pe2 ON e.id = pe2.employee_id
JOIN projects p2 ON pe2.project_id = p2.id
WHERE p1.id <> p2.id 
  AND p1.start_date <= COALESCE(p2.end_date, '2026-12-31') 
  AND p2.start_date <= COALESCE(p1.end_date, '2026-12-31')
GROUP BY e.id, e.full_name
HAVING COUNT(DISTINCT p1.id) > 3;


/* 3. Стоимость материалов и количество их типов для каждого объекта */
SELECT 
    p.title, 
    SUM(pm.quantity * m.unit_price) AS total_materials_cost,
    COUNT(DISTINCT pm.material_id) AS material_types_count
FROM projects p
LEFT JOIN project_materials pm ON p.id = pm.project_id
LEFT JOIN materials m ON pm.material_id = m.id
GROUP BY p.id, p.title;


/* 4. Подрядчики со средней стоимостью работ выше средней по всем подрядчикам */
SELECT 
    c.name, 
    AVG(pc.contract_amount) AS avg_contract
FROM contractors c
JOIN project_contractors pc ON c.id = pc.contractor_id
GROUP BY c.id, c.name
HAVING AVG(pc.contract_amount) > (SELECT AVG(contract_amount) FROM project_contractors);


/* 5. Этап с наибольшим количеством сотрудников для каждого проекта */
SELECT project_title, stage_name, emp_count
FROM (
    SELECT 
        p.title AS project_title, 
        s.name AS stage_name,
        COUNT(pe.employee_id) AS emp_count,
        RANK() OVER (PARTITION BY p.id ORDER BY COUNT(pe.employee_id) DESC) as rnk
    FROM projects p
    JOIN stages s ON p.id = s.project_id
    JOIN project_employees pe ON p.id = pe.project_id
    GROUP BY p.id, p.title, s.id, s.name
) t
WHERE rnk = 1;


/* 6. Объекты с суммарной задержкой по этапам более 30 дней */
SELECT 
    p.title, 
    SUM(s.actual_end_date - s.planned_end_date) AS total_delay
FROM projects p
JOIN stages s ON p.id = s.project_id
WHERE s.actual_end_date > s.planned_end_date
GROUP BY p.id, p.title
HAVING SUM(s.actual_end_date - s.planned_end_date) > 30;


/* 7. Самый крупный проект для каждого подрядчика */
SELECT contractor_name, project_title, contract_amount
FROM (
    SELECT 
        c.name AS contractor_name, 
        p.title AS project_title, 
        pc.contract_amount,
        ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY pc.contract_amount DESC) as rn
    FROM contractors c
    JOIN project_contractors pc ON c.id = pc.contractor_id
    JOIN projects p ON pc.project_id = p.id
) t
WHERE rn = 1;


/* 8. Материалы, использованные в проектах не менее чем в 5 разных городах */
SELECT 
    m.name
FROM materials m
JOIN project_materials pm ON m.id = pm.material_id
JOIN projects p ON pm.project_id = p.id
GROUP BY m.id, m.name
HAVING COUNT(DISTINCT p.city_id) >= 5;


/* 9. Зарплата и рейтинг зарплат внутри отдела */
SELECT 
    full_name, 
    salary, 
    department_id,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as salary_rank
FROM employees;


/* 10. Проекты с ежемесячным ростом объема работ (имитация по часам) */
-- Примечание: Для 2026 года расчет требует наличия периодических данных (например, таблицы логов).
-- Ниже представлен логический запрос для поиска роста в течение 3 месяцев подряд.
WITH MonthlyVolume AS (
    -- Предполагаем наличие таблицы отчетов или связи часов сотрудника с датами в проекте
    -- В данной схеме точный расчет невозможен без таблицы "выполненных работ по датам"
    SELECT 
        project_id, 
        DATE_TRUNC('month', start_date) as month_date, -- Пример на основе дат проекта
        SUM(budget / 12) as monthly_vol -- Имитация распределения бюджета
    FROM projects
    GROUP BY project_id, month_date
)
SELECT DISTINCT p.title
FROM MonthlyVolume v1
JOIN MonthlyVolume v2 ON v1.project_id = v2.project_id AND v2.month_date = v1.month_date + INTERVAL '1 month'
JOIN MonthlyVolume v3 ON v2.project_id = v3.project_id AND v3.month_date = v2.month_date + INTERVAL '1 month'
JOIN projects p ON v1.project_id = p.id
WHERE v2.monthly_vol > v1.monthly_vol AND v3.monthly_vol > v2.monthly_vol;

























