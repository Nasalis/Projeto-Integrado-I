--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2022-02-10 20:23:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 236 (class 1255 OID 33369)
-- Name: cadastra_crianca_pcd(integer, character varying, integer, character varying, text); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.cadastra_crianca_pcd(IN instituicao_id integer, IN c_nome character varying, IN c_idade integer, IN c_deficiencia character varying, IN c_caracteristica text)
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


ALTER PROCEDURE public.cadastra_crianca_pcd(IN instituicao_id integer, IN c_nome character varying, IN c_idade integer, IN c_deficiencia character varying, IN c_caracteristica text) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 33372)
-- Name: clear(character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.clear(IN tabela character varying)
    LANGUAGE plpgsql
    AS $$
	DECLARE 
		seq varchar;
	BEGIN
		IF tabela LIKE 'adotante' OR tabela LIKE 'instituicao' THEN 
			RAISE EXCEPTION 'aaaa';
		END IF;
	
		seq := tabela || '_id_seq';
		EXECUTE format('TRUNCATE TABLE %I CASCADE', tabela);
		EXECUTE format('ALTER SEQUENCE %I RESTART WITH 1', seq);
	END;
$$;


ALTER PROCEDURE public.clear(IN tabela character varying) OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 33321)
-- Name: valida_mensagem_fnc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.valida_mensagem_fnc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		if (EXISTS (SELECT 1 FROM adotante a WHERE a.id = NEW.id_origem)
		     AND EXISTS (SELECT 1 FROM instituicao i WHERE i.id = NEW.id_destino))
		   OR (EXISTS (SELECT 1 FROM instituicao i WHERE i.id = NEW.id_origem)
		     AND EXISTS (SELECT 1 FROM adotante a WHERE a.id = NEW.id_destino ))
		then
			return new;
		end if;
		RAISE EXCEPTION 'Nao existe chat entre adotantes ou instituicoes!';
		return null;
	END;
$$;


ALTER FUNCTION public.valida_mensagem_fnc() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 33329)
-- Name: adocao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adocao (
    id integer NOT NULL,
    id_adotante integer NOT NULL,
    id_instituicao integer NOT NULL,
    id_crianca integer NOT NULL
);


ALTER TABLE public.adocao OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 33328)
-- Name: adocao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adocao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adocao_id_seq OWNER TO postgres;

--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 218
-- Name: adocao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adocao_id_seq OWNED BY public.adocao.id;


--
-- TOC entry 211 (class 1259 OID 33256)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 33275)
-- Name: adotante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adotante (
    id integer DEFAULT nextval('public.user_id_seq'::regclass) NOT NULL,
    nome character varying NOT NULL,
    email character varying NOT NULL,
    senha character varying NOT NULL,
    endereco integer NOT NULL,
    renda_mensal real NOT NULL,
    profissao character varying NOT NULL
);


ALTER TABLE public.adotante OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33382)
-- Name: crianca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crianca (
    id integer NOT NULL,
    nome character varying NOT NULL,
    idade integer NOT NULL,
    deficiencia character varying,
    caracteristica text NOT NULL,
    adotado boolean NOT NULL
);


ALTER TABLE public.crianca OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 33381)
-- Name: crianca_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crianca_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crianca_id_seq OWNER TO postgres;

--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 222
-- Name: crianca_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crianca_id_seq OWNED BY public.crianca.id;


--
-- TOC entry 210 (class 1259 OID 33177)
-- Name: endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco (
    id integer NOT NULL,
    estado character varying NOT NULL,
    cidade character varying NOT NULL,
    bairro character varying NOT NULL,
    rua character varying NOT NULL,
    numero character varying NOT NULL
);


ALTER TABLE public.endereco OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 33176)
-- Name: endereco_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.endereco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.endereco_id_seq OWNER TO postgres;

--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 209
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;


--
-- TOC entry 221 (class 1259 OID 33351)
-- Name: filiacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filiacao (
    id integer NOT NULL,
    id_instituicao integer NOT NULL,
    id_crianca integer NOT NULL
);


ALTER TABLE public.filiacao OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 33350)
-- Name: filiacao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.filiacao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.filiacao_id_seq OWNER TO postgres;

--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 220
-- Name: filiacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.filiacao_id_seq OWNED BY public.filiacao.id;


