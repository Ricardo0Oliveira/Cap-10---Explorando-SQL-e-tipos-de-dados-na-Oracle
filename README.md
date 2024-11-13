# Modelo de Banco de Dados para Monitoramento de Produção Agrícola

## 1. Introdução

Este documento descreve o modelo de banco de dados utilizado para o monitoramento da produção agrícola no Brasil. O objetivo é armazenar, organizar e permitir a análise de dados sobre produção agrícola, incluindo informações sobre safras, culturas, área plantada, produtividade, produção total e condições climáticas, com base em dados fornecidos por órgãos como CONAB, IBGE, MAPA, Embrapa e INPE.

### Objetivo do Banco de Dados
- Armazenar e organizar dados sobre produção agrícola de diferentes culturas em cada estado e safra.
- Facilitar a análise de produtividade, área plantada e condições climáticas associadas a cada safra.
- Permitir consultas avançadas para análise histórica de produção, desempenho regional e influência de variáveis climáticas.

## 2. Descrição das Entidades e Relacionamentos

### 2.1 Entidades e Atributos

#### Safras
Representa os períodos de colheita, categorizados por ano e com uma descrição opcional.
   - **id_safra**: INT, PRIMARY KEY, AUTO_INCREMENT, NOT NULL
   - **ano_safra**: INT, NOT NULL
   - **descricao_safra**: VARCHAR(100), NOT NULL

#### Cultura
Armazena os diferentes tipos de culturas agrícolas (ex: milho, soja, trigo).
   - **id_cultura**: INT, PRIMARY KEY, AUTO_INCREMENT, NOT NULL
   - **nome_cultura**: VARCHAR(100), NOT NULL

#### Estado
Identifica os estados onde a produção ocorre.
   - **id_estado**: INT, PRIMARY KEY, AUTO_INCREMENT, NOT NULL
   - **nome_estado**: VARCHAR(100), NOT NULL
   - **regiao**: VARCHAR(50), NULL (campo opcional para agrupar estados por regiões)

#### Produção
Registra os dados específicos de produção de uma cultura em um estado e safra específicos, incluindo área plantada e produtividade.
   - **id_producao**: INT, PRIMARY KEY, AUTO_INCREMENT, NOT NULL
   - **area_plantada**: DECIMAL(10,2), NOT NULL
   - **producao_total**: DECIMAL(10,2), NOT NULL
   - **produtividade**: DECIMAL(10,2), NOT NULL
   - **id_safra**: INT, NOT NULL, FOREIGN KEY referencing Safras(id_safra)
   - **id_cultura**: INT, NOT NULL, FOREIGN KEY referencing Cultura(id_cultura)
   - **id_estado**: INT, NOT NULL, FOREIGN KEY referencing Estado(id_estado)

#### Clima
Armazena os dados climáticos relacionados a uma safra específica em um estado, como precipitação e temperatura média.
   - **id_clima**: INT, PRIMARY KEY, AUTO_INCREMENT, NOT NULL
   - **chuvas_mm**: DECIMAL(5,2), NOT NULL
   - **temperatura_media**: DECIMAL(4,2), NOT NULL
   - **deficit_hidrico**: DECIMAL(4,2), NOT NULL
   - **id_safra**: INT, NOT NULL, FOREIGN KEY referencing Safras(id_safra)
   - **id_estado**: INT, NOT NULL, FOREIGN KEY referencing Estado(id_estado)

### 2.2 Relacionamentos

- **Safra → Produção**: Uma safra pode ter várias produções de culturas em diferentes estados (1:N entre Safra e Produção).
- **Cultura → Produção**: Uma cultura pode estar associada a várias produções (1:N entre Cultura e Produção).
- **Estado → Produção**: Um estado pode registrar várias produções para diferentes culturas e safras (1:N entre Estado e Produção).
- **Estado/Safra → Clima**: O clima em um estado é registrado por safra e por estado (1:N entre Estado/Safra e Clima).

## 3. Código SQL para Criação das Tabelas

