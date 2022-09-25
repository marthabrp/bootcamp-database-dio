-- Banco de dados - Oficina Mecanica

create database oficina;
use oficina;
show tables;
select * from clientes;

-- tabela clientes

create table clientes (
  IdCliente int primary key auto_increment,
  NomeCliente varchar (30),
  CPF char(11) unique, 
  Address varchar (100)
);
select * from clientes;
insert into clientes values
  ('1', 'Martha Rodrigues', '12345678911','Rua Getulio Vargas, 153'),
  ('2','James Smith', '2349681341','Rua General Carneiro, 226'),
  ('3','Marlyn Doe', '57829347424','Rua 25 de Marco, 678');
  
-- tabela veiculo
create table veiculo (
  IdVeiculo int primary key auto_increment,
  modeloVeiculo varchar (45),
  marca varchar (45),
  placa char(7) unique,
  ano date,
  idClientVeiculo int,
  constraint fk_veiculo_cliente foreign key (idClientVeiculo) references clientes(IdCliente) 
);

select * from veiculo;
insert into veiculo values
  ('11','Onix', 'Chevrolet','AAA1B33','2015-08-01','01'),
  ('12','Gol', 'Volkswagen','BBB2A44','2022-09-10','02'),
  ('13','Celta', 'General Motors','CCC2D55','2020-09-22','03');
  
-- tabela ordem servico 

create table ordem_de_servico (
  IdOS int primary key auto_increment,
  dataEmissaoOs date,
  status enum('Em analise','Aprovado','Em andamento','Concluido'),
  dataEntregaOs date,
  valor float,
  descricao varchar (255),
  idClientOS int,
  constraint fk_ordem_servico_cliente foreign key (idClientOS) references clientes (IdCliente)       
);

select * from ordem_de_servico;
insert into ordem_de_servico values
  ('111','2022-08-01', 'Aprovado','2022-08-15','500','Revisao de Freios','01'),
  ('112','2022-09-10', 'Concluido','2022-09-10','200','Troca de oleo','02'),
  ('113','2022-09-22', 'Em andamento','2022-09-30','800','Balancealemto e Alinhamento','03');
  
-- tabela equipe_de_mecanicos

create table equipe_mecanicos (
  Id_EquipeMecanicos int primary key auto_increment,
  Nome varchar (45),
  Endereco varchar (45),
  Especialidade enum('Reparos', 'Troca de Oleo','Balanceamento',' Embreagem', 'Revisao de Freios')
);

select * from equipe_mecanicos;
insert into equipe_mecanicos  values 
  ('21','Carlos Magno', 'R Jose de Alencar 444', 'Balanceamento'),
  ('22','Manuel Chaves', 'R Liberdade 256', 'Reparos'),
  ('23','Jair Monteiro','Rua Jardins 188', 'Troca de Oleo');

-- tabela Os possui equipe mecanicos
create table OSequipe_mecanicos(
  idOS_OS int primary key auto_increment,
  IdOSClient_idClient int,
  IdOSequipe_mecanico int ,
  constraint fk_osequipem_OS foreign key (idOS_OS) references ordem_de_servico(IdOS),
  constraint fk_os_idclientOS foreign key (IdOSClient_idClient) references ordem_de_servico(idClientOS),
  constraint fk_osequipe_mecanico foreign key (IdOSequipe_mecanico) references equipe_mecanicos(Id_EquipeMecanicos)
);
select * from OSequipe_mecanicos;
insert into OSequipe_mecanicos  values 
  ('111','1', '21'),
  ('112','2', '22'),
  ('113','3','23');

-- tabela tipo de servico         
                    
create table tipo_de_servico(
  idTipoServico int primary key auto_increment,
  conserto varchar(45),
  revisao varchar(45),
  valor int
);
select * from tipo_de_servico;
insert into tipo_de_servico  values 
  ('01', '', 'Motor', '3000'),
  ('02','', 'Ignicao', '300'),
  ('03','','Filtro', '170');

-- tabela equipe-mecanicos-avalia-tipo-de-servico
create table equipeM_avalia_tipoServico(
  idEquipe_mecanicos_avalia int primary key,
  idEquipeM_avaliaTipoServico int,
  constraint fk_equipe_avalia_ foreign key (idEquipe_mecanicos_avalia) references equipe_mecanicos(Id_EquipeMecanicos),
  constraint fk_equipe_avalia_servico foreign key (idEquipeM_avaliaTipoServico) references tipo_de_servico(idTipoServico)
);
select * from equipeM_avalia_tipoServico;
insert into equipeM_avalia_tipoServico  values 
  ('21', '01'),
  ('22', '02'),
  ('23','03');

create table Os_tipo_servico(
  idOS_OS int primary key,
  idTipoServico_TS int,
  constraint fk_os_tipo_servico_os foreign key (idOS_OS) references ordem_de_servico(IdOS),
  constraint fk_tipo_servico_ts foreign key (idTipoServico_TS) references tipo_de_servico(idTipoServico)
);
select * from Os_tipo_servico;
insert into Os_tipo_servico values 
  ('111', '1'),
  ('112', '2'),
  ('113','3');
  
-- tabela OS para  tipos de peca 

create table tipos_de_peca(
        IdOStipoPeca int primary key auto_increment,
        IdOSvalorPeca int,
        constraint fk_os_tipo_peca foreign key (IdOStipoPeca) references ordem_de_servico(IdOS),
        constraint fk_os_valor_peca foreign key (IdOSvalorPeca) references valor_pecas(IdValorPeca)
);
select * from tipos_de_peca;
insert into tipos_de_peca values 
  ('111', '1'),
  ('112', '2'),
  ('113','3');
-- tabela valor pecas
create table valor_pecas(
	IdValorPeca int primary key auto_increment,
	descricao_peca varchar (255),
	valor_peca float
);
select * from valor_pecas;
insert into valor_pecas  values
  ('Oleo Motor','200'),
  ('Vela de ignicao','500'),
  ('Filtro de Oleo','600');


-- Valor a ser pago pelo cliente e a descricao do servico
select clientes.NomeCliente, ordem_de_servico.descricao, ordem_de_servico.valor, ordem_de_servico.status from clientes
INNER JOIN ordem_de_servico;

-- Modelo do carro do cliente descricao da peca e o valor 
select clientes.NomeCliente, veiculo.modeloVeiculo, valor_pecas.descricao_peca, valor_pecas.valor_peca from  veiculo
INNER JOIN clientes
INNER JOIN  valor_pecas;

-- Servico a ser realizado pelo mecanico  e a data de entrega
select tipo_de_servico.revisao, equipe_mecanicos.Nome, equipe_mecanicos.Especialidade, ordem_de_servico.dataEntregaOs from tipo_de_servico
INNER JOIN  equipe_mecanicos
INNER JOIN ordem_de_servico;

-- ordenando a lista de clientes
select * from clientes order by NomeCliente;

-- OS gerada
select  clientes.NomeCliente, clientes.CPF, ordem_de_servico.dataEntregaOs, ordem_de_servico.descricao, ordem_de_servico.valor from  ordem_de_servico
INNER JOIN  clientes
on clientes.IdCliente =  ordem_de_servico.idClientOS
