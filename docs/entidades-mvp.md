# Entidades do MVP — contrato de domínio Java / banco (v1)

## Status, finalidade e referência

Este documento orienta o início da modelagem do **entregável FIAP — Sprint 1**. Não altera a arquitetura do produto real Nexo.

- Direção acordada na conversa com o solicitante: `AreaAplicacao`, `AplicacaoNuclear`, `ImpactoSocial` e relação **N:N entre aplicação e impacto**.
- A associação `AplicacaoImpacto` foi validada com campos próprios (`explicacao`, `fonte_url`), chave primária composta `(aplicacao_id, impacto_id)` e restrições físicas acordadas entre Java e banco.
- Kenji foi indicado pelo solicitante para conduzir o trabalho de banco. Seu usuário GitHub e o revisor nominal ainda precisam ser confirmados; nenhuma atribuição automática foi realizada.
- Origem principal deste contrato de dados: `Nexo-Challenge/s1-database`, `docs/entidades-mvp.md`. A cópia em `s1-java-api` é o espelho v1 para leitura do backend. Mudanças exigem revisão conjunta e atualização explícita das referências/cópias, não sincronização automática.
- Consultar também `docs/requisitos-sprint-1.md` em cada repositório. O PDF original citado nos checklists não foi relido nesta atualização; esta proposta não certifica cumprimento integral nem altera os requisitos acadêmicos.

