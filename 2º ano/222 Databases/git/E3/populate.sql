drop table evento_reposicao cascade;
drop table responsavel_por cascade;
drop table retalhista cascade;
drop table planograma cascade;
drop table prateleira cascade;
drop table instalada_em cascade;
drop table ponto_de_retalho cascade;
drop table IVM cascade;
drop table tem_categoria cascade;
drop table produto cascade;
drop table tem_outra cascade;
drop table super_categoria cascade;
drop table categoria_simples cascade;
drop table categoria cascade;


CREATE TABLE categoria(
	nome VARCHAR(80) NOT NULL,
    constraint pk_categoria PRIMARY KEY(nome)
);

CREATE TABLE categoria_simples(
	nome VARCHAR(80) NOT NULL,
    constraint pk_categoria_simples PRIMARY KEY(nome),
	constraint fk_categoria_simples FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE super_categoria(
	nome VARCHAR(80) NOT NULL,
    constraint pk_super_categoria PRIMARY KEY(nome),
	constraint fk_super_categoria FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE tem_outra(
	super_categoria VARCHAR(80) NOT NULL,
	categoria VARCHAR(80) NOT NULL,
    constraint pk_tem_outra PRIMARY KEY(categoria),
	constraint fk_tem_outra_categoria FOREIGN KEY(categoria) REFERENCES categoria(nome),
	constraint fk_tem_outra_super_categoria FOREIGN KEY(super_categoria) REFERENCES super_categoria(nome)--,
);

CREATE TABLE produto(
    ean VARCHAR(80) NOT NULL,
	cat VARCHAR(80) NOT NULL,
    descr VARCHAR(100) NOT NULL,
	constraint pk_produto PRIMARY KEY(ean),
    constraint fk_produto FOREIGN KEY(cat) REFERENCES categoria(nome)
);

CREATE TABLE tem_categoria(
	ean VARCHAR(80) NOT NULL,
	nome VARCHAR(80) NOT NULL,
	constraint pk_tem_categoria PRIMARY KEY (ean, nome),
	constraint fk_tem_categoria_produto FOREIGN KEY(ean) REFERENCES produto(ean),
	constraint fk_tem_categoria_categoria FOREIGN KEY(nome) REFERENCES categoria_simples(nome)
);

CREATE TABLE ivm(
	num_serie INTEGER,
	fabricante VARCHAR(80) NOT NULL,
	constraint pk_ivm PRIMARY KEY(num_serie, fabricante)
);

CREATE TABLE ponto_de_retalho(
    nome VARCHAR(80) NOT NULL,
	distrito VARCHAR(20) NOT NULL,
    concelho VARCHAR(50) NOT NULL,
	constraint pk_ponto_de_retalho PRIMARY KEY(nome)
);

CREATE TABLE instalada_em(
	num_serie INTEGER,
	fabricante VARCHAR(80) NOT NULL,
    loc VARCHAR(80) NOT NULL,
    constraint pk_instalada_em PRIMARY KEY(num_serie, fabricante),
	constraint fk_instalada_em_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
	constraint fk_instalada_em_ponto_de_retalho FOREIGN KEY(loc) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE prateleira(
    nro INTEGER,
    num_serie INTEGER,
	fabricante VARCHAR(80) NOT NULL,
    altura INTEGER,
    nome VARCHAR(80) NOT NULL,
	constraint pk_prateleira PRIMARY KEY(nro),
    constraint fk_prateleira_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
    constraint fk_prateleira_categoria FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE planograma(
	ean VARCHAR(80) NOT NULL,
    nro INTEGER,
    num_serie INTEGER,
	fabricante VARCHAR(80) NOT NULL,
	faces INTEGER,
    unidades INTEGER,
    loc VARCHAR(80) NOT NULL,
    constraint pk_planograma PRIMARY KEY(ean, nro, num_serie, fabricante),
	constraint fk_planograma_produto FOREIGN KEY(ean) REFERENCES produto(ean),
	constraint fk_planograma_ponto_de_retalho FOREIGN KEY(loc) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE retalhista(
	tin INTEGER NOT NULL,
	nome VARCHAR(80) NOT NULL,
	constraint pk_retalhista_tin PRIMARY KEY(tin),
	UNIQUE(nome)
);

CREATE TABLE responsavel_por(
	nome_cat VARCHAR(80) NOT NULL,
	tin INTEGER NOT NULL, 
	num_serie INTEGER,
	fabricante VARCHAR(80) NOT NULL,
	constraint  pk_responsavel_por PRIMARY KEY(num_serie, fabricante),
	constraint  fk_responsavel_por_retalhista FOREIGN KEY(tin) REFERENCES retalhista(tin),
	constraint  fk_responsavel_por_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES ivm(num_serie, fabricante),
	constraint  fk_responsavel_por_categoria FOREIGN KEY(nome_cat) REFERENCES categoria(nome)
);

CREATE TABLE evento_reposicao(
	ean VARCHAR(80) NOT NULL,
	nro INTEGER,
    num_serie INTEGER,
	fabricante VARCHAR(80) NOT NULL,
	instante TIMESTAMP NOT NULL,
	unidades INTEGER,
    tin INTEGER,
	constraint pk_evento_reposicao PRIMARY KEY(ean, nro, num_serie, fabricante, instante),
	constraint fk_evento_reposicao_planograma FOREIGN KEY(ean, nro, num_serie, fabricante) REFERENCES planograma(ean, nro, num_serie, fabricante),
	constraint fk_evento_reposicao_retalhista FOREIGN KEY(tin) REFERENCES retalhista(tin)--,
);

--categoria('nome')
INSERT INTO categoria VALUES ('Bebidas');
INSERT INTO categoria VALUES ('Refrigerantes');
INSERT INTO categoria VALUES ('Sandes');
INSERT INTO categoria VALUES ('Sem gas');
INSERT INTO categoria VALUES ('Doces');
INSERT INTO categoria VALUES ('Chocolates');
INSERT INTO categoria VALUES ('Comida');

--categoria_simples('nome')
INSERT INTO categoria_simples VALUES ('Sandes');
INSERT INTO categoria_simples VALUES ('Refrigerantes');
INSERT INTO categoria_simples VALUES ('Sem gas');
INSERT INTO categoria_simples VALUES ('Chocolates');

--super_categoria('nome')
INSERT INTO super_categoria VALUES ('Bebidas');
INSERT INTO super_categoria VALUES ('Doces');
INSERT INTO super_categoria VALUES ('Comida');

--tem_outra(super_categoria, categoria)
INSERT INTO tem_outra VALUES ('Bebidas', 'Refrigerantes');
INSERT INTO tem_outra VALUES ('Bebidas', 'Sem gas');
INSERT INTO tem_outra VALUES ('Doces', 'Chocolates');
INSERT INTO tem_outra VALUES ('Comida', 'Bebidas');
INSERT INTO tem_outra VALUES ('Comida', 'Doces');

--produto(ean, cat, descr)
INSERT INTO produto VALUES ('11', 'Sem gas', 'Agua');
INSERT INTO produto VALUES ('12', 'Refrigerantes', 'Coca-Cola');
INSERT INTO produto VALUES ('13', 'Chocolates', 'Kitkat');
INSERT INTO produto VALUES ('14', 'Sandes', 'Sandes de Atum');

--tem_categoria(ean, nome)
INSERT INTO tem_categoria VALUES ('11', 'Sem gas');
INSERT INTO tem_categoria VALUES ('12', 'Refrigerantes');
INSERT INTO tem_categoria VALUES ('13', 'Chocolates');
INSERT INTO tem_categoria VALUES ('14', 'Sandes');

--IVM(num_serie, fabricante)
INSERT INTO IVM VALUES (1000, 'Samsung');
INSERT INTO IVM VALUES (1001, 'Samsung');

--ponto_de_retalho(nome, distrito, concelho)
INSERT INTO ponto_de_retalho VALUES ('McDonalds', 'Lisboa', 'Oeiras');

--instalada_em(num_serie, fabricante, local)
INSERT INTO instalada_em VALUES (1000,'Samsung', 'McDonalds');

--prateleira(nro, num_serie, fabricante, altura, nome)
INSERT INTO prateleira VALUES (1, 1000, 'Samsung', 2, 'Bebidas');

--planograma(ean, nro, num_serie, fabricante, faces, unidades, loc)
INSERT INTO planograma VALUES ('11', 500, 1000, 'Samsung', 4, 20, 'McDonalds');
INSERT INTO planograma VALUES ('12', 501, 1000, 'Samsung', 2, 10, 'McDonalds');
INSERT INTO planograma VALUES ('13', 502, 1000, 'Samsung', 2, 10, 'McDonalds');
INSERT INTO planograma VALUES ('14', 503, 1000, 'Samsung', 1, 5, 'McDonalds');
INSERT INTO planograma VALUES ('11', 500, 1001, 'Samsung', 4, 20, 'McDonalds');
INSERT INTO planograma VALUES ('12', 501, 1001, 'Samsung', 2, 10, 'McDonalds');
INSERT INTO planograma VALUES ('13', 502, 1001, 'Samsung', 2, 10, 'McDonalds');
INSERT INTO planograma VALUES ('14', 503, 1001, 'Samsung', 1, 5, 'McDonalds');

--retalhista(tin, name)
INSERT INTO retalhista VALUES (271296, 'Asdrubal');
INSERT INTO retalhista VALUES (271798, 'Joaquim');

--responsavel_por(nome_cat, tin, num_serie, fabricante)
INSERT INTO responsavel_por VALUES ('Bebidas', 271296, 1000, 'Samsung');
INSERT INTO responsavel_por VALUES ('Comida', 271798, 1001, 'Samsung');

--evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin)
INSERT INTO evento_reposicao VALUES ('11', 500, 1000, 'Samsung', '2006-12-30 00:38:54', 6, 271296);
INSERT INTO evento_reposicao VALUES ('12', 501, 1000, 'Samsung', '2006-12-30 00:38:55', 2, 271296);

INSERT INTO evento_reposicao VALUES ('11', 500, 1001, 'Samsung', '2006-12-30 00:38:54', 6, 271798);
INSERT INTO evento_reposicao VALUES ('12', 501, 1001, 'Samsung', '2006-12-30 00:38:55', 2, 271798);
INSERT INTO evento_reposicao VALUES ('13', 502, 1001, 'Samsung', '2006-12-30 00:38:55', 2, 271798);
INSERT INTO evento_reposicao VALUES ('14', 503, 1001, 'Samsung', '2006-12-30 00:38:56', 1, 271798);
