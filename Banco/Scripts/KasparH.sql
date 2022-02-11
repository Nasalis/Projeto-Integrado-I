-- Cria as tabelas

CREATE TABLE public.endereco (
	id serial4 NOT NULL,
	estado varchar NOT NULL,
	cidade varchar NOT NULL,
	bairro varchar NOT NULL,
	rua varchar NOT NULL,
	numero varchar NOT NULL,
	CONSTRAINT endereco_pk PRIMARY KEY (id)
);

CREATE TABLE public.adotante (
	id serial4 NOT NULL,
	nome varchar NOT NULL,
	rg varchar NOT NULL,
	cpf varchar NOT NULL,
	email varchar NOT NULL,
	senha varchar NOT NULL,
	endereco int4 NOT NULL,
	renda_mensal float4 NOT NULL,
	profissao varchar NOT NULL,
	comprovante_endereco varchar NOT NULL,
	antecedente_criminal varchar NOT NULL,
	exame_psicotecnico varchar NOT NULL,
	ativo bool NOT NULL,
	CONSTRAINT adotante_pk PRIMARY KEY (id),
	CONSTRAINT adotante_un UNIQUE (email, cpf),
	CONSTRAINT adotante_fk FOREIGN KEY (endereco) REFERENCES public.endereco(id)
);

CREATE TABLE public.instituicao (
  id serial4 NOT NULL,
  nome varchar NOT NULL,
  email varchar NOT NULL,
  senha varchar NOT NULL,
  endereco int4 NOT NULL,
  publico_alvo varchar NOT NULL,
  cnpj varchar NOT NULL,
  ativo boolean NOT NULL,
  CONSTRAINT instituicao_pk PRIMARY KEY (id),
  CONSTRAINT unique_keys UNIQUE (email, cnpj),
  CONSTRAINT instituicao_fk FOREIGN KEY (endereco) REFERENCES public.endereco(id)
);

CREATE TABLE public.postagem (
	id serial4 NOT NULL,
	id_instituicao int4 NULL,
	texto varchar NULL,
	imagem varchar NULL,
	data_postagem timestamp NOT NULL,
	deletada boolean NOT NULL,
	CONSTRAINT postagem_pk PRIMARY KEY (id),
	CONSTRAINT postagem_fk FOREIGN KEY (id_instituicao) REFERENCES public.instituicao(id) ON DELETE CASCADE
);

CREATE TABLE public.mensagem (
	id serial4 NOT NULL,
	id_origem int4 NOT NULL,
	id_destino int4 NOT NULL,
	conteudo text NOT NULL,
	data_envio timestamp NOT NULL,
	data_chegada timestamp NULL,
	deletada boolean NOT NULL,
	CONSTRAINT mensagem_pk PRIMARY KEY (id)
);

CREATE TABLE public.crianca (
	id serial NOT NULL,
	nome varchar NOT NULL,
	idade int NOT NULL,
	deficiencia varchar NULL,
	caracteristica text NOT NULL,
	adotado boolean NOT NULL,
	CONSTRAINT crianca_pk PRIMARY KEY (id)
);

CREATE TABLE public.filiacao (
	id serial NOT NULL,
	id_instituicao int4 NOT NULL,
	id_crianca int4 NOT NULL,
	CONSTRAINT instituicao_fk FOREIGN KEY (id_instituicao) REFERENCES public.instituicao(id) ON DELETE CASCADE,
	CONSTRAINT crianca_fk FOREIGN KEY (id_crianca) REFERENCES public.crianca(id) ON DELETE CASCADE
);

CREATE TABLE public.adocao (
	id serial NOT NULL,
	id_adotante int4 NOT NULL,
	id_instituicao int4 NOT NULL,
	id_crianca int4 NOT NULL,
	CONSTRAINT adocao_pk PRIMARY KEY (id),
	CONSTRAINT adotante_fk FOREIGN KEY (id_adotante) REFERENCES public.adotante(id) ON DELETE CASCADE,
	CONSTRAINT instituicao_fk FOREIGN KEY (id_instituicao) REFERENCES public.instituicao(id) ON DELETE CASCADE,
	CONSTRAINT crianca_fk FOREIGN KEY (id_crianca) REFERENCES public.crianca(id) ON DELETE CASCADE
);

-- Inserções nas tabelas

INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Ceará', 'Fortaleza','Bela Vista', 'Rua Ministro Sérgio Mota', 423);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Sergipe', 'Aracaju','Pereira Lobo', 'Rua Vicente Celestino', 1253);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('São Paulo', 'São Bernardo do Campo','Jardim via Anchieta', 'Rua Alberto Tôrres', 586);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Maranhão', 'Imperatriz','Jardim Tropical', 'Rua Dom Cinco', 2652);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Espírito Santo', 'Domingos Martins','Ponto Alto', 'Rua Reinoldo Kiefer', 1942);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Ceará', 'Fortaleza','Farias Brito', 'Rua Carlos Severo', 521);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Sergipe', 'Aracaju','Palestina', 'Rua Artur Fortes', 973);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('São Paulo', 'São Bernardo do Campo','Santa Terezina', 'Rua Carlos Lacerda', 231);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Maranhão', 'Imperatriz','Ouro Verde', 'Rua Padre Cicero', 457);
INSERT INTO public.endereco (estado, cidade, bairro, rua, numero) VALUES ('Espírito Santo', 'Domingos Martins','Ponto Alto', 'Avenida Presidente Vargas', 789);

INSERT INTO public.instituicao (nome, email, senha, endereco, publico_alvo, CNPJ, ativo) VALUES ('Comunidade Pais e Filhos', 'pais_e_filhos@email.com', 'paisefilhos95_2', 2, 'orfãos', 'www/var/421/cnpj.png', true);
INSERT INTO public.instituicao (nome, email, senha, endereco, publico_alvo, CNPJ, ativo) VALUES ('Laço da Paz', 'lacodapaz@email.com', 'laco-paz1995', 4, 'abandonados', 'www/var/32/cnpj.png', true);
INSERT INTO public.instituicao (nome, email, senha, endereco, publico_alvo, CNPJ, ativo) VALUES ('Lealdade', 'lealdade_instituicao@email.com', 'lealdade251jda2', 1, 'abandonados', 'www/var/52/cnpj.png', true);
INSERT INTO public.instituicao (nome, email, senha, endereco, publico_alvo, CNPJ, ativo) VALUES ('Vale das Crianças', 'vale_das_criancas@email.com', 'criancas2002dovale', 3, 'deficientes físicos', 'www/var/215/cnpj.png', true);
INSERT INTO public.instituicao (nome, email, senha, endereco, publico_alvo, CNPJ, ativo) VALUES ('Bons Irmãos', 'bons_irmaos_2010@email.com', '4irmaos2010', 5, 'deficientes mentais', 'www/var/523/cnpj.png', true);

INSERT INTO public.postagem (id_instituicao, texto, imagem, data_postagem, deletada) VALUES (2, 'Venha e adote uma criança!', null, '2021-01-08 16:32:21', true);
INSERT INTO public.postagem (id_instituicao, texto, imagem, data_postagem, deletada) VALUES (4, 'Adotar é apoiar a vida! Incentive a adoção', null, '2021-03-24 12:24:54', true);
INSERT INTO public.postagem (id_instituicao, texto, imagem, data_postagem, deletada) VALUES (5, 'A cada dia novas crianças sendo adotadas! Salvem as crianças com um novo lar!', null, '2021-08-30 15:47:05', true);
INSERT INTO public.postagem (id_instituicao, texto, imagem, data_postagem, deletada) VALUES (3, 'Todos os dias mais crianças esperam para serem adotadas! Ajude-as!', null, '2021-09-12 10:15:05', true);
INSERT INTO public.postagem (id_instituicao, texto, imagem, data_postagem, deletada) VALUES (1, 'Seja a luz no caminho de uma nova criança!', null, '2022-01-23 18:24:25', true);
INSERT INTO public.postagem (id_instituicao, texto, imagem, data_postagem, deletada) VALUES (2, 'Venha e adote uma criança!', null, '2021-01-08 16:32:20', true);

