--criando a primeira função
CREATE FUNCTION primeira_funcao() RETURNS INTEGER AS '
    SELECT (5 - 3) * 2
' LANGUAGE SQL;

SELECT primeira_funcao() AS numero;

--delentando uma função
DROP FUNCTION soma_dois_numeros;

--definindo um corpo para função
CREATE FUNCTION soma_dois_numeros(numero_1 INTEGER, numero_2 INTEGER) RETURNS INTEGER AS ' 
    SELECT numero_1 + numero_2;
' LANGUAGE SQL;

SELECT soma_dois_numeros(2, 2);

--podemos não definir o nome. Se não dermos um nome para os parâmetros, 
--informando apenas que precisamos receber um inteiro (INTEGER) na primeira posição e um 
--inteiro (INTEGER) na segunda posição, então usamos as posições desses números para 
--referenciá-los. Nesse caso, seriam $1 e $2.
CREATE FUNCTION soma_dois_numeros(INTEGER, INTEGER) RETURNS INTEGER AS ' 
    SELECT $1 + $2;
' LANGUAGE SQL;

--criando uma tabela 
CREATE TABLE a (nome VARCHAR(255) NOT NULL);

DROP FUNCTION cria_a
--criando uma função adicionando um INSERT INTO a (nome)
CREATE FUNCTION cria_a(nome VARCHAR) RETURNS VARCHAR AS '
    INSERT INTO a (nome) VALUES(cria_a.nome);
    
    SELECT nome;
' LANGUAGE SQL;

SELECT cria_a('ABC DFG');

--A função sempre retornará o primeiro item do último comando executado. O que, no nosso caso, seria puramente o parâmetro que recebemos para nome.
CREATE FUNCTION cria_a(nome VARCHAR) RETURNS VARCHAR AS '
    INSERT INTO a (nome) VALUES(cria_a.nome);
    
    SELECT a.nome FROM a;
' LANGUAGE SQL;

--ao invés de eliminar uma função e criar uma nova, fazendo DROP seguido de CREATE, podemos optar pelo comando CREATE OR REPLACE. Ou seja, caso a função já exista, ela será substituída
CREATE OR REPLACE FUNCTION cria_a(nome VARCHAR) RETURNS VARCHAR AS '
    INSERT INTO a (nome) VALUES(cria_a.nome);
    
    SELECT nome;
' LANGUAGE SQL;

--criando uma tabela 
CREATE TABLE instrutor (
    id SERIAL PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        salario DECIMAL(10, 2)
);

--inserindo dados
INSERT INTO instrutor (nome, salario) VALUES ('Vinicius Dias', 100)

-- função que retorna o dobro do salário do instrutor que passarmos por parâmetro
CREATE FUNCTION dobro_do_salario(instrutor) RETURNS DECIMAL AS $$ 
    SELECT $1.salario * 2 AS dobro;
$$ LANGUAGE SQL;

SELECT nome, dobro_do_salario(instrutor.*) FROM instrutor;

--criando uma função , nao da parametro mas retorna a table instrutor
CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$ 
      SELECT 22, 'Nome falso', 200::DECIMAL; 
$$ LANGUAGE SQL;

SELECT * FROM cria_instrutor_falso(); 

--inserindo mais dados na tabela instrutor
INSERT INTO instrutor (nome, salario) VALUES ('Diogo Mascarenhas', 200);
INSERT INTO instrutor (nome, salario) VALUES ('Nico Steppat', 300);
INSERT INTO instrutor (nome, salario) VALUES ('Juliana', 400);
INSERT INTO instrutor (nome, salario) VALUES ('Priscila', 500);


--criando uma função que retorna os salrios acima de 300 na tabela 
CREATE OR REPLACE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF instrutor AS $$ 
    SELECT * FROM instrutor WHERE salario >= valor_salario; 

$$ LANGUAGE SQL;

SELECT * FROM instrutores_bem_pagos(300);

DROP FUNCTION instrutores_bem_pagos;

--CRIANDO UMA FUNÇÃO COM OUT ( parametro de saida )
CREATE OR REPLACE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL, OUT nome VARCHAR, OUT salario DECIMAL) RETURNS SETOF record AS $$ 
    SELECT nome, salario FROM instrutor WHERE salario >= valor_salario; 

