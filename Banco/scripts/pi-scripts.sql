CREATE TABLE public.adotante (
	id serial NOT NULL,
	nome varchar NOT NULL,
	email varchar NOT NULL,
	senha varchar NOT NULL,
	endereco int4 NOT NULL,
	renda_mensal float4 NOT NULL,
	profissao varchar NOT NULL,
	CONSTRAINT adotante_pk PRIMARY KEY (id),
	CONSTRAINT adotante_un UNIQUE (email)
	CONSTRAINT adotante_fk FOREIGN KEY (endereco) REFERENCES public.endereco(id);
);

CREATE TABLE public.crianca (
	id serial NOT NULL,
	nome varchar NOT NULL,
	idade int NOT NULL,
	deficiencia int4 NOT NULL,
	caracteristica text NOT NULL,
	CONSTRAINT crianca_pk PRIMARY KEY (id),
	CONSTRAINT crianca_fk FOREIGN KEY (deficiencia) REFERENCES public.deficiencia(id)
);

CREATE TABLE public.deficiencia (
	id serial NOT NULL,
	tipo varchar NOT NULL,
	nome int NOT NULL,
	deficiencia boolean NOT NULL,
	CONSTRAINT deficiencia_pk PRIMARY KEY (id),
);


