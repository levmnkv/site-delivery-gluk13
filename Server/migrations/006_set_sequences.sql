-- Устанавливаем значения последовательностей
SELECT setval('permissions_id_seq', COALESCE((SELECT MAX(id) FROM permissions), 1), false);
SELECT setval('products_id_seq', COALESCE((SELECT MAX(id) FROM products), 1), false);
SELECT setval('roles_id_seq', COALESCE((SELECT MAX(id) FROM roles), 1), false);
SELECT setval('users_id_seq', COALESCE((SELECT MAX(id) FROM users), 1), false);