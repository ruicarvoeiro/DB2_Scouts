--Adicionar Escuteiro
CREATE OR REPLACE PROCEDURE addEscuteiro(NOME_ESCUTEIRO IN VARCHAR, SECCAO IN NUMBER, MORADA IN VARCHAR, 
CC IN NUMBER, NIF IN NUMBER, ENCARREGADO_EDUCACAO IN VARCHAR, DATA_NASCIMENTO IN VARCHAR, TELEMOVEL IN NUMBER, EMAIL IN VARCHAR)
IS BEGIN
INSERT INTO Escuteiros VALUES ((SELECT NVL(MAX(ID_ESCUTEIRO), 0) + 1 FROM Escuteiros), SECCAO, NOME_ESCUTEIRO, MORADA, CC, NIF, ENCARREGADO_EDUCACAO, DATA_NASCIMENTO, TELEMOVEL, EMAIL, 1, 1);
END;
/
--Remover Escuteiro
CREATE OR REPLACE PROCEDURE deleteEscuteiro(P_ID_ESCUTEIRO IN NUMBER)
IS BEGIN
DELETE FROM Escuteiros WHERE ID_ESCUTEIRO = P_ID_ESCUTEIRO;
END deleteEscuteiro;
/
--Editar Quaota/Seccao/Estado Escuteiro
CREATE OR REPLACE PROCEDURE editEscuteiro(v_idEscuteiro IN NUMBER, v_quota NUMBER, v_nomeEscuteiro IN VARCHAR, v_seccao IN NUMBER, v_morada IN VARCHAR, 
v_cc IN NUMBER, v_nif IN NUMBER, v_EncarregadoEducacao IN VARCHAR, v_DataNascimento IN VARCHAR, v_telemovel IN NUMBER, v_email IN VARCHAR)
IS
BEGIN
UPDATE Escuteiros SET QUOTA = v_quota, v_seccao = SECCAO, ESTADO = v_estado WHERE ID_ESCUTEIRO = v_idEscuteiro;
addEscuteiro(v_nomeEscuteiro, v_seccao, v_morada, v_cc, v_nif, v_EncarregadoEducacao, v_DataNascimento,v_telemovel, v_email);
END editEscuteiro;
/
--Listar Escuteiro
CREATE OR REPLACE PROCEDURE listarEscuteiros(v_cursor OUT SYS_REFCURSOR)
IS BEGIN
OPEN v_cursor FOR
SELECT * FROM Escuteiros ORDER BY ID_ESCUTEIRO;
END;
/
--Adiconar Atividade OK
CREATE OR REPLACE PROCEDURE addActividade(DESCRICAO IN VARCHAR, LOCALIZACAO IN VARCHAR, DATA_INICIO IN DATE, DATA_FIM IN DATE)
IS BEGIN
INSERT INTO Atividades VALUES ((SELECT NVL(MAX(ID_ATIVIDADES), 0) + 1 FROM Atividades), DESCRICAO, LOCALIZACAO, DATA_INICIO, DATA_FIM);
END;
/
--Remover Atividade OK
CREATE OR REPLACE PROCEDURE deleteActividade(P_ID_ATIVIDADE IN NUMBER)
IS BEGIN
DELETE FROM Atividades WHERE ID_ATIVIDADES = P_ID_ATIVIDADE;
END deleteActividade;
/
--AQUI
--Adicionar Agrupamento
CREATE OR REPLACE PROCEDURE addAgrupamento(NUCLEO IN VARCHAR, NOME_AGRUPAMENTO IN VARCHAR, TELEMOVEL IN NUMBER, EMAIL VARCHAR)
IS BEGIN
  INSERT INTO Agrupamento VALUES((SELECT NVL(MAX(ID_AGRUPAMENTO), 0) + 1 FROM Agrupamento), NUCLEO, NOME_AGRUPAMENTO, TELEMOVEL, EMAIL);
END;
/
--Remover Agrupamento
CREATE OR REPLACE PROCEDURE deleteAgrupamento(P_ID_AGRUPAMENTO IN NUMBER)
IS BEGIN
  DELETE FROM Agrupamento WHERE ID_AGRUPAMENTO = P_ID_AGRUPAMENTO;
END deleteAgrupamento;
/
--Listar Agrupamento
CREATE OR REPLACE PROCEDURE listarAgrupamento(v_cursor OUT SYS_REFCURSOR)
IS BEGIN
	OPEN v_cursor FOR
  SELECT * FROM Agrupamento ORDER BY ID_AGRUPAMENTO;
END;
/
--Listar Núcleo
CREATE OR REPLACE PROCEDURE listarNucleo(v_cursor OUT SYS_REFCURSOR)
IS BEGIN
	OPEN v_cursor FOR
  SELECT * FROM Nucleo ORDER BY ID_NUCLEO;
END;
/
--Listar Região
CREATE OR REPLACE PROCEDURE listarRegiao(v_cursor OUT SYS_REFCURSOR)
IS BEGIN
	OPEN v_cursor FOR
	SELECT * FROM Regiao ORDER BY ID_REGIAO;
END;
/
--Listar Actividades por Agrupamento
CREATE OR REPLACE PROCEDURE listarActividadesAgrupamento (v_cursor OUT SYS_REFCURSOR)
IS BEGIN
	OPEN v_cursor FOR
		SELECT * FROM Agrupamento_Atividades  WHERE ID_ATIVIDADES = Atividades.ID_ATIVIDADES 
		AND ID_AGRUPAMENTO = Agrupamento.ID_AGRUPAMENTO;
