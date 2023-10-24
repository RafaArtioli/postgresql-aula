-- Database: alura

-- DROP DATABASE IF EXISTS alura;

CREATE DATABASE alura
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
CREATE [ [ GLOBAL | LOCAL ] { TEMPORARY | TEMP } | UNLOGGED ] TABLE [IF NOT EXISTS ] table_name ( [
    { column_name data_type [ COLLATE collation ] [column_constraint [ … ]  ]
               | table_constraint
               | LIKE source_table [ like_option …] }
               [, …]
] );
-- Note que a parte dos tipos de tabela (GLOBAL | LOCAL, TEMPORARY | TEMP, UNLOGGED) está entre colchetes e separada por pipes (|), o que significa que apenas um dos elementos pode ser escolhido.
-- A parte dos parâmetros da tabela vem em seguida, com a opção IF NOT EXISTS sendo opcional e a definição das colunas e restrições sendo colocadas dentro dos parênteses.


ALTER TABLE [ IF EXISTS ] [ ONLY ] name [ * ]
        action [, …]
ALTER TABLE [ IF EXISTS ] [ ONLY ] name [ * ]
        RENAME [ COLUMN ] column_name TO new_column_name
ALTER TABLE [ IF EXISTS ] [ ONLY ] name [ * ]
        RENAME CONSTRAINT [ COLUMN ] constraint_name TO new_constrain_name
ALTER TABLE [ IF EXISTS ] name 
        RENAME TO new_name
ALTER TABLE [ IF EXISTS ] name 
        RENAME SCHEMA new_schema
ALTER TABLE ALL IN TABLESPACE name [ OWNED BY role_name [, …] ]
        SET TABLESPACE new_tablespace [ NOWAIT ]

…

where action is one of:

ADD [ COLUMN ] [ IF NOT EXISTS ] column_name data_type [COLLATE collation] [column_constraint [ … ] ]
DROP [ COLUMN ] [ IF EXISTS ] column_name [RESTRICT | CASCADE]
…
-- Nós podemos modificar uma tabela especificando o nome dela e a ação que queremos realizar. Existem diversas ações que podemos executar, tais como renomear uma coluna, uma constraint ou até mesmo a tabela inteira.


where action is one of:

ADD [ COLUMN ] [ IF NOT EXISTS ] column_name data_type [COLLATE collation] [column_constraint [ … ] ]
DROP [ COLUMN ] [ IF EXISTS ] column_name [RESTRICT | CASCADE]
ALTER [ COLUMN ] column_name [ SET DATA ] TYPE data_type [ COLLATE collation] [ USING expression ]]
ALTER [ COLUMN ] column_name SET DEFAULT expression
ALTER [ COLUMN ] column_name DROP DEFAULT

-- Podemos adicionar ou remover uma coluna de uma tabela existente. No entanto, há algumas restrições a serem consideradas.


CREATE TEMPORARY TABLE cursos_programacao (
    id_curso INTEGER PRIMARY KEY,
    nome_curso VARCHAR(255) NOT NULL
);

INSERT INTO cursos_programacao

SELECT academico.curso.id, 
       academico.curso.nome
  FROM academico.curso
  JOIN academico.categoria ON academico.categoria.id = academico.curso.categoria_id
 WHERE categoria_id = 2;
-- fazer um INSERT a partir de um select.

UPDATE teste.cursos_programacao SET nome_curso = nome
    FROM academico.curso WHERE testes.cursos_programacao.id_curso = academico.curso.id
        AND academico.curso.id < 10;
--ATUALIZAÇÃO DA TABELA CURSO COM O ID MENOS QUE 10 

DELETE FROM curso
      USING categoria
      WHERE categoria.id = curso.categoria_id
        AND categoria.nome = 'Teste';
--podemos realizar junções para filtrar o que queremos excluir de nossas tabelas, mas a sintaxe é um pouco diferente.

CREATE [ { TEMPORARY | TEMP } | UNLOGGED ] SEQUENCE [ IF NOT EXISTS ] name
    [ AS data_type ]
    [ INCREMENT [ BY ] increment ]
    [ MINVALUE minvalue | NO MINVALUE ] [ MAXVALUE maxvalue | NO MAXVALUE ]
    [ START [ WITH ] start ] [ CACHE cache ] [ [ NO ] CYCLE ]
    [ OWNED BY { table_name.column_name | NONE } ]
--exemplos de sequencias