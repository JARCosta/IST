insert into categoria values ('Lacticinios');
insert into categoria values ('Peixe');
insert into categoria values ('Carne');
insert into categoria values ('Queijo');
insert into categoria values ('Iogurte');

insert into categoria_simples values ('Peixe');
insert into categoria_simples values ('Carne');
insert into categoria_simples values ('Queijo');
insert into categoria_simples values ('Iogurte');

insert into super_categoria values ('Lacticinios');

insert into constituida values ('Lacticinios', 'Queijo');
insert into constituida values ('Lacticinios', 'Iogurte');

insert into fornecedor values ('12345', 'Asdrubal');
insert into fornecedor values ('12346', 'Butcher Inc.');
insert into fornecedor values ('12347', 'Pescadores da Caparica');
insert into fornecedor values ('12348', 'Manel das Couves');
insert into fornecedor values ('12349', 'Joaquim');

insert into produto values ('1111222233300', 'Sardinha', 'Peixe', '12345', '2001-03-12');
insert into produto values ('1111222233301', 'Picanha', 'Carne', '12346', '2001-03-13');
insert into produto values ('1111222233302', 'Costoletas de Borrego', 'Carne', '12346', '2001-03-14');
insert into produto values ('1111222233303', 'Iogurte Danone', 'Iogurte', '12349', '2001-05-10');
insert into produto values ('1111222233304', 'Queijo da Serra', 'Queijo', '12345', '2001-05-09');
insert into produto values ('1111222233305', 'Leite Vigor', 'Lacticinios', '12348', '2001-10-02');
insert into produto values ('1111222233306', 'Bacalhau', 'Peixe', '12347', '2001-02-01');
insert into produto values ('1111222233307', 'Iogurte Nestle', 'Iogurte', '12349', '2001-10-10');
insert into produto values ('1111222233308', 'Queijo da Ilha', 'Queijo', '12346', '2001-10-10');
insert into produto values ('1111222233309', 'Leite Matinal', 'Lacticinios', '12345', '2001-12-01');

insert into fornece_sec values ('12347', '1111222233300');
insert into fornece_sec values ('12349', '1111222233308');

insert into corredor values (1, 'Um');
insert into corredor values (2, 'Dois');
insert into corredor values (3, 'Tres');

insert into prateleira values (1, 'esquerda', 'chao');
insert into prateleira values (2, 'esquerda', 'chao');
insert into prateleira values (2, 'direita', 'superior');
insert into prateleira values (3, 'direita', 'chao');
insert into prateleira values (3, 'esquerda', 'medio');
insert into prateleira values (3, 'esquerda', 'superior');

insert into planograma values ('1111222233302', 1, 'esquerda', 'chao', 10, 100, 1);
insert into planograma values ('1111222233309', 2, 'esquerda', 'chao', 5, 50, 1);
insert into planograma values ('1111222233302', 2, 'direita', 'superior', 30, 50, 3);
insert into planograma values ('1111222233309', 3, 'direita', 'chao', 4, 37, 2);
insert into planograma values ('1111222233308', 3, 'esquerda', 'medio', 10, 96, 4);
insert into planograma values ('1111222233307', 3, 'esquerda', 'superior', 10, 100, 4);

insert into evento_reposicao values ('2222220', '2010-01-06 23:00:00');
insert into evento_reposicao values ('2222225', '2010-04-24 10:30:00');
insert into evento_reposicao values ('2222220', '2010-05-10 12:50:31');
insert into evento_reposicao values ('2222220', '2010-12-20 20:15:00');

insert into reposicao values ('1111222233302', 1, 'esquerda', 'chao', '2222220', '2010-01-06 23:00:00', 50);
insert into reposicao values ('1111222233309', 2, 'esquerda', 'chao', '2222225', '2010-04-24 10:30:00', 20);
insert into reposicao values ('1111222233302', 2, 'direita', 'superior', '2222220', '2010-05-10 12:50:31', 40);
insert into reposicao values ('1111222233307', 3, 'esquerda', 'superior', '2222220', '2010-12-20 20:15:00', 1);