```sql
-- Tabela Safras
CREATE TABLE Safras (
    id_safra INT PRIMARY KEY AUTO_INCREMENT,
    ano_safra INT NOT NULL,
    descricao_safra VARCHAR(100) NOT NULL
);

-- Tabela Cultura
CREATE TABLE Cultura (
    id_cultura INT PRIMARY KEY AUTO_INCREMENT,
    nome_cultura VARCHAR(100) NOT NULL
);

-- Tabela Estado
CREATE TABLE Estado (
    id_estado INT PRIMARY KEY AUTO_INCREMENT,
    nome_estado VARCHAR(100) NOT NULL,
    regiao VARCHAR(50)
);

-- Tabela Produção
CREATE TABLE Producao (
    id_producao INT PRIMARY KEY AUTO_INCREMENT,
    area_plantada DECIMAL(10,2) NOT NULL,
    producao_total DECIMAL(10,2) NOT NULL,
    produtividade DECIMAL(10,2) NOT NULL,
    id_safra INT NOT NULL,
    id_cultura INT NOT NULL,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_safra) REFERENCES Safras(id_safra),
    FOREIGN KEY (id_cultura) REFERENCES Cultura(id_cultura),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado)
);

-- Tabela Clima
CREATE TABLE Clima (
    id_clima INT PRIMARY KEY AUTO_INCREMENT,
    chuvas_mm DECIMAL(5,2) NOT NULL,
    temperatura_media DECIMAL(4,2) NOT NULL,
    deficit_hidrico DECIMAL(4,2) NOT NULL,
    id_safra INT NOT NULL,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_safra) REFERENCES Safras(id_safra),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado)
);
```

## 4. Consultas SQL Relevantes para Análise de Dados

### 4.1 Produção total de uma determinada cultura por estado em uma safra específica

```sql
SELECT e.nome_estado, SUM(p.producao_total) AS producao_total
FROM Producao p
JOIN Estado e ON p.id_estado = e.id_estado
JOIN Cultura c ON p.id_cultura = c.id_cultura
JOIN Safras s ON p.id_safra = s.id_safra
WHERE c.nome_cultura = 'Soja' 
  AND s.ano_safra = 2024       
GROUP BY e.nome_estado;
```

### 4.2 Evolução da área plantada de uma cultura ao longo dos anos

```sql
SELECT s.ano_safra, SUM(p.area_plantada) AS area_total
FROM Producao p
JOIN Safras s ON p.id_safra = s.id_safra
JOIN Cultura c ON p.id_cultura = c.id_cultura
WHERE c.nome_cultura = 'Milho'  -- Substitua 'Milho' pelo nome da cultura desejada
GROUP BY s.ano_safra
ORDER BY s.ano_safra;
```

### 4.3 Ranking dos estados com maior produtividade em uma cultura específica

```sql
SELECT e.nome_estado, AVG(p.produtividade) AS produtividade_media
FROM Producao p
JOIN Estado e ON p.id_estado = e.id_estado
JOIN Cultura c ON p.id_cultura = c.id_cultura
WHERE c.nome_cultura = 'Trigo'  -- Substitua 'Trigo' pelo nome da cultura desejada
GROUP BY e.nome_estado
ORDER BY produtividade_media DESC;
```

## 5. Dicionário de Dados

| Tabela      | Campo             | Tipo         | Descrição                                     |
|-------------|--------------------|--------------|----------------------------------------------|
| **Safras**  | id_safra           | INT          | Identificador da safra                       |
|             | ano_safra          | INT          | Ano da safra                                 |
|             | descricao_safra    | VARCHAR(100) | Descrição adicional da safra                 |
| **Cultura** | id_cultura         | INT          | Identificador da cultura agrícola            |
|             | nome_cultura       | VARCHAR(100) | Nome da cultura (ex: soja, milho)            |
| **Estado**  | id_estado          | INT          | Identificador do estado                      |
|             | nome_estado        | VARCHAR(100) | Nome do estado                               |
|             | regiao             | VARCHAR(50)  | Região geográfica opcional                   |
| **Produção**| id_producao        | INT          | Identificador da produção                    |
|             | area_plantada      | DECIMAL(10,2)| Área plantada em hectares                    |
|             | producao_total     | DECIMAL(10,2)| Produção total em toneladas                  |
|             | produtividade      | DECIMAL(10,2)| Produção média por hectare                   |
|             | id_safra           | INT          | Referência da safra                          |
|             | id_cultura         | INT          | Referência da cultura                        |
|             | id_estado          | INT          | Referência do estado                         |
| **Clima**   | id_clima           | INT          | Identificador dos dados

 climáticos           |
|             | chuvas_mm          | DECIMAL(5,2) | Precipitação em milímetros                   |
|             | temperatura_media  | DECIMAL(4,2) | Temperatura média em graus Celsius           |
|             | deficit_hidrico    | DECIMAL(4,2) | Déficit hídrico em milímetros                |
|             | id_safra           | INT          | Referência da safra                          |
|             | id_estado          | INT          | Referência do estado                         |

