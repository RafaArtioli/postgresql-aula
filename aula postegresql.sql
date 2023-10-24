CREATE DATABASE alura;

CREATE TABLE aluno(
	id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR (255) NOT NULL,
	data_nascimento DATE NOT NULL
);

DROP TABLE aluno_curso, curso;

CREATE TABLE curso(
	id SERIAL PRIMARY KEY,
	nome VARCHAR (255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE categoria(
	id SERIAL PRIMARY KEY,
	nome VARCHAR (255) NOT NULL
);

CREATE TABLE aluno_curso(
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);


INSERT INTO aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES('Rafael', 'Rosa', '1976-02-01');

INSERT INTO categoria (nome) VALUES ('Front-End'), ('Programação'), ('Banco de dados'), ('Data Science');

INSERT INTO curso (nome, categoria_id) VALUES
    ('HTML',1),
    ('CSS',1),
    ('JS',1),
    ('PHP',2),
    ('Java',2),
    ('C++',2),
    ('PostgreSQL',3),
    ('MySQL',3),
    ('Oracle',3),
    ('SQL Server',3),
    ('SQLite',3),
    ('Pandas',4),
    ('Machine Learning',4),
    ('Power BI',4);

INSERT INTO aluno_curso VALUES (1,4),(1,11),(2,1),(2,2),(3,4),(3,3),(4,4),(4,6),(4,5);

SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id;
	
SELECT *
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id;
	
SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(curso.id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id
GROUP BY aluno.primeiro_nome, aluno.ultimo_nome;

SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(aluno_curso.curso_id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1,2
ORDER BY numero_cursos DESC;

SELECT curso.nome,
       COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC

  SELECT curso.nome,
         COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
     HAVING COUNT(aluno_curso.aluno_id) > 2
ORDER BY numero_alunos DESC;


SELECT TRIM(UPPER(CONCAT('Vinicius', ' ', 'Dias') || ' '));

SELECT (primeiro_nome || ultimo_nome) AS nome_completo, NOW()::DATE, data_nascimento FROM aluno;

SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
    NOW()::DATE - data_nascimento
  FROM aluno;
  
  --Entretanto, nosso resultado aparece em dias. Testaremos se, dividindo o resultado por 365, obteremos a idade aproximada de cada pessoa em anos, ou seja, (NOW()::DATE - data_nascimento) / 365) , e passaremos o alias “Idade”.
 SELECT (primeiro_nome ||' ' || ultimo_nome) AS nome_completo,
    (NOW()::DATE - data_nascimento)/365 AS idade
  FROM aluno;
 
 --Uma forma mais fácil de fazer esse cálculo é através da função AGE() , informando a data de nascimento nos parâmetros.
 SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
    AGE(data_nascimento) AS idade
  FROM aluno;
  
  -- A primeira é transformar o campo "Idade" em string e selecionar os dois primeiros caracteres. A outra forma, que é mais interessante, é utilizando a função EXTRACT(), com a qual podemos extrair parte da data, no nosso caso, o ano.
  SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
    EXTRACT(YEAR FROM AGE(data_nascimento)) AS idade
  FROM aluno;
  
  --Criando uma view
  CREATE VIEW nome_para_view
    AS query_que_queremos_executar
	
CREATE VIEW vw_cursos_por_categoria
    AS SELECT categoria.nome AS categoria,
       COUNT(curso.id) as numero_cursos
   FROM categoria
   JOIN curso ON curso.categoria_id = categoria.id
GROUP BY categoria;

-- é possível juntar views com outras tabelas ou aplicar filtros, como no exemplo abaixo.
SELECT categoria
    FROM vw_cursos_por_categoria AS categoria_cursos
  WHERE numero_cursos > 3;

