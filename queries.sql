-- 2. Создайте таблицу "История изменений товаров". Как минимум 
--    она должна содержать следующие поля: 
  -- 1. ID товара
  -- 2. Поле типа ENUM, которое перечисляет случившееся с товаром событие: 
  --    создание нового (create), изменение цены (price), удаление товара (delete)
  -- 3. Старая цена (заполняется при событии price)
  -- 4. Новая цена (заполняется при событии price)
  -- 5. Метка даты и времени, когда произошло изменение

  CREATE TABLE change_history (
    id SERIAL PRIMARY KEY NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    event ENUM('create', 'price', 'delete') NOT NULL,
    old_price DECIMAL(10, 2),
    new_price DECIMAL(10, 2),
    created_at DATETIME NOT NULL
  )

-- 3. Заполните таблицу случайными, но осмысленными данными
  INSERT INTO change_history (
    product_id,
    event,
    old_price,
    new_price,
    created_at
  ) 
  VALUES 
  (1 , 'price',  1500.00, 1700.00, '2018-06-12 16:18:09'),
  (10, 'price',  60.00,   50.00,   '2018-06-12 16:47:04'),
  (25, 'create', null,    50.00,   '2018-06-12 17:06:56'),
  (25, 'delete', 50.00,   null,    '2018-06-12 17:12:03')

-- 4. Создайте представления "Новые товары" и "Товары, цена 
--    которых изменялась не менее 3 раз"

  -- новые товары
  CREATE VIEW new_products AS
  SELECT  products.*
  FROM change_history
    INNER JOIN products ON change_history.product_id = products.id
  WHERE event = 'create'

  -- товары, цена которых изменялась не менее 3 раз
  CREATE VIEW changed_at_least_three_times AS
  SELECT  products.*, COUNT(change_history.product_id) AS changed
  FROM change_history
    INNER JOIN products ON change_history.product_id = products.id
  GROUP BY change_history.product_id
  HAVING COUNT(change_history.product_id) >= 3