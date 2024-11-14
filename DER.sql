CREATE TABLE `Safras` (
  `id_safra` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ano_safra` int NOT NULL,
  `descricao_safra` varchar(100) NOT NULL
);

CREATE TABLE `Cultura` (
  `id_cultura` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `nome_cultura` varchar(100) NOT NULL
);

CREATE TABLE `Estado` (
  `id_estado` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `nome_estado` varchar(100) NOT NULL,
  `regiao` varchar(50)
);

CREATE TABLE `Produção` (
  `id_producao` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `area_plantada` decimal(10,2) NOT NULL,
  `producao_total` decimal(10,2) NOT NULL,
  `produtividade` decimal(10,2) NOT NULL,
  `id_safra` int NOT NULL,
  `id_cultura` int NOT NULL,
  `id_estado` int NOT NULL
);

CREATE TABLE `Clima` (
  `id_clima` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `chuvas_mm` decimal(5,2) NOT NULL,
  `temperatura_media` decimal(4,2) NOT NULL,
  `deficit_hidrico` decimal(4,2) NOT NULL,
  `id_safra` int NOT NULL,
  `id_estado` int NOT NULL
);

ALTER TABLE `Produção` ADD FOREIGN KEY (`id_safra`) REFERENCES `Safras` (`id_safra`);

ALTER TABLE `Produção` ADD FOREIGN KEY (`id_cultura`) REFERENCES `Cultura` (`id_cultura`);

ALTER TABLE `Produção` ADD FOREIGN KEY (`id_estado`) REFERENCES `Estado` (`id_estado`);

ALTER TABLE `Clima` ADD FOREIGN KEY (`id_safra`) REFERENCES `Safras` (`id_safra`);

ALTER TABLE `Clima` ADD FOREIGN KEY (`id_estado`) REFERENCES `Estado` (`id_estado`);
