-- ============================================================
-- PROJETO: SISTEMA DE OFICINA MECÂNICA
-- DESCRIÇÃO: Script de criação, inserção de dados e queries para o desafio de projeto.
-- AUTOR: Marcelo Lacerda
-- ============================================================

-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ============================================================
DROP DATABASE IF EXISTS oficina_mecanica;
CREATE DATABASE oficina_mecanica;
USE oficina_mecanica;

-- 2. CRIAÇÃO DAS TABELAS (DDL)
-- ============================================================

-- Tabela Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    CPF CHAR(11) NOT NULL UNIQUE,
    Contato VARCHAR(45),
    Endereco VARCHAR(255)
);

-- Tabela Equipe (Mecânicos são alocados em equipes)
CREATE TABLE Equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    NomeEquipe VARCHAR(45) NOT NULL
);

-- Tabela Mecânico
CREATE TABLE Mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Endereco VARCHAR(255),
    Especialidade VARCHAR(45) NOT NULL,
    idEquipe INT,
    CONSTRAINT fk_mecanico_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

-- Tabela Veículo
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    Placa CHAR(7) NOT NULL UNIQUE,
    Modelo VARCHAR(45) NOT NULL,
    Marca VARCHAR(45) NOT NULL,
    idCliente INT,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Tabela de Referência: Serviços (Mão de Obra)
CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45) NOT NULL,
    ValorMaoDeObra FLOAT NOT NULL
);

-- Tabela de Referência: Peças
CREATE TABLE Peca (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(45) NOT NULL,
    ValorUnitario FLOAT NOT NULL
);

-- Tabela Ordem de Serviço (OS)
CREATE TABLE OrdemServico (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    DataEmissao DATE DEFAULT (CURRENT_DATE),
    DataConclusao DATE,
    Status ENUM('Em Análise', 'Aguardando Aprovação', 'Em Execução', 'Finalizado', 'Cancelado') DEFAULT 'Em Análise',
    ValorTotal FLOAT DEFAULT 0,
    idVeiculo INT,
    idEquipe INT,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo),
    CONSTRAINT fk_os_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

-- Tabela Associativa: OS contém Serviços (N:N)
CREATE TABLE OS_Servico (
    idOS INT,
    idServico INT,
    Quantidade INT DEFAULT 1,
    PRIMARY KEY (idOS, idServico),
    CONSTRAINT fk_os_servico_os FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_os_servico_servico FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);

-- Tabela Associativa: OS contém Peças (N:N)
CREATE TABLE OS_Peca (
    idOS INT,
    idPeca INT,
    Quantidade INT DEFAULT 1,
    PRIMARY KEY (idOS, idPeca),
    CONSTRAINT fk_os_peca_os FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_os_peca_peca FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
);


-- 3. INSERÇÃO DE DADOS (DML - PERSISTÊNCIA)
-- ============================================================

-- Clientes
INSERT INTO Cliente (Nome, CPF, Contato, Endereco) VALUES
('Carlos Silva', '12345678901', '(11) 99999-9999', 'Rua das Flores, 123'),
('Ana Pereira', '98765432100', '(21) 88888-8888', 'Av. Principal, 500'),
('Roberto Souza', '45678912300', '(31) 77777-7777', 'Rua do Mercado, 10');

-- Equipes
INSERT INTO Equipe (NomeEquipe) VALUES
('Equipe Alpha (Motor)'),
('Equipe Beta (Suspensão/Freios)'),
('Equipe Gamma (Elétrica)');

-- Mecânicos
INSERT INTO Mecanico (Nome, Endereco, Especialidade, idEquipe) VALUES
('João Mecânico', 'Rua 1', 'Motor', 1),
('Pedro Ajudante', 'Rua 2', 'Geral', 1),
('Maria Elétrica', 'Rua 3', 'Elétrica', 3),
('José Suspensão', 'Rua 4', 'Suspensão', 2);

-- Veículos
INSERT INTO Veiculo (Placa, Modelo, Marca, idCliente) VALUES
('ABC1234', 'Fiesta', 'Ford', 1),
('XYZ9876', 'Civic', 'Honda', 2),
('DEF5678', 'Gol', 'VW', 3);

-- Serviços (Tabela de Preços)
INSERT INTO Servico (Descricao, ValorMaoDeObra) VALUES
('Troca de Óleo', 80.00),
('Alinhamento e Balanceamento', 120.00),
('Revisão Elétrica', 200.00),
('Troca de Pastilha de Freio', 100.00);

