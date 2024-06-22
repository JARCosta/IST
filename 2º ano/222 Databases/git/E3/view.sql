DROP VIEW IF EXISTS vendas;
CREATE VIEW vendas (ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades) AS
SELECT tem_categoria.ean, tem_categoria.nome, EXTRACT(YEAR FROM instante) AS ano, EXTRACT(QUARTER FROM instante) AS trimestre, EXTRACT(MONTH FROM instante) AS mes, EXTRACT(DAY FROM instante) AS dia_mes, EXTRACT(DOW FROM instante) AS dia_semana, distrito, concelho, unidades
FROM evento_reposicao 
JOIN tem_categoria ON evento_reposicao.ean = tem_categoria.ean
NATURAL JOIN instalada_em
JOIN ponto_de_retalho ON instalada_em.loc = ponto_de_retalho.nome