END;
/
--Listar Actividades por Nucleo
CREATE OR REPLACE PROCEDURE listarNucleoAtividades (v_cursor OUT SYS_REFCURSOR)
IS BEGIN
	OPEN v_cursor FOR
		SELECT * FROM Nucleo_Atividades  WHERE ID_ATIVIDADES = Atividades.ID_ATIVIDADES 
		AND ID_NUCLEO = Nucleo.ID_NUCLEO;
END;
/
--Listar Actividades por Regiao
CREATE OR REPLACE PROCEDURE listarAtividadesRegiao (v_cursor OUT SYS_REFCURSOR)
IS BEGIN
	OPEN v_cursor FOR
		SELECT * FROM Regiao_Atividades  WHERE ID_ATIVIDADES = Atividades.ID_ATIVIDADES 
		AND ID_REGIAO = Regiao.ID_REGIAO;
END;
/
--Listar Nucleo por Regiao
CREATE OR REPLACE PROCEDURE listarNucleoRegiao (v_cursor OUT SYS_REFCURSOR)
IS BEGIN	
	OPEN v_cursor FOR
		SELECT * FROM Nucleo WHERE REGIAO = Regiao.ID_REGIAO;		
END;
/
--Listar Agrupamento por Núcleo
CREATE OR REPLACE PROCEDURE listarNucleoAgrupamento(v_cursor OUT SYS_REFCURSOR)
IS BEGIN	
	OPEN v_cursor FOR
		SELECT * FROM Agrupamento WHERE NUCLEO = Nucleo.ID_NUCLEO;		
END;
/
--Pesquisar Nome Núcleos por ID
CREATE OR REPLACE FUNCTION pesquisarNucleo(v_idN in NUMBER)
RETURN VARCHAR
IS
v_res VARCHAR(10);
BEGIN
	SELECT NOME_NUCLEO INTO v_res FROM Nucleo WHERE ID_NUCLEO = v_idN;
	RETURN v_res;
END;
/
--Pesquisar Nome Região por ID
CREATE OR REPLACE FUNCTION pesquisarRegiao(v_idR in NUMBER)
RETURN VARCHAR
IS
v_res VARCHAR(10);
BEGIN
	SELECT NOME_REGIAO INTO v_res FROM Regiao WHERE ID_REGIAO = v_idR;
	RETURN v_res;
END;
/
------------------------------------------FUNÇÕES PARA INSERIR DE TABELAS SUPLEMENTARES--------------------------------------------------------
--Insert na Tabela regiao_actividades
CREATE OR REPLACE FUNCTION regiao_actividades 
	(v_idAct in NUMBER, v_idReg in NUMBER)
RETURN NUMBER
IS
v_idA number(4);
v_idR NUMBER(4);
BEGIN
	SELECT ID_ATIVIDADES INTO v_idA FROM Atividades WHERE ID_ATIVIDADES = v_idAct;
	SELECT ID_REGIAO INTO v_idR FROM Regiao WHERE ID_REGIAO = v_idReg;
	INSERT INTO Regiao_Atividades(ID_ATIVIDADES, ID_REGIAO) VALUES(v_idA, v_idR);
	RETURN v_idA || v_idR;	
END;
/
--Insert na Tabela nucleo_actividades
CREATE OR REPLACE FUNCTION nucleo_actividades 
	(v_idAct in NUMBER, v_idNuc in NUMBER)
RETURN NUMBER
IS
v_idA number(4);
v_idN NUMBER(4);
BEGIN	
	SELECT ID_ATIVIDADES INTO v_idA FROM Atividades WHERE ID_ATIVIDADES = v_idAct;
	SELECT ID_NUCLEO INTO v_idN FROM Nucleo WHERE ID_NUCLEO = v_idNuc;
	INSERT INTO Nucleo_Atividades(ID_ATIVIDADES, ID_NUCLEO) VALUES(v_idA, v_idN);	
	RETURN v_idA || v_idN;		
END;
/
--Insert na Tabela agrupamento_actividades
CREATE OR REPLACE FUNCTION agrupamento_actividades 
	(v_idAct in NUMBER, v_idAgr in NUMBER)
RETURN NUMBER
IS
v_idA number(4);
v_idAg NUMBER(4);
BEGIN	
	SELECT ID_ATIVIDADES INTO v_idA FROM Atividades WHERE ID_ATIVIDADES = v_idAct;
	SELECT ID_AGRUPAMENTO INTO v_idAg FROM Agrupamento WHERE ID_AGRUPAMENTO = v_idAgr;
	INSERT INTO Agrupamento_Atividades(ID_ATIVIDADES, ID_AGRUPAMENTO) VALUES(v_idA, v_idAg);
	RETURN v_idA || v_idAg;		
END;
/
--Insert na Tabela seccao_actividades
CREATE OR REPLACE FUNCTION seccao_actividades 
	(v_idAct in NUMBER, v_idSec in NUMBER)
RETURN NUMBER
IS
v_idA NUMBER(4);
v_idS NUMBER(4);
BEGIN	
	SELECT ID_ATIVIDADES INTO v_idA FROM Atividades WHERE ID_ATIVIDADES = v_idAct;
	SELECT ID_SECCAO INTO v_idS FROM Seccao WHERE ID_SECCAO = v_idSec;
	
	INSERT INTO Seccao_Atividades(ID_ATIVIDADES, ID_SECCAO) VALUES(v_idA, v_idSec);
	
	RETURN v_idA || v_idSec;		
END;
/
