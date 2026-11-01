# Modelagem de Dados — Sprint 1 (Banco de Dados)

## 1. Visão Geral do Modelo e Notação
Este documento apresenta o Diagrama Entidade-Relacionamento (DER/MER) lógico e físico da Sprint 1 do Challenge Nexo (FIAP / AMAZUL / Marinha), estruturado em **3ª Forma Normal (3FN)** e utilizando a notação de **Barker** para representação de cardinalidades e opcionalidades.

O modelo é composto por **4 entidades principais** que resolvem a categorização temática, o registro de aplicações nucleares, os impactos sociais e a relação de muitos-para-muitos (N:N) entre elas por meio de uma tabela associativa.

---

## 2. Dicionário de Dados e Estrutura Física (Oracle)

Todas as chaves primárias numéricas utilizam a cláusula nativa `GENERATED ALWAYS AS IDENTITY`, alinhando a persistência no banco de dados com a estratégia `@GeneratedValue(strategy = GenerationType.IDENTITY)` das entidades nas APIs em Java (Spring Data JPA) e .NET.

### 2.1. `TB_AREA_APLICACAO`
Representa a categoria temática principal que organiza as aplicações nucleares.
* **`id`** (`NUMBER`, **PK**, `GENERATED ALWAYS AS IDENTITY`, `NOT NULL`): Identificador único da área.
* **`nome`** (`VARCHAR2(100)`, **AK/UNIQUE**, `NOT NULL`): Nome descritivo da categoria temática.
* **`descricao`** (`VARCHAR2(1000)`, `NULL`): Detalhamento opcional sobre a área de aplicação.

### 2.2. `TB_APLICACAO_NUCLEAR`
Representa o uso concreto da tecnologia nuclear (entidade central do CRUD e da PoC).
* **`id`** (`NUMBER`, **PK**, `GENERATED ALWAYS AS IDENTITY`, `NOT NULL`): Identificador único da aplicação.
* **`area_aplicacao_id`** (`NUMBER`, **FK**, `NOT NULL`): Chave estrangeira que referencia `TB_AREA_APLICACAO(id)`.
* **`titulo`** (`VARCHAR2(150)`, `NOT NULL`): Título da aplicação nuclear.
* **`resumo`** (`VARCHAR2(500)`, `NOT NULL`): Resumo conciso para listagens e cartões.
* **`descricao`** (`VARCHAR2(4000)`, `NOT NULL`): Conteúdo educativo detalhado sobre a aplicação.

### 2.3. `TB_IMPACTO_SOCIAL`
Representa os benefícios gerais e reutilizáveis gerados pelas aplicações na sociedade.
* **`id`** (`NUMBER`, **PK**, `GENERATED ALWAYS AS IDENTITY`, `NOT NULL`): Identificador único do impacto social.
* **`titulo`** (`VARCHAR2(150)`, **AK/UNIQUE**, `NOT NULL`): Título único do benefício social.
* **`descricao`** (`VARCHAR2(1000)`, `NULL`): Descrição opcional do impacto.

### 2.4. `TB_APLICACAO_IMPACTO` (Tabela Associativa N:N)
Resolve a relação de muitos-para-muitos entre `AplicacaoNuclear` e `ImpactoSocial`, armazenando metadados específicos do vínculo.
* **`aplicacao_id`** (`NUMBER`, **PK/FK**, `NOT NULL`): Referencia `TB_APLICACAO_NUCLEAR(id)`.
* **`impacto_id`** (`NUMBER`, **PK/FK**, `NOT NULL`): Referencia `TB_IMPACTO_SOCIAL(id)`.
* **`explicacao`** (`VARCHAR2(2000)`, `NOT NULL`): Descrição específica de como a aplicação gera o impacto.
* **`fonte_url`** (`VARCHAR2(500)`, `NULL`): URL opcional para a fonte verificável da informação.
* **Chave Primária Composta:** `PRIMARY KEY (aplicacao_id, impacto_id)`

---

## 3. Relacionamentos e Cardinalidades

* **`TB_AREA_APLICACAO` (1) ─── (0..N) `TB_APLICACAO_NUCLEAR`**
  * Uma área temática pode possuir várias aplicações nucleares associadas, mas cada aplicação pertence obrigatoriamente a uma única área principal (`1..1`).
* **`TB_APLICACAO_NUCLEAR` (1) ─── (0..N) `TB_APLICACAO_IMPACTO`**
  * Uma aplicação pode possuir múltiplos vínculos de impacto, permitindo cadastros em preparação (mínimo zero).
* **`TB_IMPACTO_SOCIAL` (1) ─── (0..N) `TB_APLICACAO_IMPACTO`**
  * Um impacto social reutilizável pode estar associado a várias aplicações diferentes por meio da tabela associativa.

---

## 4. Decisões de Integridade e Restrições
* **Geração Automática de IDs (`IDENTITY`):** Adoção de `GENERATED ALWAYS AS IDENTITY` para integração direta com frameworks ORM (JPA/Hibernate e Entity Framework), sem necessidade de gerenciar Sequences manualmente.
* **Chave Alternativa (AK):** Utilizada nos campos `nome` (AreaAplicacao) e `titulo` (ImpactoSocial) para garantir unicidade sem ocupar o papel da Chave Primária (PK).
* **Política de Exclusão Restrita (`ON DELETE RESTRICT`):** A exclusão de registros pai (`AreaAplicacao`, `AplicacaoNuclear`, `ImpactoSocial`) é rigidamente bloqueada se houver dependências ativas nas tabelas filhas ou associativas, preservando a consistência dos dados educacionais.
