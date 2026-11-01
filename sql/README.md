# Scripts SQL — Sprint 1 (Banco de Dados Oracle)

## 1. Visão Geral
Esta pasta contém os scripts oficiais **DDL** e **DML** desenvolvidos para a implementação e povoamento do banco de dados relacional da Sprint 1 do Challenge Nexo (FIAP / AMAZUL / Marinha) em ambiente Oracle. O modelo atende integralmente à **3ª Forma Normal (3FN)** e foi projetado para integrar nativamente com o mapeamento objeto-relacional (JPA/Hibernate) das APIs em Java.

---

## 2. Estrutura dos Arquivos

### 📄 `ddl.sql` (Estrutura e Restrições)
Responsável por estruturar o esquema do banco de dados de forma limpa e otimizada:
* **Limpeza Prévia:** Realiza o `DROP` de tabelas em ordem inversa de dependência com a cláusula `CASCADE CONSTRAINTS` para permitir reexecuções limpas do script.
* **Geração Automática de IDs (IDENTITY):** As chaves primárias utilizam a estratégia nativa `GENERATED ALWAYS AS IDENTITY`, delegando o autoincremento ao banco e alinhando-se à anotação `@GeneratedValue(strategy = GenerationType.IDENTITY)` do Spring Boot.
* **Tabelas Principais e Associativa:**
  * `TB_AREA_APLICACAO`: Categoria temática das aplicações nucleares.
  * `TB_APLICACAO_NUCLEAR`: Entidade central que registra o uso prático e educacional da tecnologia nuclear.
  * `TB_IMPACTO_SOCIAL`: Benefícios gerais reutilizáveis gerados na sociedade.
  * `TB_APLICACAO_IMPACTO`: Tabela associativa (N:N) que resolve o relacionamento entre aplicações e impactos, contendo chave primária composta e atributos descritivos (`explicacao`, `fonte_url`).
* **Restrições (Constraints):**
  * Chaves Primárias (`PK`) e Estrangeiras (`FK`).
  * Política estrita de integridade referencial (`ON DELETE RESTRICT` nativa do Oracle).
  * Chaves Alternativas (`AK`/`UNIQUE`) nos campos textuais de identificação única (`nome` e `titulo`).

### 📄 `dml.sql` (Massa de Dados e Consultas)
Responsável por garantir a carga inicial de testes e demonstrar o funcionamento analítico do modelo:
* **Limpeza Segura (DELETEs):** Executa comandos de remoção prévia ordenados nas tabelas filhas e pai para evitar erros de restrição ao reexecutar o script.
* **Carga Inicial (Seeds):** Insere **5 registros consistentes por tabela** sem a necessidade de informar explicitamente os IDs (gerenciados pelo `IDENTITY`), contemplando múltiplos vínculos na tabela associativa (`N:N`).
* **Consultas de Validação (JOINs):**
  * *Consulta 1:* Lista todas as aplicações nucleares cruzadas com suas respectivas áreas temáticas e os impactos sociais associados.
  * *Consulta 2:* Agrupa os impactos sociais e contabiliza o total de aplicações vinculadas a cada um (utilizando `LEFT JOIN` e `GROUP BY` para exibir inclusive impactos sem vínculos ativos, retornando zero).

---

## 3. Ordem de Execução Recomendada
Para configurar e testar o ambiente corretamente em seu cliente Oracle (como o *Oracle SQL Developer*), execute os scripts na sequência abaixo:

1. **Passo 1:** Abra e execute o script **`ddl.sql`** para criar as tabelas, colunas `IDENTITY` e restrições.
2. **Passo 2:** Abra e execute o script **`dml.sql`** para limpar eventuais dados antigos, inserir a massa de teste e visualizar os resultados das consultas `JOIN`.
