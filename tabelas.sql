--TABLES/SEQUENCES/TRIGGERS
DROP SEQUENCE s_Atividades;
DROP TABLE Atividades;

DROP TABLE Regiao_Atividades;
DROP TABLE Nucleo_Atividades;
DROP TABLE Agrupamento_Atividades;
DROP TABLE Seccao_Atividades;

DROP SEQUENCE s_Escuteiros;
DROP TABLE Escuteiros;
DROP SEQUENCE s_Seccao;
DROP TABLE Seccao;
DROP SEQUENCE s_Agrupamento;
DROP TABLE Agrupamento;
DROP SEQUENCE s_Nucleo;
DROP TABLE Nucleo;
DROP SEQUENCE s_Regiao;
DROP TABLE Regiao;

CREATE SEQUENCE s_Atividades INCREMENT BY 1 START WITH 1;
CREATE TABLE Atividades(
	ID_ATIVIDADES NUMBER(3) PRIMARY KEY,
	DESCRICAO VARCHAR(256),
	LOCALIZACAO VARCHAR2(20) NOT NULL,
	DATA_INICIO DATE NOT NULL,
	DATA_FIM DATE
);

CREATE SEQUENCE s_Escuteiros INCREMENT BY 1 START WITH 1;
CREATE TABLE Escuteiros(
	ID_ESCUTEIRO NUMBER(10) PRIMARY KEY,
  SECCAO NUMBER(1) NOT NULL,
	NOME_ESCUTEIRO VARCHAR(100) NOT NULL,
	MORADA VARCHAR(100) NOT NULL,
	CC NUMBER(8) NOT NULL UNIQUE,
	NIF NUMBER(9) NOT NULL UNIQUE,
	ENCARREGADO_EDUCACAO VARCHAR(60),
	DATA_NASCIMENTO DATE NOT NULL,
	TELEMOVEL NUMBER(9) NOT NULL UNIQUE,
	EMAIL VARCHAR(35) NOT NULL UNIQUE,
	QUOTA CHAR(1) CHECK (QUOTA IN (0, 1)),
  ESTADO CHAR(1)CHECK (ESTADO IN (0, 1))
);

CREATE SEQUENCE s_Seccao INCREMENT BY 1 START WITH 1;
CREATE TABLE Seccao(
	ID_SECCAO NUMBER(3) PRIMARY KEY,
  AGRUPAMENTO NUMBER(5) NOT NULL,
	NOME_SECCAO VARCHAR(20) NOT NULL,
	EMAIL VARCHAR(35) NOT NULL UNIQUE
);

CREATE SEQUENCE s_Agrupamento INCREMENT BY 1 START WITH 1;
CREATE TABLE Agrupamento(
	ID_AGRUPAMENTO NUMBER(5) PRIMARY KEY,
  NUCLEO NUMBER(2) NOT NULL,
	NOME_AGRUPAMENTO VARCHAR(10) NOT NULL,
	TELEMOVEL NUMBER(9) NOT NULL UNIQUE,
	EMAIL VARCHAR(35) NOT NULL UNIQUE
);

CREATE SEQUENCE s_Nucleo INCREMENT BY 1 START WITH 1;
CREATE TABLE Nucleo(
	ID_NUCLEO NUMBER(2) PRIMARY KEY,
  REGIAO NUMBER(2) NOT NULL,
	NOME_NUCLEO VARCHAR(25) NOT NULL,
	EMAIL VARCHAR(35) NOT NULL UNIQUE
);

CREATE SEQUENCE s_Regiao INCREMENT BY 1 START WITH 1;
CREATE TABLE Regiao(
	ID_REGIAO NUMBER(2) PRIMARY KEY,
	NOME_REGIAO VARCHAR(10) NOT NULL
);

CREATE TABLE Seccao_Atividades(
	ID_ATIVIDADES NUMBER(3) PRIMARY KEY,
	ID_SECCAO NUMBER(2)	 
);

CREATE TABLE Regiao_Atividades(
	ID_ATIVIDADES NUMBER(3) PRIMARY KEY,
	ID_REGIAO NUMBER(2)	 
);

CREATE TABLE Nucleo_Atividades(
	ID_ATIVIDADES NUMBER(3) PRIMARY KEY,
	ID_NUCLEO NUMBER(2)	 
);

CREATE TABLE Agrupamento_Atividades(
	ID_ATIVIDADES NUMBER(3) PRIMARY KEY,
	ID_AGRUPAMENTO NUMBER(5)	 
);

ALTER TABLE Escuteiros ADD CONSTRAINT FK_SECCAO_ESCUTEIRO FOREIGN KEY (SECCAO) REFERENCES Seccao(ID_SECCAO);
ALTER TABLE Seccao ADD CONSTRAINT FK_AGRUPAMENTO_SECCAO FOREIGN KEY (AGRUPAMENTO) REFERENCES Agrupamento(ID_AGRUPAMENTO);
ALTER TABLE Agrupamento ADD CONSTRAINT FK_NUCLEO_AGRUPAMENTO FOREIGN KEY (NUCLEO) REFERENCES Nucleo(ID_NUCLEO);
ALTER TABLE Nucleo ADD CONSTRAINT FK_REGIAO_NUCLEO FOREIGN KEY (REGIAO) REFERENCES Regiao(ID_REGIAO);

ALTER TABLE Regiao_Atividades ADD CONSTRAINT FK_REGIAO_ATIVIDADES FOREIGN KEY (ID_REGIAO) REFERENCES Regiao(ID_REGIAO);
ALTER TABLE Nucleo_Atividades ADD CONSTRAINT FK_NUCLEO_ATIVIDADES FOREIGN KEY (ID_NUCLEO) REFERENCES Nucleo(ID_NUCLEO);
ALTER TABLE Agrupamento_Atividades ADD CONSTRAINT FK_AGRUPAMENTO_ATIVIDADES FOREIGN KEY (ID_AGRUPAMENTO) REFERENCES Agrupamento(ID_AGRUPAMENTO);
ALTER TABLE Seccao_Atividades ADD CONSTRAINT FK_SECCAO_ATIVIDADES FOREIGN KEY (ID_SECCAO) REFERENCES Seccao(ID_SECCAO);

/*CREATE OR REPLACE TRIGGER condicaoIdade
	BEFORE INSERT ON Escuteiros
	FOR EACH ROW
	DECLARE v_data DATE;
	BEGIN
		SELECT DATA_NASCIMENTO INTO v_data FROM Escuteiros WHERE ID_ESCUTEIRO = :NEW.ID_ESCUTEIRO;
		IF SYSDATE - v_data < 6 THEN 
			RAISE_APPLICATION_ERROR(-20002, ('N�O PODE INSERIR UM ESCUTEIRO COM IDADE INFERIROR A 6 ANOS'));
    ELSIF SYSDATE - v_data >= 18 THEN
      RAISE_APPLICATION_ERROR(-20004, ('O ESCUTEIRO PODE N�O TER ENCARREGADO DE EDUCA��O'));
		END IF;	
END;
/*/