--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2022-02-09 22:24:27

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
-- TOC entry 3326 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 33142)
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
-- TOC entry 209 (class 1259 OID 33141)
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
-- TOC entry 3327 (class 0 OID 0)
-- Dependencies: 209
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.endereco_id_seq OWNED BY public.endereco.id;


--
-- TOC entry 212 (class 1259 OID 33159)
-- Name: instituicao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instituicao (
    id integer NOT NULL,
    nome character varying NOT NULL,
    email character varying NOT NULL,
    senha character varying NOT NULL,
    endereco integer NOT NULL,
    publico_alvo character varying NOT NULL
);


ALTER TABLE public.instituicao OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 33158)
-- Name: instituicao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instituicao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instituicao_id_seq OWNER TO postgres;

--
-- TOC entry 3328 (class 0 OID 0)
-- Dependencies: 211
-- Name: instituicao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instituicao_id_seq OWNED BY public.instituicao.id;


--
-- TOC entry 3169 (class 2604 OID 33145)
-- Name: endereco id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_seq'::regclass);


--
-- TOC entry 3170 (class 2604 OID 33162)
-- Name: instituicao id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instituicao ALTER COLUMN id SET DEFAULT nextval('public.instituicao_id_seq'::regclass);


--
-- TOC entry 3318 (class 0 OID 33142)
-- Dependencies: 210
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3320 (class 0 OID 33159)
-- Dependencies: 212
-- Data for Name: instituicao; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3329 (class 0 OID 0)
-- Dependencies: 209
-- Name: endereco_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_id_seq', 1, false);


--
-- TOC entry 3330 (class 0 OID 0)
-- Dependencies: 211
-- Name: instituicao_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instituicao_id_seq', 1, false);


--
-- TOC entry 3172 (class 2606 OID 33149)
-- Name: endereco endereco_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pk PRIMARY KEY (id);


--
-- TOC entry 3174 (class 2606 OID 33166)
-- Name: instituicao instituicao_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instituicao
    ADD CONSTRAINT instituicao_pk PRIMARY KEY (id);


--
-- TOC entry 3176 (class 2606 OID 33173)
-- Name: instituicao unique_keys; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instituicao
    ADD CONSTRAINT unique_keys UNIQUE (email);


--
-- TOC entry 3177 (class 2606 OID 33167)
-- Name: instituicao instituicao_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instituicao
    ADD CONSTRAINT instituicao_fk FOREIGN KEY (endereco) REFERENCES public.endereco(id);


-- Completed on 2022-02-09 22:24:28

--
-- PostgreSQL database dump complete
--