$$ LANGUAGE SQL;

DROP FUNCTION primeira_pl;
--criando uma função com PLpgSQL
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    BEGIN
        RETURN 1;
    END
    
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

--DECLARANDO UMA VARIAVEL ( DECLARE )
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER = 3;
    BEGIN
        -- Vários comandos em SQL
		primeira_variavel = primeira_variavel * 2;
		
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();

--criando um sub bloco
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$
    DECLARE
        primeira_variavel INTEGER DEFAULT 3;
    BEGIN
        primeira_variavel := primeira_variavel * 2;
        
        BEGIN
            primeira_variavel := 7;
        END;
        
        RETURN primeira_variavel;
    END
$$ LANGUAGE plpgsql;

--retornos em Pls declarando uma variavel e retornando a tabela instrutor
CREATE OR REPLACE FUNCTION cria_instrutor_falso() RETURNS instrutor AS $$
  DECLARE
      retorno instrutor;
  BEGIN
     SELECT 22, 'Nome falso', 200:: DECIMAL INTO retorno;

     RETURN retorno;
  END;
$$ LANGUAGE plpgsql;

--usando o RETURN QUERY SELECT * FROM retornando igual a estrutura
CREATE FUNCTION instrutores_bem_pagos(valor_salario DECIMAL) RETURNS SETOF record AS $$
  BEGIN  
 RETURN QUERY SELECT * FROM instrutor WHERE salario > valor_salario;
  END;
$$ LANGUAGE plpgsql;

--usando if e else, condiçoes
CREATE FUNCTION salario_ok (instrutor instrutor) RETURNS VARCHAR AS $$
  BEGIN
    --se o salário do instrutor for maior do que 200, está ok. Senão, pode aumentar
    IF instrutor.salario > 200 THEN
       RETURN 'Salário está ok';
    ELSE
       RETURN 'Salário pode aumentar';
    END IF;
  END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor) FROM instrutor;

DROP FUNCTION salario_ok;
--outro jeito de usar é declarando uma variavel e usando o sekect
CREATE FUNCTION salario_ok (id_instrutor INTEGER) RETURNS VARCHAR AS $$
  DECLARE
     instrutor instrutor;
  BEGIN
      SELECT * FROM instrutor WHERE id = id_instrutor INTO instrutor;

    --se o salário do instrutor for maior do que 200, está ok. Senão, pode aumentar
    IF instrutor.salario > 200 THEN
       RETURN 'Salário está ok';
    ELSE
       RETURN 'Salário pode aumentar';
    END IF;
  END;
$$ LANGUAGE plpgsql;

--usando o Elself
CREATE OR REPLACE FUNCTION salario_ok(id_instrutor INTEGER) RETURNS VARCHAR AS $$
  DECLARE
     instrutor instrutor;
  BEGIN
      SELECT * FROM instrutor WHERE id = id_instrutor INTO instrutor;

    --se o salário do instrutor for maior do que 200, está ok. Senão, pode aumentar
    IF instrutor.salario > 300 THEN
       RETURN 'Salário está ok';
	ELSEIF instrutor.salario = 300 THEN
		RETURN 'Salário pode aumentar';
    ELSE
       RETURN 'Salário pode defasado';
    END IF;
  END;
$$ LANGUAGE plpgsql;

SELECT nome, salario_ok(instrutor.id) FROM instrutor;

--usando CASE WHEN sintaxe alternativa de if else
CREATE OR REPLACE FUNCTION salario_ok(id_instrutor INTEGER) RETURNS VARCHAR AS $$
  DECLARE
     instrutor instrutor;
  BEGIN
      SELECT * FROM instrutor WHERE id = id_instrutor INTO instrutor;
CASE instrutor.salario
    WHEN 100 THEN
       RETURN 'Salário muito baixo';
    WHEN 200 THEN
       RETURN 'Salário baixo';
    WHEN 300 THEN
       RETURN 'Salário ok';
    ELSE
       RETURN 'Salário ótimo';
  END CASE;
END;
$$ LANGUAGE plpgsql;

