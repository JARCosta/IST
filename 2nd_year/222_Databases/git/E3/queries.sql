
-- Qual o nome do retalhista (ou retalhistas)  responsáveis pela reposição do maior número de categorias? 
SELECT retalhista.nome FROM responsavel_por
NATURAL JOIN retalhista
GROUP BY retalhista.nome
HAVING COUNT(retalhista.nome) >= ALL (
    SELECT COUNT(retalhista.nome) FROM responsavel_por
    NATURAL JOIN retalhista
    GROUP BY retalhista.nome
)

--Qual o nome do ou dos retalhistas que são responsáveis por todas as categorias simples?
SELECT retalhista.nome FROM responsavel_por
NATURAL JOIN retalhista
JOIN categoria_simples ON responsavel_por.nome_cat = categoria_simples.nome

--Quais os produtos (ean) que nunca foram repostos?
SELECT produto.ean FROM produto
GROUP BY produto.ean
HAVING ean NOT IN (
    SELECT produto.ean FROM evento_reposicao
    NATURAL JOIN produto
)

--Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista?
SELECT ean FROM produto
GROUP BY ean
HAVING ean NOT IN (
SELECT ean FROM evento_reposicao
GROUP BY ean
)