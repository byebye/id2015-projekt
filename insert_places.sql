BEGIN;
--zamki
INSERT INTO miejsca(id,nazwa,typ) VALUES
	(1,'Orle Gniazdo',1),
	(2,'Kamienny Bęben',1),
	(3,'Smocza Skała',1),
	(4,'Harrenhal',1),
	(5,'Koniec Burzy',1),
	(6,'Winterfell',1),
	(7,'Casterly Rock',1),
	(8,'Czarny Zamek',1),
	(9,'Dreadfort',1),
	(10,'Czerwona Twierdza',1),
	(11,'Karhold',1),
	(12,'Fosa Cailin',1),
	(13,'Bliźniaki',1),
	(14,'Summerhal',1),
	(15,'Torrhens Square',1),
	(16,'Ashemark',1),
	(17,'Blackmont',1),
	(18,'Dębowa Tarcza',1),
	(19,'Ghaston Grey',1),
	(20,'Hornvale',1),
	(21,'Kamienne drzwi',1),
	(22,'Pinkmaiden',1),
	(23,'Riverrun',1),
	(24,'Sarsfield',1),
	(25,'Seagard',1),
	(26,'Sobolowy Dwór',1),
	(27,'Starfall',1),
	(28,'Staw Dziewic',1),
	(29,'Wschodnia Strażnica',1),
	(30,'Wysogród',1),
	(31,'Złoty Ząb',1)
;

--miasta
INSERT INTO miejsca(id,nazwa,typ) VALUES
	(32,'Braavos',2),
	(33,'Meereen',2),
	(34,'Asshai',2),
	(35,'Wolne Miasta',2),
	(36,'Stara Valyria',2),
	(37,'Astapor',2),
	(38,'Pentos',2),
	(39,'Vaes Dothrak',2),
	(40,'Lys',2),
	(41,'Lorath',2),
	(42,'Stare Miasto',2),
	(43,'Słoneczna Włócznia',2),
	(44,'Myr',2),
	(45,'Norvos',2),
	(46,'Tyrosh',2),
	(47,'Qohor',2),
	(48,'Lannisport',2),
	(49,'Stare Ghis',2),
	(50,'Biała Przystań',2),
	(51,'Nowe Ghis',2),
	(52,'Bayasabhad',2),
	(53,'Tolos',2),
	(54,'Mantarys',2),
	(55,'Elyria',2),
	(56,'Samyrian',2),
	(57,'Gulltown',2),
	(58,'Tyria',2),
	(59,'Oros',2),
	(60,'Chroyane',2),
	(61,'Bhorash',2),
	(62,'Ny Sar',2),
	(63,'Ar Noy',2),
	(64,'Saer Mell',2),
	(65,'Królewska Przystań',2)
;

--brakujace
INSERT INTO miejsca(id,nazwa,typ) VALUES
	(66,'Pyke',1);

--krainy
INSERT INTO miejsca(id,nazwa,typ) VALUES
	(67,'Dolina Arrynów',3),
	(68,'Dorne',3),
	(69,'Dorzecze',3),
	(70,'Krainy Burzy',3),
	(71,'Królestwo Zachodu',3),
	(72,'Reach',3),
	(73,'Włości Korony',3),
	(74,'Za murem',3),
	(75,'Żelazne wyspy',3),
	(76,'Północ',3),
	(77,'Essos',3)
;

--ziemie
INSERT INTO ziemie VALUES
	(1,'duży',NULL),
	(2,'duży',NULL),
	(3,'średni',NULL),
	(4,'mały',NULL),
	(5,'duży',NULL),
	(6,'średni',NULL),
	(7,'średni',NULL),
	(8,'duży',NULL),
	(9,'duży',NULL),
	(10,'duży',NULL)
;

INSERT INTO krainy_ziemie VALUES
--(1)Dolina arrynów,(2)Dorne,(3)Dorzecze,(4)Krainy Burzy,(5)Królestwo zachodu,(6)Reach,(7)Włości korony,(8)Za murem,(9)Żelazne wyspy,(10)Północ,(11)Essos,(12)Nocna Straż
	(1,69),(2,70),(3,70),(4,69),(5,70),(6,76),(7,71),(8,78),(9,76),(10,73),(11,76),(12,76),(13,69),(14,72),(15,76),(16,77),(17,68),(18,78),(19,68),
	(20,69),(21,67),(22,69),(23,69),(24,71),(25,69),(26,78),(27,68),(28,69),(29,78),(30,72),(31,71),(32,77),(33,77),(34,77),(35,77),(36,77),
	(37,77),(38,77),(39,77),(40,77),(41,77),(42,77),(43,68),(44,77),(45,77),(46,77),(47,77),(48,71),(49,77),(50,76),(51,77),(52,77),
	(53,77),(54,77),(55,77),(56,77),(57,77),(58,77),(59,77),(60,77),(61,77),(62,77),(63,77),(64,77),(65,73),(66,75)
;
