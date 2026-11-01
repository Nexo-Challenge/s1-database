-- ============================================================
-- SCRIPT DML — SPRINT 1 (MASSA DE DADOS E CONSULTAS)
-- Inserts sem a coluna ID (geracao automatica por IDENTITY)
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
-- 1. INSERTS: TB_AREA_APLICACAO (IDs gerados automaticamente: 1 a 5)
-- ------------------------------------------------------------
INSERT INTO TB_AREA_APLICACAO (nome, descricao) 
VALUES ('Saúde e Medicina', 'Aplicações no diagnóstico, radioterapia e esterilização médica.');

INSERT INTO TB_AREA_APLICACAO (nome, descricao) 
VALUES ('Agricultura e Alimentos', 'Técnicas de preservação de alimentos e controle de pragas.');

INSERT INTO TB_AREA_APLICACAO (nome, descricao) 
VALUES ('Meio Ambiente e Rec. Hídricos', 'Monitoramento da poluição e gestão de aquíferos.');

INSERT INTO TB_AREA_APLICACAO (nome, descricao) 
VALUES ('Indústria e Energia', 'Ensaios não destrutivos e geração de energia limpa.');

INSERT INTO TB_AREA_APLICACAO (nome, descricao) 
VALUES ('Pesquisa e Propulsão', 'Desenvolvimento científico e tecnologias de propulsão.');

-- ------------------------------------------------------------
-- 2. INSERTS: TB_APLICACAO_NUCLEAR (IDs gerados automaticamente: 1 a 5)
-- ------------------------------------------------------------
INSERT INTO TB_APLICACAO_NUCLEAR (area_aplicacao_id, titulo, resumo, descricao)
VALUES (1, 'Esterilização de Insumos Médicos', 'Uso de radiação gama para esterilização de materiais cirúrgicos.', 'Garante a eliminação completa de microrganismos em materiais plásticos sem uso de calor.');

INSERT INTO TB_APLICACAO_NUCLEAR (area_aplicacao_id, titulo, resumo, descricao)
VALUES (1, 'Medicina Nuclear Diagnosticadora', 'Exames de imagem via PET-SCAN e cintilografia.', 'Permite a detecção precoce de tumores e avaliação metabólica detalhada do organismo.');

INSERT INTO TB_APLICACAO_NUCLEAR (area_aplicacao_id, titulo, resumo, descricao)
VALUES (2, 'Irradiação de Alimentos', 'Aumento da vida útil e eliminação de pragas em grãos e frutas.', 'Processo físico de exposição controlada a raios gama que reduz perdas pós-colheita.');

INSERT INTO TB_APLICACAO_NUCLEAR (area_aplicacao_id, titulo, resumo, descricao)
VALUES (3, 'Técnica de Isótopos em Aquíferos', 'Mapeamento da vazão e recarga de lençóis freáticos.', 'Permite rastrear a origem da água subterrânea e avaliar a sustentabilidade hídrica.');

INSERT INTO TB_APLICACAO_NUCLEAR (area_aplicacao_id, titulo, resumo, descricao)
VALUES (4, 'Gamagrafia Industrial', 'Inspeção de soldas e estruturas metálicas sem destruição.', 'Método radiográfico utilizado em tubulações para evitar vazamentos e falhas.');

-- ------------------------------------------------------------
-- 3. INSERTS: TB_IMPACTO_SOCIAL (IDs gerados automaticamente: 1 a 5)
-- ------------------------------------------------------------
INSERT INTO TB_IMPACTO_SOCIAL (titulo, descricao)
VALUES ('Redução da Mortalidade por Infecções Hospitalares', 'Diminuição dos riscos de contaminação em procedimentos.');

INSERT INTO TB_IMPACTO_SOCIAL (titulo, descricao)
VALUES ('Segurança Alimentar e Combate ao Desperdício', 'Maximização do aproveitamento da produção agrícola.');

INSERT INTO TB_IMPACTO_SOCIAL (titulo, descricao)
VALUES ('Preservação de Recursos Hídricos', 'Proteção das fontes de água potável contra a superexploração.');

INSERT INTO TB_IMPACTO_SOCIAL (titulo, descricao)
VALUES ('Segurança em Infraestruturas Críticas', 'Prevenção de acidentes industriais e ambientais.');

INSERT INTO TB_IMPACTO_SOCIAL (titulo, descricao)
VALUES ('Diagnóstico Precoce de Doenças Crônicas', 'Aumento das chances de cura e tratamento assertivo.');

-- ------------------------------------------------------------
-- 4. INSERTS: TB_APLICACAO_IMPACTO (Demonstração N:N)
-- ------------------------------------------------------------
INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (1, 1, 'A esterilização gama assegura a biossegurança dos instrumentos cirúrgicos.', 'https://www.iaea.org/topics/health');

INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (1, 5, 'Equipamentos esterilizados garantem a segurança de exames diagnósticos invasivos.', 'https://www.iaea.org/topics/health');

INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (2, 5, 'Os radiofármacos viabilizam a identificação precoce de neoplasias no PET-Scan.', 'https://www.cnen.gov.br');

INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (3, 2, 'A irradiação estende a durabilidade dos alimentos sem necessidade de defensivos químicos.', 'https://www.fao.org');

INSERT INTO TB_APLICACAO_IMPACTO (aplicacao_id, impacto_id, explicacao, fonte_url)
VALUES (4, 3, 'O estudo isotópico orienta políticas públicas para evitar a contaminação de Aquíferos.', 'https://www.iaea.org/water');

COMMIT;

-- ------------------------------------------------------------
-- 5. CONSULTAS DE DEMONSTRAÇÃO (JOINs)
-- ------------------------------------------------------------
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

SELECT 
    imp.titulo AS impacto_social,
    COUNT(ai.aplicacao_id) AS total_aplicacoes_vinculadas
FROM TB_IMPACTO_SOCIAL imp
LEFT JOIN TB_APLICACAO_IMPACTO ai ON imp.id = ai.impacto_id
GROUP BY imp.titulo
ORDER BY total_aplicacoes_vinculadas DESC;
