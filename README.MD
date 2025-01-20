# Projeto ELT Pipeline com dbt, Snowflake e Airflow

Este projeto demonstra a criação de um pipeline de ELT (Extract, Load, Transform) usando dbt para transformação, Snowflake para data warehousing e Airflow para orquestração. O projeto utiliza um conjunto de dados público do Snowflake (TPCH) e abrange modelagem de dados, testes e implantação.

## Tecnologias Utilizadas
* `dbt (data build tool)`: Usado para transformação de dados, modelagem e testes. O dbt Core foi instalado usando pip.
* `Snowflake`: Utilizado como data warehouse para armazenar e consultar dados. Foi utilizada uma conta trial do `Snowflake`.
* `Airflow`: Utilizado para orquestração e agendamento do pipeline. O pacote astronomer-cosmos foi utilizado para integrar o dbt com `Airflow`.
* `SQL`: Usado para criar queries, views, tabelas e realizar testes.
* `YAML`: Usado para configurar o projeto dbt.
* Python: Usado para criar a DAG (Directed Acyclic Graph) do Airflow.


## Configuração do Ambiente
1. Configuração do `Snowflake`:
* Criação de Warehouse, Banco de Dados e Role: Foi criado um **warehouse** (**dbt_wh**), um banco de dados (**dbt_db**), e um role (**dbt_role**) no `Snowflake`. O role foi atribuído ao usuário e foram concedidas permissões para o warehouse e banco de dados.
* Criação de **Schema**: Foi criado um **schema** (**dbt_schema**) dentro do banco de dados para organizar as tabelas do dbt.

2. Configuração do `dbt`:
* Instalação do dbt Core: O dbt Core foi instalado usando:

    ```
    pip install dbt-core
    ```
* Inicialização do Projeto dbt: Foi inicializado um projeto dbt utilizando o comando dbt init, definindo o perfil do `snowflake`.
* Configuração do dbt_project.yaml: Foi configurado o arquivo dbt_project.yaml com informações sobre onde encontrar modelos, testes, seeds e macros.
* Configuração do profiles.yaml: Foi configurado o arquivo profiles.yaml com as credenciais do `Snowflake` e com o nome do warehouse e schema que foram criados no ambiente `Snowflake`.
* Configuração de Modelos: Os modelos foram organizados em pastas staging e marts. Os modelos em staging são materializados como views e os modelos em marts são materializados como tabelas.

3. Configuração de Fontes e **Staging**
* Definição de Fontes: As fontes de dados (tabelas orders e lineitem do conjunto de dados TPCH) foram definidas no arquivo tpch_sources.yml.
* Criação de Modelos de **Staging**: Foram criados modelos de **staging** para as tabelas orders e lineitem, renomeando colunas e gerando uma chave substituta para a tabela lineitem.

4. Criação de Macros
* Macro de Cálculo de Desconto: Foi criado um macro para calcular o valor do desconto, para reutilização em modelos.

5. Transformação de Dados e Modelagem (Data Marts)
* Criação de Tabelas Intermediárias: Foi criada uma tabela intermediária (int_order_items) combinando dados das tabelas orders e lineitem e aplicando o macro de desconto. Uma segunda tabela intermediária (int_order_items_summary) agrega dados da primeira.
* Criação da Tabela Fato: Foi criada uma tabela fato (fct_orders) que combina dados das tabelas orders e int_order_items_summary.

6. Testes
* Testes Genéricos: Foram criados testes genéricos no arquivo generic_tests.yml para validar a unicidade e a não nulidade da chave primária e relações de chave estrangeira e valores aceitos para a coluna status_code.
* Testes Singulares: Foram criados testes singulares para verificar se o valor do desconto é sempre maior que zero e se a data do pedido é válida.

7. Implantação com Airflow
* Instalação do Astronomer Cosmos: Foi instalado o pacote Astronomer Cosmos para integrar dbt com Airflow.

* Configuração do Dockerfile: Foi adicionada a instalação do dbt-snowflake no Dockerfile.

* Atualização do requirements.txt: Foi adicionado o astronomer-cosmos e o apache-airflow-providers-snowflake ao arquivo requirements.txt.

* Criação da DAG do Airflow: Foi criada uma DAG do Airflow utilizando o Cosmos para executar os comandos dbt.

* Configuração da Conexão Snowflake no Airflow: Foi criada uma conexão Snowflake no Airflow.

## Execução
Para executar o pipeline, siga os seguintes passos:

1. Configure o ambiente Snowflake conforme descrito acima.
2. Instale o dbt core e configure o projeto dbt.
3. Configure o Airflow e instale o pacote Astronomer Cosmos.
4. Crie a conexão Snowflake no Airflow.
5. Copie a pasta do projeto dbt para a pasta dags do Airflow.
6. Execute a DAG do Airflow.


## Resultados
Após a execução do pipeline, os dados transformados estarão disponíveis no Snowflake, na tabela fct_orders. A execução pode ser monitorada através da interface do `Airflow`.