--
-- TOC entry 212 (class 1259 OID 33258)
-- Name: instituicao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instituicao (
    id integer DEFAULT nextval('public.user_id_seq'::regclass) NOT NULL,
    nome character varying NOT NULL,
    email character varying NOT NULL,
    senha character varying NOT NULL,
    endereco integer NOT NULL,
    publico_alvo character varying NOT NULL
);


ALTER TABLE public.instituicao OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 33310)
-- Name: mensagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mensagem (
    id integer NOT NULL,
    id_origem integer NOT NULL,
    id_destino integer NOT NULL,
    conteudo text NOT NULL,
    data_envio timestamp without time zone NOT NULL,
    data_chegada timestamp without time zone
);


ALTER TABLE public.mensagem OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 33309)
-- Name: mensagem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mensagem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mensagem_id_seq OWNER TO postgres;

--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 216
-- Name: mensagem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mensagem_id_seq OWNED BY public.mensagem.id;


--
-- TOC entry 215 (class 1259 OID 33296)
-- Name: postagem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.postagem (
    id integer NOT NULL,
    id_instituicao integer NOT NULL,
    texto character varying,
    imagem character varying,
    data_postagem timestamp without time zone NOT NULL
);


ALTER TABLE public.postagem OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 33295)
-- Name: postagem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.postagem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.postagem_id_seq OWNER TO postgres;

--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 214
-- Name: postagem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.postagem_id_seq OWNED BY public.postagem.id;


--
-- TOC entry 3206 (class 2604 OID 33332)
-- Name: adocao id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adocao ALTER COLUMN id SET DEFAULT nextval('public.adocao_id_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 33385)
-- Name: crianca id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crianca ALTER COLUMN id SET DEFAULT nextval('public.crianca_id_seq'::regclass);


--
-- TOC entry 3201 (class 2604 OID 33180)
-- Name: endereco id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 33354)
-- Name: filiacao id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filiacao ALTER COLUMN id SET DEFAULT nextval('public.filiacao_id_seq'::regclass);


--
-- TOC entry 3205 (class 2604 OID 33313)
-- Name: mensagem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensagem ALTER COLUMN id SET DEFAULT nextval('public.mensagem_id_seq'::regclass);


--
-- TOC entry 3204 (class 2604 OID 33299)
-- Name: postagem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postagem ALTER COLUMN id SET DEFAULT nextval('public.postagem_id_seq'::regclass);


--
-- TOC entry 3383 (class 0 OID 33329)
-- Dependencies: 219
-- Data for Name: adocao; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3377 (class 0 OID 33275)
-- Dependencies: 213
-- Data for Name: adotante; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.adotante VALUES (6, 'David Almeida', 'davidalmeida@gmail.com', '123456', 6, 2500, 'Professor');
INSERT INTO public.adotante VALUES (7, 'Alberto Craveiro', 'albertocraveiro@gmail.com', '123456', 7, 4500, 'Arquiteto');
INSERT INTO public.adotante VALUES (8, 'José dos Santos', 'josesantos@gmail.com', '123456', 8, 8000, 'Dentista');
INSERT INTO public.adotante VALUES (9, 'Roberto Dantas', 'robertodantas@gmail.com', '123456', 9, 2000, 'Vendedor');
INSERT INTO public.adotante VALUES (10, 'Mikaelle Silva', 'mikaellesilva@gmail.com', '123456', 10, 5000, 'Empresaria');


--
-- TOC entry 3387 (class 0 OID 33382)
-- Dependencies: 223
-- Data for Name: crianca; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.crianca VALUES (1, 'João Pedro', 8, NULL, 'Moreno, magro e alto', false);
INSERT INTO public.crianca VALUES (2, 'Matheus Santos', 9, NULL, 'cabelo liso e curto, baixo', false);
INSERT INTO public.crianca VALUES (3, 'Saulo Carlos', 6, 'Tetraplégico', 'loiro e olhos castanhos', false);
INSERT INTO public.crianca VALUES (4, 'Camila Silva', 7, NULL, 'alto e magro', false);
INSERT INTO public.crianca VALUES (5, 'Jordana Martins', 10, 'Nanismo', 'olhos claros e cabelos ondulados', false);


