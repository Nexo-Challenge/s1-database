-- ============================================================
-- SCRIPT DDL — SPRINT 1 (CHALLENGE NEXO / ORACLE)
-- Uso de IDENTITY para integracao direta com Spring Data JPA
-- ============================================================

-- ------------------------------------------------------------
-- 1. DROPS (Limpeza de tabelas em ordem inversa de dependência)
-- ------------------------------------------------------------
DROP TABLE TB_APLICACAO_IMPACTO CASCADE CONSTRAINTS;
DROP TABLE TB_APLICACAO_NUCLEAR CASCADE CONSTRAINTS;
DROP TABLE TB_IMPACTO_SOCIAL CASCADE CONSTRAINTS;
DROP TABLE TB_AREA_APLICACAO CASCADE CONSTRAINTS;

-- ------------------------------------------------------------
-- 2. TABELA: TB_AREA_APLICACAO
-- ------------------------------------------------------------
CREATE TABLE TB_AREA_APLICACAO (
    id          NUMBER(10) GENERATED ALWAYS AS IDENTITY NOT NULL,
    nome        VARCHAR2(100)                           NOT NULL,
    descricao   VARCHAR2(1000)                          NULL,
    CONSTRAINT PK_AREA_APLICACAO PRIMARY KEY (id),
    CONSTRAINT UK_AREA_APLICACAO_NOME UNIQUE (nome)
);

-- ------------------------------------------------------------
-- 3. TABELA: TB_APLICACAO_NUCLEAR
-- ------------------------------------------------------------
CREATE TABLE TB_APLICACAO_NUCLEAR (
    id                NUMBER(10) GENERATED ALWAYS AS IDENTITY NOT NULL,
    area_aplicacao_id NUMBER(10)                              NOT NULL,
    titulo            VARCHAR2(150)                           NOT NULL,
    resumo            VARCHAR2(500)                           NOT NULL,
    descricao         VARCHAR2(4000)                          NOT NULL,
    CONSTRAINT PK_APLICACAO_NUCLEAR PRIMARY KEY (id),
    CONSTRAINT FK_APLICACAO_AREA FOREIGN KEY (area_aplicacao_id)
        REFERENCES TB_AREA_APLICACAO (id)
);

-- ------------------------------------------------------------
-- 4. TABELA: TB_IMPACTO_SOCIAL
-- ------------------------------------------------------------
CREATE TABLE TB_IMPACTO_SOCIAL (
    id          NUMBER(10) GENERATED ALWAYS AS IDENTITY NOT NULL,
    titulo      VARCHAR2(150)                           NOT NULL,
    descricao   VARCHAR2(1000)                          NULL,
    CONSTRAINT PK_IMPACTO_SOCIAL PRIMARY KEY (id),
    CONSTRAINT UK_IMPACTO_SOCIAL_TITULO UNIQUE (titulo)
);

-- ------------------------------------------------------------
-- 5. TABELA ASSOCIATIVA (N:N): TB_APLICACAO_IMPACTO
-- ------------------------------------------------------------
CREATE TABLE TB_APLICACAO_IMPACTO (
    aplicacao_id  NUMBER(10)        NOT NULL,
    impacto_id    NUMBER(10)        NOT NULL,
    explicacao    VARCHAR2(2000)    NOT NULL,
    fonte_url     VARCHAR2(500)     NULL,
    CONSTRAINT PK_APLICACAO_IMPACTO PRIMARY KEY (aplicacao_id, impacto_id),
    CONSTRAINT FK_VINCULO_APLICACAO FOREIGN KEY (aplicacao_id)
        REFERENCES TB_APLICACAO_NUCLEAR (id),
    CONSTRAINT FK_VINCULO_IMPACTO FOREIGN KEY (impacto_id)
        REFERENCES TB_IMPACTO_SOCIAL (id)
);
