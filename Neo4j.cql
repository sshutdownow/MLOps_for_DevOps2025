/*
Neo4j
Cхемы графа
    (Customer) — клиент, атрибуты: customer_id, name, city.
    (Order) — заказ, атрибуты: order_id, date, total_amount.
    (Product) — товар, атрибуты: product_id, name, category, price.
    (Courier) — курьер, атрибуты: courier_id, name, transport.
    (Warehouse) — склад, атрибуты: warehouse_id, city, capacity.
    (City) — город, атрибуты: city_id, name.

Основные связи:
    (Customer)-[:PLACED]->(Order) — клиент оформил заказ.
    (Order)-[:CONTAINS]->(Product) — заказ содержит товар.
    (Order)-[:DELIVERED_BY]->(Courier) — заказ доставлен курьером.
    (Order)-[:FROM]->(Warehouse) — заказ отправлен со склада.
    (Warehouse)-[:LOCATED_IN]->(City) — склад находится в городе.
    (Customer)-[:LIVES_IN]->(City) — клиент живёт в городе.
    (Courier)-[:OPERATES_IN]->(City) — курьер работает в городе.
*/


MATCH (n)
CALL (n) {
 DETACH DELETE n
} IN TRANSACTIONS;

CREATE
(c1:Customer { customer_id: 1, name: "client01", city: "МСК"}),
(c2:Customer { customer_id: 2, name: "client02", city: "МСК"}),
(c3:Customer { customer_id: 3, name: "client03", city: "СПб"}),

(o1:Order { order_id: 1, order_date: date("2025-01-01"), total_amount: 1000 }),
(o2:Order { order_id: 2, order_date: date("2025-02-01"), total_amount: 100 }),
(o3:Order { order_id: 3, order_date: date("2025-03-01"), total_amount: 200 }),
(o4:Order { order_id: 4, order_date: date("2025-04-01"), total_amount: 300 }),
(o5:Order { order_id: 5, order_date: date("2025-05-01"), total_amount: 500 }),

(p1:Product {product_id: 1, name: "prd01", category: "ctg01", price: 100 }),
(p2:Product {product_id: 2, name: "prd02", category: "ctg01", price: 200 }),
(p3:Product {product_id: 3, name: "prd03", category: "ctg02", price: 500 }),
(p4:Product {product_id: 4, name: "prd04", category: "ctg03", price: 500 }),

(cr1:Courier {courier_id: 1, name: "cr01", transport: "tr01"}),
(cr2:Courier {courier_id: 2, name: "cr02", transport: "tr02"}),
(cr3:Courier {courier_id: 3, name: "cr03", transport: "tr03"}),
(cr4:Courier {courier_id: 4, name: "cr04", transport: "tr04"}),

(w1:Warehouse {warehouse_id: 1, city: "МСК", capacity: 2000000}),
(w2:Warehouse {warehouse_id: 2, city: "СПб", capacity: 1000000}),

(ct1:City {city_id: 1 , name: "МСК"}),
(ct2:City {city_id: 2 , name: "СПб"}),

// клиент оформил заказ.
(c1)-[:PLACED]->(o1),
(c1)-[:PLACED]->(o2),
(c2)-[:PLACED]->(o3),
(c2)-[:PLACED]->(o4),
(c3)-[:PLACED]->(o5),

// заказ содержит товар.
(o1)-[:CONTAINS]->(p1),
(o1)-[:CONTAINS]->(p2),

(o2)-[:CONTAINS]->(p1),

(o3)-[:CONTAINS]->(p2),

(o4)-[:CONTAINS]->(p1),
(o4)-[:CONTAINS]->(p2),

(o5)-[:CONTAINS]->(p4),


//  заказ доставлен курьером.
(o1)-[:DELIVERED_BY]->(cr1),
(o2)-[:DELIVERED_BY]->(cr1),
(o3)-[:DELIVERED_BY]->(cr2),
(o4)-[:DELIVERED_BY]->(cr3),
(o5)-[:DELIVERED_BY]->(cr4),

// заказ отправлен со склада.
(o1)-[:FROM]->(w1),
(o2)-[:FROM]->(w1),
(o3)-[:FROM]->(w1),
(o4)-[:FROM]->(w1),
(o5)-[:FROM]->(w2),

// склад находится в городе.
(w1)-[:LOCATED_IN]->(ct1),
(w2)-[:LOCATED_IN]->(ct2),

// клиент живёт в городе.
(c1)-[:LIVES_IN]->(ct1),
(c2)-[:LIVES_IN]->(ct1),
(c3)-[:LIVES_IN]->(ct2),


// курьер работает в городе.
(cr1)-[:OPERATES_IN]->(ct1),
(cr2)-[:OPERATES_IN]->(ct1),
(cr3)-[:OPERATES_IN]->(ct1),
(cr4)-[:OPERATES_IN]->(ct2);

// Определить для каждого клиента общее количество заказов и суммарную стоимость доставленных товаров.
MATCH (c:Customer)-[:PLACED]->(o:Order)-[:DELIVERED_BY]->(:Courier)
RETURN c.name, count(DISTINCT o), sum(o.total_amount);