--
-- TOC entry 3374 (class 0 OID 33177)
-- Dependencies: 210
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.endereco VALUES (1, 'Ceará', 'Fortaleza', 'Bela Vista', 'Rua Ministro Sérgio Mota', '423');
INSERT INTO public.endereco VALUES (2, 'Sergipe', 'Aracaju', 'Pereira Lobo', 'Rua Vicente Celestino', '1253');
INSERT INTO public.endereco VALUES (3, 'São Paulo', 'São Bernardo do Campo', 'Jardim via Anchieta', 'Rua Alberto Tôrres', '586');
INSERT INTO public.endereco VALUES (4, 'Maranhão', 'Imperatriz', 'Jardim Tropical', 'Rua Dom Cinco', '2652');
INSERT INTO public.endereco VALUES (5, 'Espírito Santo', 'Domingos Martins', 'Ponto Alto', 'Rua Reinoldo Kiefer', '1942');
INSERT INTO public.endereco VALUES (6, 'Ceará', 'Fortaleza', 'Farias Brito', 'Rua Carlos Severo', '521');
INSERT INTO public.endereco VALUES (7, 'Sergipe', 'Aracaju', 'Palestina', 'Rua Artur Fortes', '973');
INSERT INTO public.endereco VALUES (8, 'São Paulo', 'São Bernardo do Campo', 'Santa Terezina', 'Rua Carlos Lacerda', '231');
INSERT INTO public.endereco VALUES (9, 'Maranhão', 'Imperatriz', 'Ouro Verde', 'Rua Padre Cicero', '457');
INSERT INTO public.endereco VALUES (10, 'Espírito Santo', 'Domingos Martins', 'Ponto Alto', 'Avenida Presidente Vargas', '789');


--
-- TOC entry 3385 (class 0 OID 33351)
-- Dependencies: 221
-- Data for Name: filiacao; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.filiacao VALUES (1, 4, 1);
INSERT INTO public.filiacao VALUES (2, 1, 2);
INSERT INTO public.filiacao VALUES (3, 3, 3);
INSERT INTO public.filiacao VALUES (4, 5, 4);
INSERT INTO public.filiacao VALUES (5, 2, 5);


--
-- TOC entry 3376 (class 0 OID 33258)
-- Dependencies: 212
-- Data for Name: instituicao; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instituicao VALUES (1, 'Comunidade Pais e Filhos', 'pais_e_filhos@email.com', 'paisefilhos95_2', 2, 'orfãos');
INSERT INTO public.instituicao VALUES (2, 'Laço da Paz', 'lacodapaz@email.com', 'laco-paz1995', 4, 'abandonados');
INSERT INTO public.instituicao VALUES (3, 'Lealdade', 'lealdade_instituicao@email.com', 'lealdade251jda2', 1, 'abandonados');
INSERT INTO public.instituicao VALUES (4, 'Vale das Crianças', 'vale_das_criancas@email.com', 'criancas2002dovale', 3, 'deficientes físicos');
INSERT INTO public.instituicao VALUES (5, 'Bons Irmãos', 'bons_irmaos_2010@email.com', '4irmaos2010', 5, 'deficientes mentais');


--
-- TOC entry 3381 (class 0 OID 33310)
-- Dependencies: 217
-- Data for Name: mensagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.mensagem VALUES (1, 6, 1, 'Quero adotar alguma crianca!', '2021-01-08 16:32:21', NULL);
INSERT INTO public.mensagem VALUES (2, 1, 2, 'Quero adotar sua crianca, talkei?', '2021-01-08 16:32:21', NULL);
INSERT INTO public.mensagem VALUES (3, 1, 2, 'Quero adotar sua crianca, talkei?', '2021-01-08 16:32:21', NULL);
INSERT INTO public.mensagem VALUES (4, 1, 2, 'Quero adotar sua crianca, talkei?', '2021-01-08 16:32:21', NULL);
INSERT INTO public.mensagem VALUES (5, 1, 2, 'Quero adotar sua crianca, talkei?', '2021-01-08 16:32:21', NULL);
INSERT INTO public.mensagem VALUES (22, 6, 1, 'Quero adotar alguma crianca!', '2021-01-08 16:32:21', NULL);


--
-- TOC entry 3379 (class 0 OID 33296)
-- Dependencies: 215
-- Data for Name: postagem; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.postagem VALUES (1, 2, 'Venha e adote uma criança!', NULL, '2021-01-08 16:32:21');
INSERT INTO public.postagem VALUES (2, 4, 'Adotar é apoiar a vida! Incentive a adoção', NULL, '2021-03-24 12:24:54');
INSERT INTO public.postagem VALUES (3, 5, 'A cada dia novas crianças sendo adotadas! Salvem as crianças com um novo lar!', NULL, '2021-08-30 15:47:05');
INSERT INTO public.postagem VALUES (4, 3, 'Todos os dias mais crianças esperam para serem adotadas! Ajude-as!', NULL, '2021-09-12 10:15:05');
INSERT INTO public.postagem VALUES (5, 1, 'Seja a luz no caminho de uma nova criança!', NULL, '2022-01-23 18:24:25');
INSERT INTO public.postagem VALUES (6, 2, 'Venha e adote uma criança!', NULL, '2021-01-08 16:32:20');