INSERT INTO public.adotante (nome, email, senha, endereco, renda_mensal, profissao, rg, cpf, comprovante_endereco, antecedente_criminal, exame_psicotecnico, ativo) VALUES ('Alberto Craveiro', 'albertocraveiro@gmail.com', '123456', 7, 4500.00, 'Arquiteto', '12.523.536-9', '01452363412', 'www/var/215/endereco.png', 'www/var/215/ac.png', 'www/var/215/psicotecnico.png', true);
INSERT INTO public.adotante (nome, email, senha, endereco, renda_mensal, profissao, rg, cpf, comprovante_endereco, antecedente_criminal, exame_psicotecnico, ativo) VALUES ('José dos Santos', 'josesantos@gmail.com', '123456', 8, 8000.00, 'Dentista', '52.631.422-2', '63462164612', 'www/var/523/endereco.png', 'www/var/523/ac.png', 'www/var/523/psicotecnico.png', true);
INSERT INTO public.adotante (nome, email, senha, endereco, renda_mensal, profissao, rg, cpf, comprovante_endereco, antecedente_criminal, exame_psicotecnico, ativo) VALUES ('Roberto Dantas', 'robertodantas@gmail.com', '123456', 9, 2000.00, 'Vendedor', '32.842.521-6', '94263461216', 'www/var/122/endereco.png', 'www/var/122/ac.png', 'www/var/122/psicotecnico.png', true);
INSERT INTO public.adotante (nome, email, senha, endereco, renda_mensal, profissao, rg, cpf, comprovante_endereco, antecedente_criminal, exame_psicotecnico, ativo) VALUES ('Mikaelle Silva', 'mikaellesilva@gmail.com', '123456', 10, 5000.00, 'Empresaria', '62.523.124-5', '92915263412', 'www/var/092/endereco.png', 'www/var/092/ac.png', 'www/var/092/psicotecnico.png', true);

CALL public.cadastra_crianca_pcd(4, 'João Pedro', 8, null, 'Moreno, magro e alto');
CALL public.cadastra_crianca_pcd(1, 'Matheus Santos', 9, null,'cabelo liso e curto, baixo');
CALL public.cadastra_crianca_pcd(3, 'Saulo Carlos', 6, 'Tetraplégico', 'loiro e olhos castanhos');
CALL public.cadastra_crianca_pcd(5, 'Camila Silva', 7, null, 'alto e magro');
CALL public.cadastra_crianca_pcd(2, 'Jordana Martins', 10, 'Nanismo', 'olhos claros e cabelos ondulados');

INSERT INTO public.mensagem (id_origem, id_destino, conteudo, data_envio, deletada) VALUES (6, 1, 'Quero adotar alguma crianca!', '2021-01-08 16:32:21', false);
INSERT INTO public.mensagem (id_origem, id_destino, conteudo, data_envio, deletada) VALUES (1, 2, 'Quero adotar sua crianca, talkei?', '2021-01-08 16:32:21', false);

-- Functions

CREATE OR REPLACE FUNCTION public.validar_mensagem_fnc()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
	BEGIN
		IF (EXISTS (SELECT 1 FROM adotante a WHERE a.id = NEW.id_origem)
		     AND EXISTS (SELECT 1 FROM instituicao i WHERE i.id = NEW.id_destino))
		   OR (EXISTS (SELECT 1 FROM instituicao i WHERE i.id = NEW.id_origem)
		     AND EXISTS (SELECT 1 FROM adotante a WHERE a.id = NEW.id_destino ))
		THEN
			RETURN NEW;
		END IF;
		RAISE EXCEPTION 'Nao existe chat entre adotantes ou instituicoes!';
		RETURN NULL;
	END;
$function$
;

CREATE OR REPLACE PROCEDURE public.cadastrar_crianca_pcd(IN instituicao_id INTEGER ,
														IN c_nome VARCHAR,
														IN c_idade INTEGER,
														IN c_deficiencia VARCHAR,
														IN c_caracteristica TEXT)
 LANGUAGE plpgsql
AS $$
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM instituicao i WHERE i.id = instituicao_id) THEN 
			RAISE EXCEPTION 'Instituicao nao cadastrada no banco de dados!';
		END IF;

		INSERT INTO public.crianca (nome, idade, deficiencia, caracteristica, adotado)
		VALUES (c_nome, c_idade, c_deficiencia, c_caracteristica, false);
		
		INSERT INTO public.filiacao (id_instituicao, id_crianca) VALUES (instituicao_id, (SELECT currval('crianca_id_seq')));
	END;
$$;

CREATE OR REPLACE PROCEDURE public.deletar_adotante_pcd(IN adotante_email VARCHAR)
 LANGUAGE plpgsql
AS $$
	DECLARE
		adotante_id INTEGER;
	BEGIN
		adotante_id := (SELECT id FROM adotante WHERE adotante.email LIKE adotante_email);
		DELETE FROM adotante WHERE adotante.id = adotante_id;
		DELETE FROM mensagem m WHERE (m.id_origem = adotante_id OR m.id_destino = adotante_id);
	END;
