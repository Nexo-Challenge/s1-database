# Scripts SQL — Sprint 1 (Banco de Dados Oracle)

## 1. Visão Geral
Esta pasta contém os scripts oficiais **DDL** e **DML** desenvolvidos para a implementação e povoamento do banco de dados relacional da Sprint 1 do Challenge Nexo (FIAP / AMAZUL / Marinha) em ambiente Oracle. O modelo atende integralmente à **3ª Forma Normal (3FN)** e utiliza notação padronizada.

---

## 2. Estrutura dos Arquivos

### 📄 `ddl.sql` (Estrutura e Restrições)
Responsável por estruturar o esquema do banco de dados de forma limpa e segura:
* **Limpeza Prévia:** Realiza o `DROP` de tabelas (em ordem inversa de dependência com `CASCADE CONSTRAINTS`) e sequences existentes para permitir reexecuções limpas.
* **Sequences:** Criação de geradores de IDs numéricos autoincrementáveis (`SEQ_AREA_APLICACAO`, `SEQ_APLICACAO_NUCLEAR`, `SEQ_IMPACTO_SOCIAL`).
* **Tabelas Principais e Associativa:**
  * `TB_AREA_APLICACAO`: Categoria temática das aplicações.
  * `TB_APLICACAO_NUCLEAR`: Entidade central que registra o uso prático da tecnologia nuclear.
  * `TB_IMPACTO_SOCIAL`: Benefícios gerais reutilizáveis gerados na sociedade.
  * `TB_APLICACAO_IMPACTO`: Tabela associativa (N:N) que resolve o relacionamento entre aplicações e impactos, contendo chave primária composta e atributos descritivos (`explicacao`, `fonte_url`).
* **Restrições (Constraints):**
  * Chaves Primárias (`PK`) e Estrangeiras (`FK`).
  * Política estrita de integridade referencial (`ON DELETE RESTRICT` nativa do Oracle).
  * Chaves Alternativas (`AK`/`UNIQUE`) nos campos textuais de identificação única (`nome` e `titulo`).

### 📄 `dml.sql` (Massa de Dados e Consultas)
Responsável por garantir a carga inicial de testes e demonstrar o funcionamento analítico do modelo:
* **Limpeza Segura (DELETEs):** Executa comandos de remoção prévia ordenados nas tabelas filhas e pai para evitar erros de chave estrangeira ao reexecutar o script.
* **Carga Inicial (Seeds):** Insere **5 registros consistentes por tabela**, contemplando cenários de múltiplos vínculos na tabela associativa (`N:N`).
* **Consultas de Validação (JOINs):**
  * *Consulta 1:* Lista todas as aplicações nucleares cruzadas com suas respectivas áreas temáticas e os impactos sociais associados.
  * *Consulta 2:* Agrupa os impactos sociais e contabiliza o total de aplicações vinculadas a cada um (utilizando `LEFT JOIN` e `GROUP BY` para exibir inclusive impactos sem vínculos ativos, retornando zero).

---

## 3. Ordem de Execução Recomendada
Para configurar e testar o ambiente corretamente em seu cliente Oracle (como o *Oracle SQL Developer*), execute os scripts na sequência abaixo:

1. **Passo 1:** Abra e execute o script **`ddl.sql`** para criar as sequences, tabelas e restrições.
2. **Passo 2:** Abra e execute o script **`dml.sql`** para limpar eventuais dados antigos, inserir a massa de teste e visualizar os resultados das consultas `JOIN`.
