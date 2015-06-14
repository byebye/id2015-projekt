BEGIN;
--zamki
INSERT INTO miejsca(id,nazwa,typ,wielkosc) VALUES
	(1,'Orle Gniazdo',1,'mały'),
	(2,'Kamienny Bęben',1,'średni'),
	(3,'Smocza Skała',1,'średni'),
	(4,'Harrenhal',1,'duży'),
	(5,'Koniec Burzy',1,'średni'),
	(6,'Winterfell',1,'duży'),
	(7,'Casterly Rock',1,'duży'),
	(8,'Czarny Zamek',1,'mały'),
	(9,'Dreadfort',1,'mały'),
	(10,'Czerwona Twierdza',1,'duży'),
	(11,'Karhold',1,'średni'),
	(12,'Fosa Cailin',1,'mały'),
	(13,'Bliźniaki',1,'duży'),
	(14,'Summerhal',1,'średni'),
	(15,'Torrhens Square',1,'mały'),
	(16,'Ashemark',1,'mały'),
	(17,'Blackmont',1,'duży'),
	(18,'Dębowa Tarcza',1,'średni'),
	(19,'Ghaston Grey',1,'duży'),
	(20,'Hornvale',1,'mały'),
	(21,'Kamienne drzwi',1,'mały'),
	(22,'Pinkmaiden',1,'średni'),
	(23,'Riverrun',1,'duży'),
	(24,'Sarsfield',1,'mały'),
	(25,'Seagard',1,'średni'),
	(26,'Sobolowy Dwór',1,'duży'),
	(27,'Starfall',1,'średni'),
	(28,'Staw Dziewic',1,'mały'),
	(29,'Wschodnia Strażnica',1,'duży'),
	(30,'Wysogród',1,'duży'),
	(31,'Złoty Ząb',1,'mały')
;

--miasta
INSERT INTO miejsca(id,nazwa,typ,wielkosc) VALUES
	(32,'Braavos',2,'mały'),
	(33,'Meereen',2,'duży'),
	(34,'Asshai',2,'średni'),
	(35,'Wolne Miasta',2,'mały'),
	(36,'Stara Valyria',2,'duży'),
	(37,'Astapor',2,'średni'),
	(38,'Pentos',2,'duży'),
	(39,'Vaes Dothrak',2,'mały'),
	(40,'Lys',2,'duży'),
	(41,'Lorath',2,'średni'),
	(42,'Stare Miasto',2,'mały'),
	(43,'Słoneczna Włócznia',2,'mały'),
	(44,'Myr',2,'duży'),
	(45,'Norvos',2,'średni'),
	(46,'Tyrosh',2,'duży'),
	(47,'Qohor',2,'średni'),
	(48,'Lannisport',2,'mały'),
	(49,'Stare Ghis',2,'duży'),
	(50,'Biała Przystań',2,'mały'),
	(51,'Nowe Ghis',2,'duży'),
	(52,'Bayasabhad',2,'średni'),
	(53,'Tolos',2,'średni'),
	(54,'Mantarys',2,'mały'),
	(55,'Elyria',2,'duży'),
	(56,'Samyrian',2,'średni'),
	(57,'Gulltown',2,'mały'),
	(58,'Tyria',2,'duży'),
	(59,'Oros',2,'mały'),
	(60,'Chroyane',2,'mały'),
	(61,'Bhorash',2,'duży'),
	(62,'Ny Sar',2,'średni'),
	(63,'Ar Noy',2,'średni'),
	(64,'Saer Mell',2,'mały'),
	(65,'Królewska Przystań',2,'duży')
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
	(75,'Żelazne wyspy',3),
	(76,'Północ',3),
	(77,'Essos',3),
	(78,'Nocna Straż',3)
;

INSERT INTO miejsca_krainy VALUES
	(1,69),(2,70),(3,70),(4,69),(5,70),(6,76),(7,71),(8,78),(9,76),(10,73),(11,76),(12,76),(13,69),(14,72),(15,76),(16,77),(17,68),(18,78),(19,68),
	(20,69),(21,67),(22,69),(23,69),(24,71),(25,69),(26,78),(27,68),(28,69),(29,78),(30,72),(31,71),(32,77),(33,77),(34,77),(35,77),(36,77),
	(37,77),(38,77),(39,77),(40,77),(41,77),(42,77),(43,68),(44,77),(45,77),(46,77),(47,77),(48,71),(49,77),(50,76),(51,77),(52,77),
	(53,77),(54,77),(55,77),(56,77),(57,77),(58,77),(59,77),(60,77),(61,77),(62,77),(63,77),(64,77),(65,73),(66,75)
;

END;