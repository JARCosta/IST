/* a) Qual o nome do fornecedor que forneceu o maior número de categorias? */
select nome from (
    select nome, count(distinct categoria) from (
        (
            select nome, categoria from fornecedor inner join produto on fornecedor.nif = produto.forn_primario
        )
        union (
            select nome, categoria from fornece_sec natural join fornecedor natural join produto
        )
    )
    as forn_cat group by nome
)
as forn_count
where count >= all (
    select count(distinct categoria) from (
        (
            select nome, categoria from fornecedor inner join produto on fornecedor.nif = produto.forn_primario
        )
        union (
            select nome, categoria from fornece_sec natural join fornecedor natural join produto
        )
    )
    as forn_cat group by nome
);

/* b) Quais os fornecedores primários (nome e nif) que forneceram produtos de todas as categorias simples? */
select distinct nome, nif from (
    select nome, nif, count(distinct categoria) from (
        (
            select fornecedor.nome, nif, categoria from fornecedor inner join produto on fornecedor.nif = produto.forn_primario inner join categoria_simples on produto.categoria = categoria_simples.nome
        )
        union (
            select fornecedor.nome, nif, categoria from fornece_sec natural join fornecedor natural join produto inner join categoria_simples on produto.categoria = categoria_simples.nome
        )
    )
    as forn_cat group by nome, nif
) as forn_count
where count = (select count(*) from categoria_simples);

/* c) Quais foram os produtos que nunca foram repostos? */
select ean from produto where ean not in (select ean from reposicao);

/* d) Quais os produtos (ean) com um número de fornecedores secundários superior a 10? */
select ean from fornece_sec group by ean having count(distinct nif) > 10;

/* e) Quais os produtos (ean) que foram repostos sempre pelo mesmo operador? */
select ean from reposicao group by ean having count(distinct operador) = 1;