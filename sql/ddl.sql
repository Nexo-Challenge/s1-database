-- ============================================================
-- SCRIPT DDL — SPRINT 1 (CHALLENGE NEXO / ORACLE)
-- Entidades: TB_AREA_APLICACAO, TB_APLICACAO_NUCLEAR, 
--            TB_IMPACTO_SOCIAL, TB_APLICACAO_IMPACTO
-- ============================================================

-- ------------------------------------------------------------
-- 1. DROPS (Limpeza de objetos em ordem inversa de dependência)
-- ------------------------------------------------------------
DROP TABLE TB_APLICACAO_IMPACTO CASCADE CONSTRAINTS;
DROP TABLE TB_APLICACAO_NUCLEAR CASCADE CONSTRAINTS;
DROP TABLE TB_IMPACTO_SOCIAL CASCADE CONSTRAINTS;
DROP TABLE TB_AREA_APLICACAO CASCADE CONSTRAINTS;

DROP SEQUENCE SEQ_AREA_APLICACAO;
DROP SEQUENCE SEQ_APLICACAO_NUCLEAR;
DROP SEQUENCE SEQ_IMPACTO_SOCIAL;

-- ------------------------------------------------------------
-- 2. SEQUENCES (Geração de IDs numéricos para as PKs)
-- ------------------------------------------------------------
CREATE SEQUENCE SEQ_AREA_APLICACAO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_APLICACAO_NUCLEAR START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_IMPACTO_SOCIAL START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ------------------------------------------------------------
-- 3. TABELA: TB_AREA_APLICACAO
-- ------------------------------------------------------------
CREATE TABLE TB_AREA_APLICACAO (
    id          NUMBER(10)          NOT NULL,
    nome        VARCHAR2(100)       NOT NULL,
    descricao   VARCHAR2(1000)      NULL,
    CONSTRAINT PK_AREA_APLICACAO PRIMARY KEY (id),
    CONSTRAINT UK_AREA_APLICACAO_NOME UNIQUE (nome)
);

-- ------------------------------------------------------------
-- 4. TABELA: TB_APLICACAO_NUCLEAR
-- ------------------------------------------------------------
CREATE TABLE TB_APLICACAO_NUCLEAR (
    id                NUMBER(10)      NOT NULL,
    area_aplicacao_id NUMBER(10)      NOT NULL,
    titulo            VARCHAR2(150)   NOT NULL,
    resumo            VARCHAR2(500)   NOT NULL,
    descricao         VARCHAR2(4000)  NOT NULL,
    CONSTRAINT PK_APLICACAO_NUCLEAR PRIMARY KEY (id),
    CONSTRAINT FK_APLICACAO_AREA FOREIGN KEY (area_aplicacao_id)
        REFERENCES TB_AREA_APLICACAO (id)
        -- Politica estrita: ON DELETE RESTRICT (padrao do Oracle sem ON DELETE CASCADE)
);

-- ------------------------------------------------------------
-- 5. TABELA: TB_IMPACTO_SOCIAL
-- ------------------------------------------------------------
CREATE TABLE TB_IMPACTO_SOCIAL (
    id          NUMBER(10)          NOT NULL,
    titulo      VARCHAR2(150)       NOT NULL,
    descricao   VARCHAR2(1000)      NULL,
    CONSTRAINT PK_IMPACTO_SOCIAL PRIMARY KEY (id),
    CONSTRAINT UK_IMPACTO_SOCIAL_TITULO UNIQUE (titulo)
);

-- ------------------------------------------------------------
-- 6. TABELA ASSOCIATIVA (N:N): TB_APLICACAO_IMPACTO
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