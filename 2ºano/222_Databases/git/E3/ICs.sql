--(RI-1) Uma Categoria não pode estar contida em si própria

CREATE OR REPLACE FUNCTION check_category_is_valid()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.super_categoria == NEW.categoria THEN
        RAISE EXCEPTION 'Uma Categoria não pode estar contida em si própria'
    END IF;
    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

--(RI-4) O número de unidades repostas num Evento de Reposição
-- não pode exceder o número de unidades especificado no Planograma

CREATE OR REPLACE FUNCTION check_product_replacement()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.evento_reposicao.unidades > NEW.planograma.unidades THEN
        RAISE EXCEPTION 'O número de unidades repostas não pode exceder o valor espeficicado no planograma'
    END IF;
    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

-- (RI-5) Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das 
-- Categorias desse produto 

CREATE OR REPLACE FUNCTION check_shelf_category()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.prateleira.categoria != NEW.produto.categoria THEN
        RAISE EXCEPTION 'Um Produto só pode ser reposto numa Prateleira que apresente (pelo menos) uma das categorias desse produto '
    END IF;
    RETURN NEW;
END;

$$ LANGUAGE plpgsql;