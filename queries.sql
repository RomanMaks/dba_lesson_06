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

  -- создание нового (create)
  CREATE TRIGGER product_creat AFTER INSERT ON products
  FOR EACH ROW
    BEGIN
      INSERT INTO change_history
      SET
        product_id = NEW.id,
        event = 'create',
        new_price = NEW.price,
        created_at = CURRENT_TIMESTAMP;
    END;

  -- изменение цены (price)
  CREATE TRIGGER price BEFORE UPDATE ON products
  FOR EACH ROW
    IF (OLD.price != NEW.price) THEN
      BEGIN
        INSERT INTO change_history
        SET
          product_id = OLD.id,
          event = 'price',
          old_price = OLD.price,
          new_price = NEW.price,
          created_at = CURRENT_TIMESTAMP;
      END;
    END IF;

  -- удаление товара (delete)
  CREATE TRIGGER product_delete AFTER DELETE ON products
  FOR EACH ROW
    BEGIN
      INSERT INTO change_history
      SET
        product_id = OLD.id,
        event = 'delete',
        old_price = OLD.price,
        created_at = CURRENT_TIMESTAMP;
    END;

-- 3. Заполните таблицу случайными, но осмысленными данными

-- 4. Создайте представления "Новые товары" и "Товары, цена 
--    которых изменялась не менее 3 раз"