--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 218
-- Name: adocao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adocao_id_seq', 1, false);


--
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 222
-- Name: crianca_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crianca_id_seq', 5, true);


--
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 209
-- Name: endereco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_id_seq', 10, true);


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 220
-- Name: filiacao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.filiacao_id_seq', 5, true);


--
-- TOC entry 3404 (class 0 OID 0)
-- Dependencies: 216
-- Name: mensagem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mensagem_id_seq', 22, true);


--
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 214
-- Name: postagem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.postagem_id_seq', 6, true);


--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 211
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 10, true);


--
-- TOC entry 3224 (class 2606 OID 33334)
-- Name: adocao adocao_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adocao
    ADD CONSTRAINT adocao_pk PRIMARY KEY (id);


--
-- TOC entry 3216 (class 2606 OID 33282)
-- Name: adotante adotante_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adotante
    ADD CONSTRAINT adotante_pk PRIMARY KEY (id);


--
-- TOC entry 3218 (class 2606 OID 33284)
-- Name: adotante adotante_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adotante
    ADD CONSTRAINT adotante_un UNIQUE (email);


--
-- TOC entry 3226 (class 2606 OID 33389)
-- Name: crianca crianca_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crianca
    ADD CONSTRAINT crianca_pk PRIMARY KEY (id);


--
-- TOC entry 3210 (class 2606 OID 33184)
-- Name: endereco endereco_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pk PRIMARY KEY (id);


--
-- TOC entry 3212 (class 2606 OID 33265)
-- Name: instituicao instituicao_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instituicao
    ADD CONSTRAINT instituicao_pk PRIMARY KEY (id);


--
-- TOC entry 3222 (class 2606 OID 33317)
-- Name: mensagem mensagem_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensagem
    ADD CONSTRAINT mensagem_pk PRIMARY KEY (id);


--
-- TOC entry 3220 (class 2606 OID 33303)
-- Name: postagem postagem_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postagem
    ADD CONSTRAINT postagem_pk PRIMARY KEY (id);


--
-- TOC entry 3214 (class 2606 OID 33267)
-- Name: instituicao unique_keys; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instituicao
    ADD CONSTRAINT unique_keys UNIQUE (email);


--
-- TOC entry 3233 (class 2620 OID 33322)
-- Name: mensagem valida_mensagem; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER valida_mensagem BEFORE INSERT ON public.mensagem FOR EACH ROW EXECUTE FUNCTION public.valida_mensagem_fnc();


--
-- TOC entry 3228 (class 2606 OID 33285)
-- Name: adotante adotante_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adotante
    ADD CONSTRAINT adotante_fk FOREIGN KEY (endereco) REFERENCES public.endereco(id);


--
-- TOC entry 3230 (class 2606 OID 33335)
-- Name: adocao adotante_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adocao
    ADD CONSTRAINT adotante_fk FOREIGN KEY (id_adotante) REFERENCES public.adotante(id);


--
-- TOC entry 3227 (class 2606 OID 33268)
-- Name: instituicao instituicao_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instituicao
    ADD CONSTRAINT instituicao_fk FOREIGN KEY (endereco) REFERENCES public.endereco(id);


--
-- TOC entry 3231 (class 2606 OID 33340)
-- Name: adocao instituicao_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adocao
    ADD CONSTRAINT instituicao_fk FOREIGN KEY (id_instituicao) REFERENCES public.instituicao(id);


--
-- TOC entry 3232 (class 2606 OID 33355)
-- Name: filiacao instituicao_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filiacao
    ADD CONSTRAINT instituicao_fk FOREIGN KEY (id_instituicao) REFERENCES public.instituicao(id);


--
-- TOC entry 3229 (class 2606 OID 33304)
-- Name: postagem postagem_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.postagem
    ADD CONSTRAINT postagem_fk FOREIGN KEY (id_instituicao) REFERENCES public.instituicao(id);


-- Completed on 2022-02-10 20:23:10

--
-- PostgreSQL database dump complete
--