/*return next , retonar valores Essa instrução é utilizada quando precisamos retornar
múltiplas linhas de uma função PLpgSQL mas não temos uma query para isso 
(senão poderíamos utilizar o RETURN QUERY).*/
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF INTEGER AS $$
    DECLARE
    BEGIN
            RETURN NEXT numero * 1;
            RETURN NEXT numero * 2;
            RETURN NEXT numero * 3;
            RETURN NEXT numero * 4;
            RETURN NEXT numero * 5;
            RETURN NEXT numero * 6;
            RETURN NEXT numero * 7;
            RETURN NEXT numero * 8;
            RETURN NEXT numero * 9;
    END;
$$ LANGUAGE plpgsql;

DROP FUNCTION tabuada;
--Conhecendo Loop da tabuada, acrescentando o concat, concatenar o return
DROP FUNCTION tabuada;
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
    DECLARE
      multiplicador INTEGER DEFAULT 1;
    BEGIN
      LOOP
        RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
        multiplicador := multiplicador +1;
        EXIT WHEN multiplicador = 10;
      END LOOP;
    END;
$$ LANGUAGE plpgsql;

SELECT tabuada(9);

--while
DROP FUNCTION tabuada;
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
    DECLARE
      multiplicador INTEGER DEFAULT 1;
    BEGIN
      WHILE multiplicador < 10 LOOP
        RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
        multiplicador := multiplicador +1;
      END LOOP;
    END;
$$ LANGUAGE plpgsql;

SELECT tabuada(9);

-- FOR outra maneira de looping
DROP FUNCTION tabuada;
CREATE OR REPLACE FUNCTION tabuada(numero INTEGER) RETURNS SETOF VARCHAR AS $$
    BEGIN
      FOR multiplicador IN 1..10 LOOP
        RETURN NEXT numero || ' x ' || multiplicador || ' = ' || numero * multiplicador;
      END LOOP;
    END;
$$ LANGUAGE plpgsql;

SELECT tabuada(6);

--usando FOR em uma função de outra função 
DROP FUNCTION instrutor_com_salario;
CREATE FUNCTION instrutor_com_salario(OUT nome VARCHAR, OUT salario_ok VARCHAR) RETURNS SETOF record AS $$
    DECLARE
        instrutor instrutor;
    BEGIN
        FOR instrutor IN SELECT * FROM instrutor LOOP
            nome := instrutor.nome;
            salario_ok = salario_ok(instrutor.id);
            
            RETURN NEXT;
        END LOOP;
    END;
$$ LANGUAGE plpgsql

SELECT * FROM instrutor_com_salario();

/**
 * Inserir instrutores (com salários).
 * Se o salário for maior do que a média, salvar um log.
 * Salvar outro log dizendo que fulano recebe mais do que X% da grade de instrutores
 */
CREATE OR REPLACE FUNCTION cria_instrutor (nome_instrutor VARCHAR, salario_instrutor DECIMAL) RETURNS void AS $$
    DECLARE 
        id_instrutor_inserido INTEGER;
        media_salarial DECIMAL;
        instrutores_recebem_menos INTEGER DEFAULT 0;
        total_instrutores INTEGER DEFAULT 0;
        salario DECIMAL;
        percentual DECIMAL;
    BEGIN
        INSERT INTO instrutor (nome, salario) VALUES (nome_instrutor, salario_instrutor) RETURNING id INTO id_instrutor_inserido;

        SELECT AVG(instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> id_instrutor_inserido;

        IF salario_instrutor > media_salarial THEN 
            INSERT INTO log_instrutores (informacao) VALUES (nome_instrutor || ' recebe acima da média');
        END IF;

        FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> id_instrutor_inserido LOOP
            total_instrutores := total_instrutores + 1;

            IF salario_instrutor > salario THEN
                instrutores_recebem_menos := instrutores_recebem_menos + 1;
            END IF;
        END LOOP;

        percentual = instrutores_recebem_menos::DECIMAL / total_instrutores::DECIMAL * 100;
        
        INSERT INTO log_instrutores (informacao) 
            VALUES (nome_instrutor || ' recebe mais do que ' || percentual || '% da grade de instrutores');
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM instrutor;
SELECT * FROM log_instrutores;
SELECT cria_instrutor('Fulana de tal', 1000);





