1.

SELECT dia_semana, concelho, SUM(unidades)
FROM vendas
WHERE ano BETWEEN EXTRACT(YEAR FROM data_inicial) AND EXTRACT(YEAR FROM data_final)
WHERE mes BETWEEN EXTRACT(MONTH FROM data_inicial) AND EXTRACT(MONTH FROM data_final)
WHERE dia_mes BETWEEN EXTRACT(DOM FROM data_inicial) AND EXTRACT(DOM FROM data_final)
GROUP BY CUBE (dia_semana, concelho);

2.

SELECT concelho, categoria, dia_semana, SUM(unidades)
FROM vendas
WHERE distrito = "Lisboa"
GROUP BY CUBE (concelho, categoria, dia_semana);