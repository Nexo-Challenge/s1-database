-- ============================================================
-- SCRIPT DML — SPRINT 1 (MASSA DE DADOS E CONSULTAS)
-- Inclui limpeza prévia (DELETEs) para reexecução segura
-- ============================================================

-- ------------------------------------------------------------
-- 0. LIMPEZA PRÉVIA (Ordem inversa de dependência)
-- ------------------------------------------------------------
DELETE FROM TB_APLICACAO_IMPACTO;
DELETE FROM TB_APLICACAO_NUCLEAR;
DELETE FROM TB_IMPACTO_SOCIAL;
DELETE FROM TB_AREA_APLICACAO;
COMMIT;

-- ------------------------------------------------------------
-- 1. INSERTS: TB_AREA_APLICACAO (5 Registros)
-- ------------------------------------------------------------
INSERT INTO TB_AREA_APLICACAO (id, nome, descricao) 
VALUES (SEQ_AREA_APLICACAO.NEXTVAL, 'Saúde e Medicina', 'Aplicações no diagnóstico, radioterapia e esterilização médica.');

INSERT INTO TB_AREA_APLICACAO (id, nome, descricao) 
VALUES (SEQ_AREA_APLICACAO.NEXTVAL, 'Agricultura e Alimentos', 'Técnicas de preservação de alimentos e controle de pragas.');

INSERT INTO TB_AREA_APLICACAO (id, nome, descricao) 
VALUES (SEQ_AREA_APLICACAO.NEXTVAL, 'Meio Ambiente e Rec. Hídricos', 'Monitoramento da poluição e gestão de aquíferos.');

INSERT INTO TB_AREA_APLICACAO (id, nome, descricao) 
VALUES (SEQ_AREA_APLICACAO.NEXTVAL, 'Indústria e Energia', 'Ensaios não destrutivos e geração de energia limpa.');

INSERT INTO TB_AREA_APLICACAO (id, nome, descricao) 
VALUES (SEQ_AREA_APLICACAO.NEXTVAL, 'Pesquisa e Propulsão', 'Desenvolvimento científico e tecnologias de propulsão.');

-- ------------------------------------------------------------
-- 2. INSERTS: TB_APLICACAO_NUCLEAR (5 Registros)
-- ------------------------------------------------------------
INSERT INTO TB_APLICACAO_NUCLEAR (id, area_aplicacao_id, titulo, resumo, descricao)
VALUES (SEQ_APLICACAO_NUCLEAR.NEXTVAL, 1, 'Esterilização de Insumos Médicos', 'Uso de radiação gama para esterilização de materiais cirúrgicos.', 'Garante a eliminação completa de microrganismos em materiais plásticos e seringas descartáveis sem uso de calor.');

INSERT INTO TB_APLICACAO_NUCLEAR (id, area_aplicacao_id, titulo, resumo, descricao)
VALUES (SEQ_APLICACAO_NUCLEAR.NEXTVAL, 1, 'Medicina Nuclear Diagnosticadora', 'Exames de imagem via PET-SCAN e cintilografia.', 'Permite a detecção precoce de tumores e avaliação metabólica detalhada do organismo humano.');

INSERT INTO TB_APLICACAO_NUCLEAR (id, area_aplicacao_id, titulo, resumo, descricao)
VALUES (SEQ_APLICACAO_NUCLEAR.NEXTVAL, 2, 'Irradiação de Alimentos', 'Aumento da vida útil e eliminação de pragas em grãos e frutas.', 'Processo físico de exposição controlada a raios gama que reduz perdas pós-colheita sem alterar valores nutricionais.');

INSERT INTO TB_APLICACAO_NUCLEAR (id, area_aplicacao_id, titulo, resumo, descricao)
VALUES (SEQ_APLICACAO_NUCLEAR.NEXTVAL, 3, 'Técnica de Isótopos em Aquíferos', 'Mapeamento da vazão e recarga de lençóis freáticos.', 'Permite rastrear a origem da água subterrânea e avaliar a sustentabilidade do uso hídrico regional.');

INSERT INTO TB_APLICACAO_NUCLEAR (id, area_aplicacao_id, titulo, resumo, descricao)
VALUES (SEQ_APLICACAO_NUCLEAR.NEXTVAL, 4, 'Gamagrafia Industrial', 'Inspeção de soldas e estruturas metálicas sem destruição.', 'Método radiográfico utilizado em tubulações e estruturas de grande porte para evitar vazamentos e falhas.');

