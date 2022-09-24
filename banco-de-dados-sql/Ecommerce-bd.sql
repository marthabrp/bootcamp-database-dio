 -- criacao do banco de dados para cenario de ecommerce --
 
 create database ecommerce;
 use ecommerce;
 
-- tabela cliente

create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Mnit char(3),
    Lname varchar(20),
	CPF char(11) not null,
    Address varchar(30),
    constraint unique_cpf_client unique(CPF)    
);

desc clients;
-- tabela produto
-- size = dimensao do produto
create table product(
	idProduto int auto_increment primary key,
    Pname varchar(10) not null,
    slassification_kids bool default false,
    sategory enum('Eletronico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Moveis') not null,
	savaliacao float default 0,
    size varchar(10)
);

-- tabela pagamento
create table payments(
	idClient int,
    idPayment int,
    typePayment enum ('cartaoCredito', 'cartaoDebito'),
    limiteAvailable float,
    constraint pk_payment primary key(idClient, idPayment)   
);
-- tabela pedido

create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum ('Cancelado', 'Confirmado', 'Em Processamento') default 'Em Processamento',
    orderDescription varchar(255),
	shippingValue float default 10,
    paymentStatus enum ('Aprovado','Nao Autorizado','Aguardando Pagamento') default 'Aguardando Pagamento',
    constraint  fk_orders_client foreign key (idOrderClient) references clients(idClient)
    -- constraint fk_payment foreign key (paymentStatus) references payments(idPayment)
); 

-- tabela estoque
create table productStorage(
	idProductStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

-- tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ varchar(15),
	constraint unique_supplier unique (CNPJ)
);

-- tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ varchar(15),
    location varchar (255),
    contact char(11) not null,
	constraint unique_cnpj_seller unique (CNPJ)
);

create table productSeller(
	idPseller int ,
    idPproduct int,
    proQuantity int default 1,
    primary key (idPseller, idPproduct),
	constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduto)
);

create table productOrder(
	idPOproduct int ,
    idPOrder int,
    poQuantity int default 1,
    poStatus enum('Disponivel', 'Sem estoque') default 'Disponivel',
    primary key (idPOproduct, idPOrder),
	constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduto),
    constraint fk_productorder_product foreign key (idPOrder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int ,
    idLstorage int,
    location varchar(255) not null,
    poStatus enum('Disponivel', 'Sem estoque') default 'Disponivel',
    primary key (idLproduct, idLstorage),
	constraint fk_products_seller foreign key (idLproduct) references product(idProduto),
    constraint fk_products_product foreign key (idLstorage) references productStorage(idProductStorage)
);

create table productSupplier(
	idPsSupplier int ,
    idPsProduct int,
	quantity int not null,
    primary key (idPsSupplier, idPsProduct),
	constraint fk_product_sup_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_sup_product foreign key (idPsProduct) references product(idProduto)
);

show tables;

show databases;
use information_schema;
show tables;
desc referencial_constraints;
select * from referencial_constraints where constraint_schema = 'ecommerce'