Repositórios: [Banco](https://github.com/Nexo-Challenge/s1-database) e [Java](https://github.com/Nexo-Challenge/s1-java-api).

## 1. O que cada entidade representa

| Entidade | Responsabilidade | Exemplo apenas ilustrativo |
| --- | --- | --- |
| `AreaAplicacao` | Categoria temática que organiza as aplicações. | Saúde; agricultura e alimentos. |
| `AplicacaoNuclear` | Uso concreto da tecnologia descrito em conteúdo educativo. Não se limita a projetos com nome próprio. É também o escopo principal escolhido para a Prova de Conceito (PoC) da disciplina de **.NET**. | Irradiação de alimentos; esterilização de materiais médicos. |
| `ImpactoSocial` | Benefício geral reutilizável entre aplicações, não um resultado quantitativo garantido. | Proteção da saúde; redução de perdas de alimentos. |
| `AplicacaoImpacto` | Associação entre uma aplicação e um impacto; explica a contribuição específica e aponta sua fonte por meio de atributos descritivos próprios. | Explicação de como a aplicação A se relaciona com o impacto X. |

Os exemplos servem para entender o modelo. Conteúdo real, números e alegações institucionais precisam de fontes verificadas antes de publicação; não reutilizar como fato as estimativas mencionadas informalmente na conversa.

## 2. Relacionamentos e cardinalidades propostos

```text
AreaAplicacao     1 ---- 0..N AplicacaoNuclear
AplicacaoNuclear  1 ---- 0..N AplicacaoImpacto
ImpactoSocial     1 ---- 0..N AplicacaoImpacto

AplicacaoNuclear N:N ImpactoSocial (resolvido por AplicacaoImpacto com chave composta)
```

- Cada aplicação tem **uma área principal**, como simplificação proposta para o MVP; confirmar com o grupo. Uma área pode existir sem aplicações.
- Uma aplicação pode ter vários impactos; um mesmo impacto pode estar associado a várias aplicações, sem duplicar seu cadastro.
- Cada associação aponta para exatamente uma aplicação e um impacto existentes.
- Mínimo zero de vínculos permite cadastro em preparação. Exigir ao menos um impacto antes da publicação é uma regra possível, ainda não aprovada; não criar status de publicação por suposição.
- Se o grupo precisar de várias áreas por aplicação, revisar o contrato antes de acrescentar outra associação.

Exemplo sintético de vínculos, sem representar dados científicos:

| Aplicação | Impacto |
| --- | --- |
| A | X |
| A | Y |
| B | X |

X tem um único cadastro e dois vínculos. A possui dois impactos. O par A/X não deve se repetir.

## 3. Dicionário inicial — validado e fechado

Os nomes de tabelas/colunas, tipos Oracle, tamanhos e restrições foram alinhados entre banco e Java para a implementação.

| Entidade / tabela sugerida | Atributos iniciais | Regras propostas |
| --- | --- | --- |
| `AreaAplicacao` / `TB_AREA_APLICACAO` | `id` (NUMBER, PK), `nome` (VARCHAR2(100), UNIQUE), `descricao` (VARCHAR2(1000)) | PK em `id`; nome obrigatório e exclusivo. Validação de maiúsculas/acentos a critério da aplicação. |
| `AplicacaoNuclear` / `TB_APLICACAO_NUCLEAR` | `id`, `areaAplicacaoId` (referência), `titulo`, `resumo`, `descricao` | PK em `id`; FK de área obrigatória; `titulo` (VARCHAR2(150)), `resumo` (VARCHAR2(500)), `descricao` (VARCHAR2(4000)). |
| `ImpactoSocial` / `TB_IMPACTO_SOCIAL` | `id`, `titulo`, `descricao` | PK em `id`; `titulo` (VARCHAR2(150), UNIQUE); `descricao` (VARCHAR2(1000)). |
| `AplicacaoImpacto` / `TB_APLICACAO_IMPACTO` | `aplicacaoId`, `impactoId`, `explicacao` (VARCHAR2(2000)), `fonteUrl` (VARCHAR2(500)) | FKs obrigatórias; par aplicação/impacto único. |

### Identidade e integridade da associação

- **Estratégia adotada:** Chave primária composta `(aplicacao_id, impacto_id)` na tabela `AplicacaoImpacto`: impede a repetição do vínculo diretamente; o Java fará o mapeamento correspondente da chave composta.
- Em ambos os casos, testar a impossibilidade de vínculo duplicado e de referências inexistentes.
- **Política de Exclusão:** Não usar exclusão em cascata. Política conservadora adotada: impedir excluir área, aplicação ou impacto enquanto houver referências ativas (`ON DELETE RESTRICT`), retornando erro na API. Sem soft delete ou cascatas.
- **Tipos Textuais:** Utilização padronizada de `VARCHAR2` (de 100 a 4000 caracteres) em vez de CLOB, garantindo performance e facilidade de mapeamento no ORM.

### O que fica fora do recorte inicial

Usuário/login, quiz, progresso, gamificação, indicadores numéricos, múltiplas fontes por vínculo, instituições como entidade, estágio de desenvolvimento e auditoria não entram automaticamente. Acrescentar somente mediante necessidade e aprovação. A descrição do impacto é genérica; explicação específica pertence ao vínculo, conforme o desenho aprovado.

## 4. Orientação para Java

- CRUD principal proposto: `AplicacaoNuclear`; busca por texto no título. DTOs, endpoints, códigos HTTP, paginação e contrato de erros ainda precisam de acordo; não estão implementados por este documento.
- A referência da aplicação para a área é N:1.
- Como `AplicacaoImpacto` possui explicação/fonte, é tratada como entidade associativa explícita com duas referências N:1, em vez de um N:N direto sem atributos.
- Não obrigar coleções bidirecionais nas entidades nem serializar entidades JPA diretamente como contrato da API. Definir DTOs separadamente.
- Confirmar como cadastrar/selecionar áreas e impactos para testar o CRUD. Não presumir CRUD completo para todas as entidades.
- Não gerar ou alterar tabelas automaticamente pelo Hibernate no Oracle compartilhado. Migrations, seeds e execução DDL/DML exigem autorização específica.

## 5. Roteiro de trabalho para Kenji — banco

Estas são tarefas de orientação, não issues criadas nem confirmação de trabalho em andamento. Kenji é o dono proposto da implementação de banco conforme indicação do solicitante; o revisor Java permanece a confirmar. Não há prazo definitivo confirmado.

| Tarefa | Área / dono principal | Dependência | Aceite observável |
| --- | --- | --- | --- |
| Validar o dicionário e as regras do vínculo | Banco / Kenji | Revisão Java; confirmar campos próprios, áreas e chave | Decisões registradas e aprovadas para PK composta, obrigatoriedade e exclusão restrita. |
| Desenhar o modelo lógico/físico e o DER/MER | Banco / Kenji | Dicionário validado | Modelo em 3FN, notação Barker conforme checklist, PK/FK e mínimos/máximos explícitos; N:N resolvido sem repetição do par. |
| Elaborar DDL Oracle versionado | Banco / Kenji | Modelo revisado | Script coerente com modelo; tipos/tamanhos/constraints e estratégia de IDs explícitos. Execução só em ambiente autorizado. |
| Elaborar dados e consultas de demonstração | Banco / Kenji | Modelo e DDL aprovados | Conforme checklist atual: pelo menos cinco registros coerentes por tabela e duas consultas JOIN; incluir A/X, A/Y e B/X para demonstrar N:N. |
| Registrar evidências de execução e empacotar | Banco / Kenji | Autorização de execução; testes reais | Registrar ambiente sem segredos e resultados reais; conferir PDF e SQL no ZIP exigido pelo checklist. |

Limites autorizados para a futura tarefa de banco, após acordo: `models/`, `sql/` e documentação do entregável em `s1-database`. Alteração Java, produto real, permissões e execução em banco compartilhado estão fora desse escopo. Não substituir arquivos/trabalho já em andamento sem combinar com o responsável.

Testes propostos para ambiente autorizado: aceitar vários impactos na mesma aplicação; compartilhar um impacto entre aplicações; rejeitar par repetido e FK inexistente; verificar campos obrigatórios e regra de exclusão aprovada. Consultas sugeridas: listar aplicações de uma área com seus impactos; listar aplicações associadas a um impacto.

## 6. Pendências para encerramento da Sprint

- [x] Kenji e a equipe validaram o desenho relacional e os atributos da tabela associativa.
- [ ] Conferir o PDF/portal oficial e o prazo definitivo. Os checklists atuais não substituem instruções atualizadas.

**Esta publicação é documental:** consolida as decisões tomadas pelo grupo sem automatizar execuções em banco compartilhado.