-- ------------------------------------------------------------
-- 3. INSERTS: TB_IMPACTO_SOCIAL (5 Registros)
-- ------------------------------------------------------------
INSERT INTO TB_IMPACTO_SOCIAL (id, titulo, descricao)
VALUES (SEQ_IMPACTO_SOCIAL.NEXTVAL, 'Redução da Mortalidade por Infecções Hospitalares', 'Diminuição dos riscos de contaminação em procedimentos.');

INSERT INTO TB_IMPACTO_SOCIAL (id, titulo, descricao)
VALUES (SEQ_IMPACTO_SOCIAL.NEXTVAL, 'Segurança Alimentar e Combate ao Desperdício', 'Maximização do aproveitamento da produção agrícola.');

INSERT INTO TB_IMPACTO_SOCIAL (id, titulo, descricao)
VALUES (SEQ_IMPACTO_SOCIAL.NEXTVAL, 'Preservação de Recursos Hídricos', 'Proteção das fontes de água potável contra a superexploração.');

INSERT INTO TB_IMPACTO_SOCIAL (id, titulo, descricao)
VALUES (SEQ_IMPACTO_SOCIAL.NEXTVAL, 'Segurança em Infraestruturas Críticas', 'Prevenção de acidentes industriais e ambientais.');

INSERT INTO TB_IMPACTO_SOCIAL (id, titulo, descricao)
VALUES (SEQ_IMPACTO_SOCIAL.NEXTVAL, 'Diagnóstico Precoce de Doenças Crônicas', 'Aumento das chances de cura e tratamento assertivo.');

-- ------------------------------------------------------------
-- 4. INSERTS: TB_APLICACAO_IMPACTO (5 Registros — Demonstração N:N)
-- ------------------------------------------------------------
-- Aplicação 1 com Impacto 1 (A/X)
INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (1, 1, 'A esterilização gama assegura a biossegurança dos instrumentos cirúrgicos.', 'https://www.iaea.org/topics/health');

-- Aplicação 1 com Impacto 5 (A/Y)
INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (1, 5, 'Equipamentos esterilizados garantem a segurança de exames diagnósticos invasivos.', 'https://www.iaea.org/topics/health');

-- Aplicação 2 com Impacto 5 (B/X compartilhando o mesmo impacto)
INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (2, 5, 'Os radiofármacos viabilizam a identificação precoce de neoplasias no PET-Scan.', 'https://www.cnen.gov.br');

-- Aplicação 3 com Impacto 2
INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (3, 2, 'A irradiação estende a durabilidade dos alimentos sem necessidade de defensivos químicos.', 'https://www.fao.org');

-- Aplicação 4 com Impacto 3
INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (4, 3, 'O estudo isotópico orienta políticas públicas para evitar a contaminação de Aquíferos.', 'https://www.iaea.org/water');

COMMIT;

-- ------------------------------------------------------------
-- 5. CONSULTAS DE DEMONSTRAÇÃO (JOINs exigidos)
-- ------------------------------------------------------------

-- Consulta 1: Listar todas as Aplicações com suas respectivas Áreas e Impactos Sociais associados
SELECT 
    a.nome AS area_tematica,
    app.titulo AS aplicacao_nuclear,
    imp.titulo AS impacto_social,
    ai.explicacao AS contribuicao_especifica
FROM TB_APLICACAO_NUCLEAR app
JOIN TB_AREA_APLICACAO a ON app.area_aplicacao_id = a.id
LEFT JOIN TB_APLICACAO_IMPACTO ai ON app.id = ai.aplicacao_id
LEFT JOIN TB_IMPACTO_SOCIAL imp ON ai.impacto_id = imp.id
ORDER BY a.nome, app.titulo;

-- Consulta 2: Listar os Impactos Sociais e a quantidade de Aplicações que contribuem para eles
SELECT 
    imp.titulo AS impacto_social,
    COUNT(ai.aplicacao_id) AS total_aplicacoes_vinculadas
FROM TB_IMPACTO_SOCIAL imp
LEFT JOIN TB_APLICACAO_IMPACTO ai ON imp.id = ai.impacto_id
GROUP BY imp.titulo
ORDER BY total_aplicacoes_vinculadas DESC;