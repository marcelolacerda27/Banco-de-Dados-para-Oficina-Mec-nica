# 🛠️ Desafio de Projeto: Banco de Dados para Oficina Mecânica

Este repositório contém a resolução do desafio de projeto de modelagem de banco de dados. O objetivo é criar um esquema conceitual, lógico e a implementação SQL para um sistema de controle e gerenciamento de ordens de serviço (OS) de uma oficina mecânica.

## 📋 Descrição do Desafio

A proposta é criar um esquema de banco de dados do zero, baseando-se na seguinte narrativa:
* Clientes levam veículos à oficina para conserto ou revisão.
* Cada veículo é designado a uma equipe de mecânicos.
* A OS (Ordem de Serviço) é gerada contendo os serviços a serem executados e data de entrega.
* O valor da OS é composto pelo valor da mão-de-obra (tabela de referência) + valor das peças.
* O cliente deve autorizar a execução.
* A mesma equipe avalia e executa os serviços.

## 📊 Modelo Conceitual (Diagrama ER)

Abaixo está o diagrama de Entidade-Relacionamento desenhado utilizando a sintaxe Mermaid.

```mermaid
erDiagram
    CLIENTE ||--|{ VEICULO : possui
    VEICULO ||--|{ ORDEM_SERVICO : gera
    ORDEM_SERVICO }|--|| EQUIPE : executada_por
    EQUIPE ||--|{ MECANICO : composta_por
    ORDEM_SERVICO }|--|{ SERVICO : contem
    ORDEM_SERVICO }|--|{ PECA : utiliza

    CLIENTE {
        int id_cliente PK
        string nome
        string cpf
        string contato
    }

    VEICULO {
        int id_veiculo PK
        string placa
        string modelo
        string marca
        int id_cliente FK
    }

    ORDEM_SERVICO {
        int id_os PK
        date data_emissao
        date data_conclusao
        float valor_total
        string status
        int id_veiculo FK
        int id_equipe FK
    }

    EQUIPE {
        int id_equipe PK
        string nome_equipe
    }

    MECANICO {
        int codigo PK
        string nome
        string endereco
        string especialidade
        int id_equipe FK
    }

    SERVICO {
        int id_servico PK
        string descricao
        float valor_mao_de_obra
    }

    PECA {
        int id_peca PK
        string descricao
        float valor_unitario
    }
