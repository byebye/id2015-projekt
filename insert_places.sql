BEGIN;
--zamki
INSERT INTO miejsca(id,nazwa,typ,wielkosc) VALUES
	(DEFAULT,'Orle Gniazdo',1,'mały'),
	(DEFAULT,'Kamienny Bęben',1,'średni'),
	(DEFAULT,'Smocza Skała',1,'średni'),
	(DEFAULT,'Harrenhal',1,'duży'),
	(DEFAULT,'Koniec Burzy',1,'średni'),
	(DEFAULT,'Winterfell',1,'duży'),
	(DEFAULT,'Casterly Rock',1,'duży'),
	(DEFAULT,'Czarny Zamek',1,'mały'),
	(DEFAULT,'Dreadfort',1,'mały'),
	(DEFAULT,'Czerwona Twierdza',1,'duży'),
	(DEFAULT,'Karhold',1,'średni'),
	(DEFAULT,'Fosa Cailin',1,'mały'),
	(DEFAULT,'Bliźniaki',1,'duży'),
	(DEFAULT,'Summerhal',1,'średni'),
	(DEFAULT,'Torrhens Square',1,'mały'),
	(DEFAULT,'Ashemark',1,'mały'),
	(DEFAULT,'Blackmont',1,'duży'),
	(DEFAULT,'Dębowa Tarcza',1,'średni'),
	(DEFAULT,'Ghaston Grey',1,'duży'),
	(DEFAULT,'Hornvale',1,'mały'),
	(DEFAULT,'Kamienne drzwi',1,'mały'),
	(DEFAULT,'Pinkmaiden',1,'średni'),
	(DEFAULT,'Riverrun',1,'duży'),
	(DEFAULT,'Sarsfield',1,'mały'),
	(DEFAULT,'Seagard',1,'średni'),
	(DEFAULT,'Sobolowy Dwór',1,'duży'),
	(DEFAULT,'Starfall',1,'średni'),
	(DEFAULT,'Staw Dziewic',1,'mały'),
	(DEFAULT,'Wschodnia Strażnica',1,'duży'),
	(DEFAULT,'Wysogród',1,'duży'),
	(DEFAULT,'Złoty Ząb',1,'mały')
;

--miasta
INSERT INTO miejsca(id,nazwa,typ,wielkosc) VALUES
	(DEFAULT,'Braavos',2,'mały'),
	(DEFAULT,'Meereen',2,'duży'),
	(DEFAULT,'Asshai',2,'średni'),
	(DEFAULT,'Wolne Miasta',2,'mały'),
	(DEFAULT,'Stara Valyria',2,'duży'),
	(DEFAULT,'Astapor',2,'średni'),
	(DEFAULT,'Pentos',2,'duży'),
	(DEFAULT,'Vaes Dothrak',2,'mały'),
	(DEFAULT,'Lys',2,'duży'),
	(DEFAULT,'Lorath',2,'średni'),
	(DEFAULT,'Stare Miasto',2,'mały'),
	(DEFAULT,'Słoneczna Włócznia',2,'mały'),
	(DEFAULT,'Myr',2,'duży'),
	(DEFAULT,'Norvos',2,'średni'),
	(DEFAULT,'Tyrosh',2,'duży'),
	(DEFAULT,'Qohor',2,'średni'),
	(DEFAULT,'Lannisport',2,'mały'),
	(DEFAULT,'Stare Ghis',2,'duży'),
	(DEFAULT,'Biała Przystań',2,'mały'),
	(DEFAULT,'Nowe Ghis',2,'duży'),
	(DEFAULT,'Bayasabhad',2,'średni'),
	(DEFAULT,'Tolos',2,'średni'),
	(DEFAULT,'Mantarys',2,'mały'),
	(DEFAULT,'Elyria',2,'duży'),
	(DEFAULT,'Samyrian',2,'średni'),
	(DEFAULT,'Gulltown',2,'mały'),
	(DEFAULT,'Tyria',2,'duży'),
	(DEFAULT,'Oros',2,'mały'),
	(DEFAULT,'Chroyane',2,'mały'),
	(DEFAULT,'Bhorash',2,'duży'),
	(DEFAULT,'Ny Sar',2,'średni'),
	(DEFAULT,'Ar Noy',2,'średni'),
	(DEFAULT,'Saer Mell',2,'mały'),
	(DEFAULT,'Królewska Przystań',2,'duży')
;

--brakujace
INSERT INTO miejsca(id,nazwa,typ) VALUES
	(DEFAULT,'Pyke',1);

--krainy
INSERT INTO miejsca(id,nazwa,typ) VALUES
	(DEFAULT,'Dolina Arrynów',3),
	(DEFAULT,'Dorne',3),
	(DEFAULT,'Dorzecze',3),
	(DEFAULT,'Krainy Burzy',3),
	(DEFAULT,'Królestwo Zachodu',3),
	(DEFAULT,'Reach',3),
	(DEFAULT,'Włości Korony',3),
	(DEFAULT,'Żelazne wyspy',3),
	(DEFAULT,'Północ',3),
	(DEFAULT,'Essos',3),
	(DEFAULT,'Nocna Straż',3)
;

INSERT INTO miejsca_krainy VALUES
	(1,67),(2,70),(3,70),(4,69),(5,70),(6,76),(7,71),(8,78),(9,76),(10,73),(11,76),(12,76),(13,69),(14,72),(15,76),(16,77),(17,68),(18,78),(19,68),
	(20,69),(21,67),(22,69),(23,69),(24,71),(25,69),(26,78),(27,68),(28,69),(29,78),(30,72),(31,71),(32,77),(33,77),(34,77),(35,77),(36,77),
	(37,77),(38,77),(39,77),(40,77),(41,77),(42,77),(43,68),(44,77),(45,77),(46,77),(47,77),(48,71),(49,77),(50,76),(51,77),(52,77),
	(53,77),(54,77),(55,77),(56,77),(57,77),(58,77),(59,77),(60,77),(61,77),(62,77),(63,77),(64,77),(65,73),(66,75)
;

END;