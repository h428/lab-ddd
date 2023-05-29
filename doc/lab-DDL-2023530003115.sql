DROP TABLE IF EXISTS lab;
CREATE TABLE lab(
    id BIGINT NOT NULL,
    name VARCHAR(32) NOT NULL,
    desc_info VARCHAR(128) NOT NULL,
    belong_base_user_id BIGINT NOT NULL,
    create_base_user_id BIGINT NOT NULL,
    create_time BIGINT NOT NULL,
    update_base_user_id BIGINT NOT NULL,
    update_time BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT  0,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab IS '实验室';
COMMENT ON COLUMN lab.id IS 'id';
COMMENT ON COLUMN lab.name IS '名称';
COMMENT ON COLUMN lab.desc_info IS '描述信息';
COMMENT ON COLUMN lab.belong_base_user_id IS '所属用户 id';
COMMENT ON COLUMN lab.create_base_user_id IS '创建用户 id';
COMMENT ON COLUMN lab.create_time IS '创建时间';
COMMENT ON COLUMN lab.update_base_user_id IS '更新用户 id';
COMMENT ON COLUMN lab.update_time IS '更新时间';
COMMENT ON COLUMN lab.status IS '状态';
COMMENT ON COLUMN lab.deleted IS '是否删除';
COMMENT ON COLUMN lab.delete_time IS '删除时间';


CREATE INDEX idx_lab_belong_user_id ON lab(belong_base_user_id);

DROP TABLE IF EXISTS lab_apply;
CREATE TABLE lab_apply(
    id BIGINT NOT NULL,
    lab_in_id BIGINT NOT NULL,
    capacity_id BIGINT NOT NULL DEFAULT  0,
    num INTEGER NOT NULL,
    op_info VARCHAR(128) NOT NULL,
    op_time BIGINT NOT NULL,
    confirm_time BIGINT NOT NULL DEFAULT  0,
    from_lab_shelf_id BIGINT NOT NULL,
    to_lab_shelf_id BIGINT NOT NULL,
    from_lab_user_id BIGINT NOT NULL DEFAULT  0,
    to_lab_user_id BIGINT NOT NULL DEFAULT  0,
    confirm_lab_user_id BIGINT NOT NULL DEFAULT  0,
    move BOOLEAN NOT NULL DEFAULT  FALSE,
    lab_item_id BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    status SMALLINT NOT NULL DEFAULT  0,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_apply IS '申请/归还';
COMMENT ON COLUMN lab_apply.id IS 'id';
COMMENT ON COLUMN lab_apply.lab_in_id IS '入库时分配的唯一id';
COMMENT ON COLUMN lab_apply.capacity_id IS '每件容量品消耗后生成的 id';
COMMENT ON COLUMN lab_apply.num IS '数量';
COMMENT ON COLUMN lab_apply.op_info IS '申请归还描述';
COMMENT ON COLUMN lab_apply.op_time IS '发起申请/归还时间';
COMMENT ON COLUMN lab_apply.confirm_time IS '确认时间';
COMMENT ON COLUMN lab_apply.from_lab_shelf_id IS '发起操作的架子';
COMMENT ON COLUMN lab_apply.to_lab_shelf_id IS '与操作相关的另一个架子';
COMMENT ON COLUMN lab_apply.from_lab_user_id IS '冗余列，发起操作的用户，优化查询';
COMMENT ON COLUMN lab_apply.to_lab_user_id IS '冗余列，与操作相关的另一个用户，优化查询';
COMMENT ON COLUMN lab_apply.confirm_lab_user_id IS '审批人';
COMMENT ON COLUMN lab_apply.move IS '是否移动操作';
COMMENT ON COLUMN lab_apply.lab_item_id IS '物品，冗余列，优化查询';
COMMENT ON COLUMN lab_apply.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_apply.status IS '申请/归还单状态';
COMMENT ON COLUMN lab_apply.deleted IS '是否删除';
COMMENT ON COLUMN lab_apply.delete_time IS '删除时间';


CREATE INDEX idx_lab_apply_from_lab_shelf_id ON lab_apply(from_lab_shelf_id);
CREATE INDEX idx_lab_apply_from_lab_user_id_and_op_time ON lab_apply(from_lab_user_id,op_time);
CREATE INDEX idx_lab_apply_lab_id_and_op_time ON lab_apply(lab_id,op_time);
CREATE INDEX idx_lab_apply_lab_item_id_and_op_time ON lab_apply(lab_item_id,op_time);
CREATE INDEX idx_lab_apply_origin_id_and_op_time ON lab_apply(lab_in_id,op_time);
CREATE INDEX idx_lab_apply_to_lab_shelf_id ON lab_apply(to_lab_shelf_id);
CREATE INDEX idx_lab_apply_to_lab_user_id_and_op_time ON lab_apply(to_lab_user_id,op_time);

DROP TABLE IF EXISTS lab_in;
CREATE TABLE lab_in(
    id BIGINT NOT NULL,
    lab_item_id BIGINT NOT NULL,
    num INTEGER NOT NULL,
    price INTEGER NOT NULL,
    op_info VARCHAR(128) NOT NULL,
    op_time BIGINT NOT NULL DEFAULT  0,
    op_lab_shelf_id BIGINT NOT NULL,
    op_lab_user_id BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_in IS '入库';
COMMENT ON COLUMN lab_in.id IS '入库时分配的唯一id';
COMMENT ON COLUMN lab_in.lab_item_id IS '对应的物品';
COMMENT ON COLUMN lab_in.num IS '数量';
COMMENT ON COLUMN lab_in.price IS '价格';
COMMENT ON COLUMN lab_in.op_info IS '入库描述';
COMMENT ON COLUMN lab_in.op_time IS '入库时间';
COMMENT ON COLUMN lab_in.op_lab_shelf_id IS '入库架子';
COMMENT ON COLUMN lab_in.op_lab_user_id IS '入库用户';
COMMENT ON COLUMN lab_in.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_in.deleted IS '是否删除';
COMMENT ON COLUMN lab_in.delete_time IS '删除时间';


CREATE INDEX idx_lab_in_lab_id_and_op_time ON lab_in(lab_id,op_time);
CREATE INDEX idx_lab_in_lab_item_id_and_op_time ON lab_in(lab_item_id,op_time);

DROP TABLE IF EXISTS lab_inventory;
CREATE TABLE lab_inventory(
    id BIGINT NOT NULL,
    lab_shelf_id BIGINT NOT NULL,
    lab_in_id BIGINT NOT NULL,
    capacity_id BIGINT NOT NULL DEFAULT  0,
    num INTEGER NOT NULL,
    capacity INTEGER NOT NULL DEFAULT  0,
    lab_id BIGINT NOT NULL,
    lab_item_id BIGINT NOT NULL,
    lab_user_id BIGINT NOT NULL DEFAULT  0,
    version INTEGER NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_inventory IS '仓库架子物品';
COMMENT ON COLUMN lab_inventory.id IS '主键';
COMMENT ON COLUMN lab_inventory.lab_shelf_id IS '所属架子';
COMMENT ON COLUMN lab_inventory.lab_in_id IS '入库或首次申请时分配到的id';
COMMENT ON COLUMN lab_inventory.capacity_id IS '每件容量品消耗后生成的 id';
COMMENT ON COLUMN lab_inventory.num IS '数量';
COMMENT ON COLUMN lab_inventory.capacity IS '容量';
COMMENT ON COLUMN lab_inventory.lab_id IS '冗余列：所属仓库';
COMMENT ON COLUMN lab_inventory.lab_item_id IS '冗余列：物品 id';
COMMENT ON COLUMN lab_inventory.lab_user_id IS '冗余列：实验室用户 id';
COMMENT ON COLUMN lab_inventory.version IS '乐观锁版本';


CREATE INDEX idx_lab_inventory_lab_id ON lab_inventory(lab_id);
CREATE INDEX idx_lab_inventory_lab_in_id ON lab_inventory(lab_in_id);
CREATE INDEX idx_lab_inventory_lab_item_id ON lab_inventory(lab_item_id);
CREATE INDEX idx_lab_inventory_lab_user_id ON lab_inventory(lab_user_id);
CREATE INDEX idx_lab_inventory_real_id ON lab_inventory(lab_shelf_id,lab_in_id,capacity_id);

DROP TABLE IF EXISTS lab_item;
CREATE TABLE lab_item(
    id BIGINT NOT NULL,
    name VARCHAR(32) NOT NULL,
    eng_name VARCHAR(128) NOT NULL,
    desc_info VARCHAR(128) NOT NULL,
    price INTEGER NOT NULL,
    unit VARCHAR(16) NOT NULL,
    item_no VARCHAR(32) NOT NULL,
    cas VARCHAR(16) NOT NULL,
    floated BOOLEAN NOT NULL DEFAULT  FALSE,
    update_lab_user_id BIGINT NOT NULL,
    update_time BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    capacity INTEGER NOT NULL,
    capacity_unit VARCHAR(16) NOT NULL,
    create_lab_user_id BIGINT NOT NULL,
    create_time BIGINT NOT NULL,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_item IS '仓库物品';
COMMENT ON COLUMN lab_item.id IS 'id';
COMMENT ON COLUMN lab_item.name IS '名称';
COMMENT ON COLUMN lab_item.eng_name IS '英文名';
COMMENT ON COLUMN lab_item.desc_info IS '描述信息';
COMMENT ON COLUMN lab_item.price IS '单价(分)';
COMMENT ON COLUMN lab_item.unit IS '计量单位';
COMMENT ON COLUMN lab_item.item_no IS '货号';
COMMENT ON COLUMN lab_item.cas IS 'cas 编号';
COMMENT ON COLUMN lab_item.floated IS '是否支持浮点数操作';
COMMENT ON COLUMN lab_item.update_lab_user_id IS '更新用户';
COMMENT ON COLUMN lab_item.update_time IS '更新时间';
COMMENT ON COLUMN lab_item.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_item.capacity IS '规格品的规格量，0 表示非规格品';
COMMENT ON COLUMN lab_item.capacity_unit IS '规格品单位';
COMMENT ON COLUMN lab_item.create_lab_user_id IS '创建用户';
COMMENT ON COLUMN lab_item.create_time IS '创建时间';
COMMENT ON COLUMN lab_item.deleted IS '是否删除';
COMMENT ON COLUMN lab_item.delete_time IS '删除时间';


CREATE INDEX idx_lab_item_lab_id ON lab_item(lab_id);
CREATE INDEX idx_lab_item_name ON lab_item(name,eng_name,desc_info);

DROP TABLE IF EXISTS lab_join_link;
CREATE TABLE lab_join_link(
    id BIGINT NOT NULL,
    link CHAR(20) NOT NULL,
    lab_id BIGINT NOT NULL,
    lab_role_id BIGINT NOT NULL,
    create_time BIGINT NOT NULL,
    create_lab_user_id BIGINT NOT NULL,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_join_link IS '添加到仓库的链接';
COMMENT ON COLUMN lab_join_link.id IS 'id';
COMMENT ON COLUMN lab_join_link.link IS '链接';
COMMENT ON COLUMN lab_join_link.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_join_link.lab_role_id IS '授权角色';
COMMENT ON COLUMN lab_join_link.create_time IS '创建时间';
COMMENT ON COLUMN lab_join_link.create_lab_user_id IS '创建人';


CREATE UNIQUE INDEX idx_lab_join_link_link ON lab_join_link(link);
CREATE INDEX idx_lab_join_link_lab_id ON lab_join_link(lab_id);

DROP TABLE IF EXISTS lab_out;
CREATE TABLE lab_out(
    id BIGINT NOT NULL,
    lab_in_id BIGINT NOT NULL,
    capacity_id BIGINT NOT NULL DEFAULT  0,
    num INTEGER NOT NULL,
    op_info VARCHAR(128) NOT NULL,
    op_time BIGINT NOT NULL DEFAULT  0,
    op_lab_shelf_id BIGINT NOT NULL,
    op_lab_user_id BIGINT NOT NULL,
    lab_item_id BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_out IS '消耗';
COMMENT ON COLUMN lab_out.id IS 'id';
COMMENT ON COLUMN lab_out.lab_in_id IS '入库时分配的唯一id';
COMMENT ON COLUMN lab_out.capacity_id IS '单个容量品消耗后生成的 id';
COMMENT ON COLUMN lab_out.num IS '数量';
COMMENT ON COLUMN lab_out.op_info IS '消耗描述';
COMMENT ON COLUMN lab_out.op_time IS '操作时间';
COMMENT ON COLUMN lab_out.op_lab_shelf_id IS '消耗架子';
COMMENT ON COLUMN lab_out.op_lab_user_id IS '消耗用户';
COMMENT ON COLUMN lab_out.lab_item_id IS '物品，冗余列，用于优化查询';
COMMENT ON COLUMN lab_out.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_out.deleted IS '是否删除';
COMMENT ON COLUMN lab_out.delete_time IS '删除时间';


CREATE INDEX idx_lab_out_lab_id_and_op_time ON lab_out(lab_id,op_time);
CREATE INDEX idx_lab_out_lab_item_id_and_op_time ON lab_out(lab_item_id,op_time);
CREATE INDEX idx_lab_out_op_lab_user_id_and_op_time ON lab_out(op_lab_user_id,op_time);
CREATE INDEX idx_lab_out_origin_id_and_op_time ON lab_out(lab_in_id,op_time);

DROP TABLE IF EXISTS lab_perm;
CREATE TABLE lab_perm(
    id BIGINT NOT NULL,
    name VARCHAR(32) NOT NULL,
    tag VARCHAR(32) NOT NULL,
    pid BIGINT NOT NULL DEFAULT  0,
    is_nav BOOLEAN NOT NULL DEFAULT  FALSE,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_perm IS '权限，稳定的权限，和操作有关，和 hub 无关';
COMMENT ON COLUMN lab_perm.id IS 'id';
COMMENT ON COLUMN lab_perm.name IS '权限名称';
COMMENT ON COLUMN lab_perm.tag IS '标记';
COMMENT ON COLUMN lab_perm.pid IS '类别id，0表示该行是类别';
COMMENT ON COLUMN lab_perm.is_nav IS '是否导航栏';

DROP TABLE IF EXISTS lab_role;
CREATE TABLE lab_role(
    id BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    name VARCHAR(32) NOT NULL,
    desc_info VARCHAR(128) NOT NULL,
    lab_perms VARCHAR(1024) NOT NULL,
    create_lab_user_id BIGINT NOT NULL,
    create_time BIGINT NOT NULL DEFAULT  0,
    update_lab_user_id BIGINT NOT NULL,
    update_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_role IS '仓库角色';
COMMENT ON COLUMN lab_role.id IS 'id';
COMMENT ON COLUMN lab_role.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_role.name IS '角色名称';
COMMENT ON COLUMN lab_role.desc_info IS '描述信息';
COMMENT ON COLUMN lab_role.lab_perms IS '权限列表，使用 , 分隔';
COMMENT ON COLUMN lab_role.create_lab_user_id IS '更新用户 id';
COMMENT ON COLUMN lab_role.create_time IS '创建时间';
COMMENT ON COLUMN lab_role.update_lab_user_id IS '更新用户 id';
COMMENT ON COLUMN lab_role.update_time IS '更新时间';


CREATE INDEX idx_lab_role_lab_id ON lab_role(lab_id);

DROP TABLE IF EXISTS lab_shelf;
CREATE TABLE lab_shelf(
    id BIGINT NOT NULL,
    code VARCHAR(16) NOT NULL,
    name VARCHAR(32) NOT NULL,
    pos VARCHAR(32) NOT NULL,
    type SMALLINT NOT NULL,
    lab_id BIGINT NOT NULL,
    belong_lab_user_id BIGINT NOT NULL,
    create_lab_user_id BIGINT NOT NULL,
    create_time BIGINT NOT NULL DEFAULT  0,
    update_lab_user_id BIGINT NOT NULL,
    update_time BIGINT NOT NULL DEFAULT  0,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_shelf IS '仓库架子';
COMMENT ON COLUMN lab_shelf.id IS 'id';
COMMENT ON COLUMN lab_shelf.name IS '名称';
COMMENT ON COLUMN lab_shelf.pos IS '位置';
COMMENT ON COLUMN lab_shelf.type IS '类型：0 个人；1 公共；2 贮藏';
COMMENT ON COLUMN lab_shelf.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_shelf.belong_lab_user_id IS '架子所属用户，非私人架子则为0';
COMMENT ON COLUMN lab_shelf.create_lab_user_id IS '创建用户';
COMMENT ON COLUMN lab_shelf.create_time IS '添加时间';
COMMENT ON COLUMN lab_shelf.update_lab_user_id IS '更新用户';
COMMENT ON COLUMN lab_shelf.update_time IS '更新时间';
COMMENT ON COLUMN lab_shelf.deleted IS '是否删除';
COMMENT ON COLUMN lab_shelf.delete_time IS '删除时间';


CREATE INDEX idx_lab_shelf_lab_id ON lab_shelf(lab_id);
CREATE INDEX idx_lab_shelf_lab_user_id ON lab_shelf(belong_lab_user_id);

DROP TABLE IF EXISTS lab_user;
CREATE TABLE lab_user(
    id BIGINT NOT NULL,
    lab_id BIGINT NOT NULL,
    base_user_id BIGINT NOT NULL,
    name VARCHAR(32) NOT NULL,
    lab_role_id BIGINT NOT NULL,
    create_lab_user_id BIGINT NOT NULL,
    create_time BIGINT NOT NULL DEFAULT  0,
    update_lab_user_id BIGINT NOT NULL,
    update_time BIGINT NOT NULL DEFAULT  0,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE lab_user IS '仓库可用用户';
COMMENT ON COLUMN lab_user.id IS 'id';
COMMENT ON COLUMN lab_user.lab_id IS '所属仓库';
COMMENT ON COLUMN lab_user.base_user_id IS '可用用户';
COMMENT ON COLUMN lab_user.name IS '用户在该仓库的名称';
COMMENT ON COLUMN lab_user.lab_role_id IS '用户角色 id';
COMMENT ON COLUMN lab_user.create_lab_user_id IS '创建用户 id';
COMMENT ON COLUMN lab_user.create_time IS '创建时间';
COMMENT ON COLUMN lab_user.update_lab_user_id IS '更新用户 id';
COMMENT ON COLUMN lab_user.update_time IS '更新时间';
COMMENT ON COLUMN lab_user.deleted IS '是否删除';
COMMENT ON COLUMN lab_user.delete_time IS '删除时间';


CREATE INDEX idx_lab_user_base_user_id ON lab_user(base_user_id);
CREATE INDEX idx_lab_user_lab_id ON lab_user(lab_id);

DROP TABLE IF EXISTS base_user;
CREATE TABLE base_user(
    id BIGINT NOT NULL,
    email VARCHAR(32) NOT NULL,
    user_name VARCHAR(32) NOT NULL,
    user_pass VARCHAR(64) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    name VARCHAR(32) NOT NULL DEFAULT  '',
    phone VARCHAR(11) NOT NULL DEFAULT  '',
    wechat_no VARCHAR(32) NOT NULL DEFAULT  '',
    avatar VARCHAR(128) NOT NULL DEFAULT  '',
    create_time BIGINT NOT NULL DEFAULT  0,
    update_time BIGINT NOT NULL DEFAULT  0,
    last_login_time BIGINT NOT NULL DEFAULT  0,
    status SMALLINT NOT NULL DEFAULT  0,
    allow_add BOOLEAN NOT NULL DEFAULT  TRUE,
    allow_auth BOOLEAN NOT NULL DEFAULT  TRUE,
    allow_message BOOLEAN NOT NULL DEFAULT  TRUE,
    deleted BOOLEAN NOT NULL DEFAULT  FALSE,
    delete_time BIGINT NOT NULL DEFAULT  0,
    PRIMARY KEY (id)
);

COMMENT ON TABLE base_user IS '用户';
COMMENT ON COLUMN base_user.id IS 'id';
COMMENT ON COLUMN base_user.email IS '电子邮箱';
COMMENT ON COLUMN base_user.user_name IS '用户名';
COMMENT ON COLUMN base_user.user_pass IS '密码';
COMMENT ON COLUMN base_user.salt IS '盐值';
COMMENT ON COLUMN base_user.name IS '姓名';
COMMENT ON COLUMN base_user.phone IS '电话';
COMMENT ON COLUMN base_user.wechat_no IS '微信号';
COMMENT ON COLUMN base_user.avatar IS '头像';
COMMENT ON COLUMN base_user.create_time IS '注册时间';
COMMENT ON COLUMN base_user.update_time IS '更新时间';
COMMENT ON COLUMN base_user.last_login_time IS '上次登录时间';
COMMENT ON COLUMN base_user.status IS '状态';
COMMENT ON COLUMN base_user.allow_add IS '允许添加';
COMMENT ON COLUMN base_user.allow_auth IS '允许将认证信息供仓库用户使用';
COMMENT ON COLUMN base_user.allow_message IS '允许站内信';
COMMENT ON COLUMN base_user.deleted IS '是否删除';
COMMENT ON COLUMN base_user.delete_time IS '删除时间';


CREATE UNIQUE INDEX idx_base_user_email ON base_user(email);
CREATE UNIQUE INDEX idx_base_user_user_name ON base_user(user_name);
CREATE UNIQUE INDEX idx_base_user_phone ON base_user(phone);

