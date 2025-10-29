-- Permissions
INSERT INTO permissions (id, code, description) VALUES
(1, 'view_products', 'Просмотр товаров'),
(2, 'create_product', 'Создание товаров'),
(3, 'edit_product', 'Редактирование товаров'),
(4, 'delete_product', 'Удаление товаров'),
(5, 'view_orders', 'Просмотр заказов'),
(6, 'edit_order', 'Редактирование заказов'),
(7, 'manager_users', 'Управление пользователями')
ON CONFLICT (id) DO NOTHING;

-- Roles
INSERT INTO roles (id, name) VALUES
(1, 'customer'),
(2, 'admin'),
(3, 'manager')
ON CONFLICT (id) DO NOTHING;

-- Role-Permissions
INSERT INTO role_permissions (role_id, permission_id) VALUES
(1, 1), (1, 5),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7),
(3, 1), (3, 2), (3, 3), (3, 5), (3, 6)
ON CONFLICT (role_id, permission_id) DO NOTHING;