// Для каждого склада вывести топ‑3 самых популярных товаров по количеству отправок.
MATCH (w:Warehouse)<-[:FROM]-(o:Order)-[:CONTAINS]->(p:Product)
WITH w.warehouse_id AS warehouse_id, p.product_id AS product_id, collect(distinct o.order_id) AS send_count
ORDER BY warehouse_id, size(send_count) DESC
RETURN warehouse_id, product_id, send_count





// 1. Общее количество заказов и суммарная стоимость доставленных товаров для каждого клиента
MATCH (c:Customer)-[:PLACED]->(o:Order)
RETURN c.name AS Customer, 
       count(o) AS TotalOrders, 
       sum(o.total_amount) AS TotalSpent;

// 2. Курьеры, которые доставляли заказы в более чем трёх разных городах
MATCH (cr:Courier)<-[:DELIVERED_BY]-(o:Order)-[:FROM]->(w:Warehouse)-[:LOCATED_IN]->(ct:City)
WITH cr, count(DISTINCT ct) AS distinct_cities
WHERE distinct_cities > 3
RETURN cr.name AS Courier, distinct_cities AS CitiesCount;

// 3. Для каждого склада топ‑3 самых популярных товаров по количеству отправок
MATCH (w:Warehouse)<-[:FROM]-(o:Order)-[:CONTAINS]->(p:Product)
WITH w, p, count(*) AS sales
ORDER BY w.warehouse_id, sales DESC
WITH w, collect({product: p.name, sales: sales}) AS list
RETURN w.city AS Warehouse_City, 
       w.warehouse_id AS ID, 
       list[0..3] AS Top_3_Products;

// 4. Маршруты доставки, где время превышало среднее (на основе total_amount как прокси-метрики нагрузки, 
// так как явного времени в данных нет)
MATCH (o:Order)
WITH avg(o.total_amount) AS avg_val
MATCH (o:Order)-[:FROM]->(w:Warehouse), (o)-[:DELIVERED_BY]->(cr:Courier)
WHERE o.total_amount > avg_val
RETURN o.order_id AS Order_ID, w.city AS From_City, cr.name AS Courier, o.total_amount AS Value;

// 5. «Любимый» товар для каждого клиента (заказываемый чаще всего)
MATCH (c:Customer)-[:PLACED]->(o:Order)-[:CONTAINS]->(p:Product)
WITH c, p, count(*) AS product_count
ORDER BY product_count DESC
WITH c, collect(p.name)[0] AS favorite_product
RETURN c.name AS Customer, favorite_product AS Favorite_Item;

// 6. Курьеры, которые работали совместно (доставляли заказы одним и тем же клиентам)
MATCH (c:Customer)-[:PLACED]->(o1:Order)-[:DELIVERED_BY]->(cr1:Courier)
MATCH (c)-[:PLACED]->(o2:Order)-[:DELIVERED_BY]->(cr2:Courier)
WHERE id(cr1) < id(cr2)
RETURN DISTINCT cr1.name AS Courier_A, cr2.name AS Courier_B, c.name AS Common_Customer;

// 7. Количество уникальных клиентов, получивших заказы в каждом городе
MATCH (ct:City)<-[:LIVES_IN]-(c:Customer)-[:PLACED]->(o:Order)
RETURN ct.name AS City, count(DISTINCT c) AS Unique_Customers;

// 8. Товары, которые были доставлены не менее чем в пяти разных городах
MATCH (p:Product)<-[:CONTAINS]-(o:Order)-[:FROM]->(w:Warehouse)-[:LOCATED_IN]->(ct:City)
WITH p, count(DISTINCT ct) AS city_count
WHERE city_count >= 5
RETURN p.name AS Product, city_count AS Delivered_In_Cities;

// 9. Клиенты, которые оформили заказы в трёх последовательных месяцах подряд (с использованием разности индексов)
MATCH (c:Customer)-[:PLACED]->(o:Order)
WITH c, o.order_date.year * 12 + o.order_date.month AS monthIdx
ORDER BY monthIdx
WITH c, collect(DISTINCT monthIdx) AS months
UNWIND range(0, size(months) - 3) AS i
WITH c, months[i] AS m1, months[i+1] AS m2, months[i+2] AS m3
WHERE m2 = m1 + 1 AND m3 = m2 + 1
RETURN DISTINCT c.name AS Persistent_Customer;

// 10. Рейтинг курьеров по количеству заказов внутри города (Имитация RANK() через индекс коллекции)
MATCH (ct:City)<-[:OPERATES_IN]-(cr:Courier)<-[:DELIVERED_BY]-(o:Order)
WITH ct, cr, count(o) AS order_count
ORDER BY ct.name, order_count DESC
WITH ct, collect({name: cr.name, total: order_count}) AS city_ranking
UNWIND range(0, size(city_ranking) - 1) AS idx
RETURN ct.name AS City, 
       (idx + 1) AS Rank, 
       city_ranking[idx].name AS Courier, 
       city_ranking[idx].total AS Orders_Done;
