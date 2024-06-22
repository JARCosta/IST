drop table reposicao;
drop table planograma;
drop table fornece_sec;
drop table produto;
drop table fornecedor;
drop table constituida;
drop table categoria_simples;
drop table super_categoria;
drop table categoria;
drop table prateleira;
drop table corredor;
drop table evento_reposicao;


drop type lado;
drop type altura;

create type lado as enum ('esquerda', 'direita');
create type altura as enum ('chao', 'medio', 'superior');

create table categoria (
  nome varchar(100) not null,
  primary key (nome)
);

create table categoria_simples (
  nome varchar(100) not null,
  primary key (nome),
  foreign key (nome) references categoria(nome) on delete cascade
);

create table super_categoria (
  nome varchar(100) not null,
  primary key (nome),
  foreign key (nome) references categoria on delete cascade
);

create table constituida (
  super_categoria varchar(100) not null,
  categoria varchar(100) not null,
  primary key (super_categoria, categoria),
  foreign key (super_categoria) references super_categoria(nome) on delete cascade,
  foreign key (categoria) references categoria(nome) on delete cascade,
  check (super_categoria != categoria)
);

create table fornecedor (
  nif varchar(20) not null,
  nome varchar(100),
  primary key (nif)
);

create table produto (
  ean char(13) not null,
  design varchar(100),
  categoria varchar(100) not null,
  forn_primario varchar(20) not null,
  data date,
  primary key (ean),
  foreign key (categoria) references categoria(nome) on delete cascade,
  foreign key (forn_primario) references fornecedor(nif) on delete cascade
);

create table fornece_sec (
  nif varchar(20) not null,
  ean char(13) not null,
  primary key (nif, ean),
  foreign key (nif) references fornecedor(nif) on delete cascade,
  foreign key (ean) references produto(ean) on delete cascade
);

create table corredor (
  nro int not null,
  nome varchar(100),
  primary key (nro)
);

create table prateleira (
  nro int not null,
  lado lado not null,
  altura altura not null,
  primary key (nro, lado, altura),
  foreign key (nro) references corredor(nro) on delete cascade
);

create table planograma (
  ean char(13) not null,
  nro int not null,
  lado lado not null,
  altura altura not null,
  face int,
  unidades int,
  loc int,
  primary key (ean, nro, lado, altura),
  foreign key (ean) references produto(ean) on delete cascade,
  foreign key (nro, lado, altura) references prateleira(nro, lado, altura) on delete cascade
);

create table evento_reposicao(
  operador varchar(20) not null,
  instante timestamp,
  primary key (operador, instante),
  check (instante < current_timestamp)
);

create table reposicao (
  ean char(13) not null,
  nro int not null,
  lado lado not null,
  altura altura not null,
  operador varchar(20) not null,
  instante timestamp,
  unidades int,
  primary key (ean, nro, lado, altura, operador, instante),
  foreign key (ean, nro, lado, altura) references planograma(ean, nro, lado, altura) on delete cascade,
  foreign key (operador, instante) references evento_reposicao(operador, instante) on delete cascade
);