$$;

CREATE OR REPLACE PROCEDURE public.deletar_instituicao(IN instituicao_email VARCHAR)
 LANGUAGE plpgsql
AS $$
	DECLARE
		instituicao_id INTEGER;
	BEGIN
		instituicao_id := (SELECT id FROM instituicao WHERE instituicao.email LIKE instituicao_email);
		DELETE FROM instituicao i WHERE i.id = instituicao_id;
		DELETE FROM mensagem m WHERE (m.id_origem = instituicao_id OR m.id_destino = instituicao_id);
	END;
$$;

-- Triggers

CREATE OR REPLACE TRIGGER valida_mensagem BEFORE
INSERT
    ON
    public.mensagem FOR EACH ROW EXECUTE FUNCTION valida_mensagem_fnc()

-- Login
    SELECT nome, email, cpf, renda_mensal, profissao, e.estado, e.cidade, e.bairro, e.rua, e.numero
    FROM adotante
    INNER JOIN endereco e ON adotante.endereco = e.id 
    WHERE email LIKE $1 AND senha LIKE $2 AND ativo = true
    
    SELECT nome, email, cnpj, publico_alvo, e.estado, e.cidade, e.bairro, e.rua, e.numero
    FROM instituicao 
    INNER JOIN endereco e ON instituicao.endereco = e.id 
    WHERE email LIKE $1 AND senha LIKE $2 AND ativo = true
    
-- Cadastro
    -- Adotante
    INSERT INTO public.adotante (nome, cpf, email, senha, endereco, renda_mensal, profissao,
    							 comprovante_endereco, antecedente_criminal, exame_psicotecnico, ativo)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, false);
    
   	-- Instituicao
    INSERT INTO public.instituicao (nome, email, senha, endereco, publico_alvo, cnpj, ativo)
    VALUES ($1, $2, $3, $4, $5, $6, false);
   
   	-- Crianca
   	CALL public.cadastra_crianca_pcd(:instituicao_id, :c_nome, :c_idade, :c_deficiencia, :c_caracteristica)
   	
   	-- Lista Usuarios Inativos
   	-- Adotante
   	SELECT nome, email, cpf, renda_mensal, profissao FROM adotante a WHERE a.ativo = false
   	
   	-- Instituicao
   	SELECT nome, email, publico_alvo, cnpj FROM instituicao i WHERE i.ativo = false
   	
-- Valida Adotante
	UPDATE public.adotante SET ativo = true WHERE adotante.id = $1
   	
-- Valida Instituicao
	UPDATE public.instituicao SET ativo = true WHERE instituicao.id = $1
   	
-- Listar Instituicao
	SELECT i.id, i.nome, i.email, i.publico_alvo, i.cnpj, e.estado, e.cidade, e.bairro, e.rua, e.numero FROM instituicao i
	INNER JOIN endereco e ON e.id = i.endereco
	WHERE ativo = true

-- Listar Crianca
	-- Sem filtro
	SELECT c.nome, c.idade, c.deficiencia, c.caracteristica FROM filiacao f
	INNER JOIN crianca c ON c.id = f.id_crianca
	WHERE f.id_instituicao = $1
	
	-- Filtro
	SELECT c.nome, c.idade, c.deficiencia, c.caracteristica FROM filiacao f
	INNER JOIN crianca c ON c.id = f.id_crianca
	WHERE f.id_instituicao = $1 AND c.idade $2 $3

-- Listar Postagens
	SELECT * FROM postagem p WHERE p.deletada = false ORDER BY data_postagem DESC
	
	SELECT * FROM postagem p WHERE p.deletada = false AND p.id_instituicao = $1 ORDER BY data_postagem DESC
	
-- Criar Postagem
	INSERT INTO public.postagem (id_instituicao, texto, imagem, data_postagem, deletada)
	VALUES ($1, $2, $3, $4, false);
	
-- Enviar Mensagem
	INSERT INTO public.mensagem (id_origem, id_destino, conteudo, data_envio, data_chegada, deletada)
	VALUES ($1, $2, $3, $4, null, false)
	
-- Receber Mensagem
	UPDATE public.mensagem SET data_chegada = $1 WHERE mensagem.id = $2
	
-- Adotar
	INSERT INTO public.adocao (id_adotante, id_instituicao, id_crianca) VALUES ($1, $2, $3)


