-- Primary Keys
ALTER TABLE ONLY permissions ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY products ADD CONSTRAINT products_pkey PRIMARY KEY (id);
ALTER TABLE ONLY roles ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY role_permissions ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);

-- Unique Constraints
ALTER TABLE ONLY permissions ADD CONSTRAINT permissions_code_key UNIQUE (code);
ALTER TABLE ONLY roles ADD CONSTRAINT roles_name_key UNIQUE (name);
ALTER TABLE ONLY users ADD CONSTRAINT users_email_key UNIQUE (email);

-- Foreign Keys
ALTER TABLE ONLY role_permissions 
    ADD CONSTRAINT role_permissions_permission_id_fkey 
    FOREIGN KEY (permission_id) REFERENCES permissions(id);

ALTER TABLE ONLY role_permissions 
    ADD CONSTRAINT role_permissions_role_id_fkey 
    FOREIGN KEY (role_id) REFERENCES roles(id);

ALTER TABLE ONLY users 
    ADD CONSTRAINT users_role_id_fkey 
    FOREIGN KEY (role_id) REFERENCES roles(id);

ALTER TABLE order_items 
    ADD CONSTRAINT fk_order_items_order_id 
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;

ALTER TABLE order_items 
    ADD CONSTRAINT fk_order_items_product_id 
    FOREIGN KEY (product_id) REFERENCES products(id);
