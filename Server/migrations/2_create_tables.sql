-- Создаем таблицы
CREATE TABLE IF NOT EXISTS permissions (
    id integer DEFAULT nextval('permissions_id_seq') NOT NULL,
    code character varying(100) NOT NULL,
    description text
);

CREATE TABLE IF NOT EXISTS products (
    id integer DEFAULT nextval('products_id_seq') NOT NULL,
    name character varying(255) NOT NULL,
    price numeric(10,2) NOT NULL,
    discount_percent numeric(5,2) DEFAULT NULL,
    discount_price numeric(10,2) GENERATED ALWAYS AS (price * (1 - discount_percent / 100)) STORED,
    category character varying(100),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
    image_url character varying(100),
    rating numeric(2,1),
    CONSTRAINT products_discount_percent_check CHECK ((discount_percent > 0 AND discount_percent < 100)),
    CONSTRAINT products_price_check CHECK (price > 0)
);

CREATE TABLE IF NOT EXISTS roles (
    id integer DEFAULT nextval('roles_id_seq') NOT NULL,
    name character varying(250) NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id integer DEFAULT nextval('users_id_seq') NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(200) NOT NULL,
    role_id integer,
    name character varying(255) DEFAULT 'Unknown' NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    address VARCHAR(255) NOT NULL,
    comment VARCHAR(255),
    order_number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'Новый' CHECK (status IN ('Новый', 'Собран', 'Доставляется', 'Возврат', 'Вернули', 'Закрыт')),
    total_amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);

CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);