-- Peças (Estoque)
INSERT INTO Peca (Descricao, ValorUnitario) VALUES
('Óleo 5W30 (Litro)', 40.00),
('Filtro de Óleo', 25.00),
('Pastilha de Freio (Par)', 150.00),
('Bateria 60Ah', 450.00);

-- Ordens de Serviço
-- OS 1: Carlos (Fiesta) -> Troca de Óleo
INSERT INTO OrdemServico (idVeiculo, idEquipe, Status, DataEmissao) VALUES (1, 1, 'Finalizado', '2023-10-01');
-- OS 2: Ana (Civic) -> Elétrica
INSERT INTO OrdemServico (idVeiculo, idEquipe, Status, DataEmissao) VALUES (2, 3, 'Em Execução', '2023-10-05');
-- OS 3: Roberto (Gol) -> Freios
INSERT INTO OrdemServico (idVeiculo, idEquipe, Status, DataEmissao) VALUES (3, 2, 'Em Análise', '2023-10-10');

-- Vinculando Itens às OS
-- OS 1 (Troca de Óleo): 1 Serviço de troca + 4L de óleo + 1 Filtro
INSERT INTO OS_Servico (idOS, idServico, Quantidade) VALUES (1, 1, 1);
INSERT INTO OS_Peca (idOS, idPeca, Quantidade) VALUES (1, 1, 4), (1, 2, 1);

-- OS 2 (Elétrica): 1 Revisão Elétrica + 1 Bateria
INSERT INTO OS_Servico (idOS, idServico, Quantidade) VALUES (2, 3, 1);
INSERT INTO OS_Peca (idOS, idPeca, Quantidade) VALUES (2, 4, 1);

-- OS 3 (Freios): 1 Troca de pastilha + 1 Par de pastilhas
INSERT INTO OS_Servico (idOS, idServico, Quantidade) VALUES (3, 4, 1);
INSERT INTO OS_Peca (idOS, idPeca, Quantidade) VALUES (3, 3, 1);


-- 4. QUERIES (CONSULTAS SQL PARA O DESAFIO)
-- ============================================================

-- A) Recuperações simples com SELECT *
SELECT * FROM Cliente;
SELECT * FROM Veiculo;

-- B) Filtros com WHERE
-- Listar todas as OS que não estão finalizadas
SELECT * FROM OrdemServico WHERE Status != 'Finalizado';

-- C) Atributos Derivados (Cálculo do Valor Total da OS 1)
-- Somando Mão de Obra + Peças
SELECT 
    OS.idOS,
    (SELECT SUM(S.ValorMaoDeObra * OSS.Quantidade) 
     FROM OS_Servico OSS JOIN Servico S ON OSS.idServico = S.idServico 
     WHERE OSS.idOS = OS.idOS) AS Total_Servicos,
    (SELECT SUM(P.ValorUnitario * OSP.Quantidade) 
     FROM OS_Peca OSP JOIN Peca P ON OSP.idPeca = P.idPeca 
     WHERE OSP.idOS = OS.idOS) AS Total_Pecas
FROM OrdemServico OS
WHERE OS.idOS = 1;

-- D) Ordenação dos dados com ORDER BY
-- Listar veículos por modelo em ordem alfabética
SELECT Modelo, Placa, Marca FROM Veiculo ORDER BY Modelo ASC;

-- E) Condições de filtros aos grupos – HAVING
-- Listar peças que foram usadas mais de 3 vezes no total de todas as OS
SELECT P.Descricao, SUM(OSP.Quantidade) as Total_Usado
FROM Peca P
JOIN OS_Peca OSP ON P.idPeca = OSP.idPeca
GROUP BY P.Descricao
HAVING Total_Usado > 3;

-- F) Junções entre tabelas para fornecer uma perspectiva mais complexa
-- Relatório: Cliente, Veículo, Equipe responsável e Status da OS
SELECT 
    C.Nome AS Cliente,
    V.Modelo AS Veiculo,
    V.Placa,
    E.NomeEquipe,
    OS.Status,
    OS.DataEmissao
FROM OrdemServico OS
INNER JOIN Veiculo V ON OS.idVeiculo = V.idVeiculo
INNER JOIN Cliente C ON V.idCliente = C.idCliente
INNER JOIN Equipe E ON OS.idEquipe = E.idEquipe;

-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
