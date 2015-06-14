BEGIN;
INSERT INTO kolory(id,nazwa) VALUES
	(1,'Zielony'),
	(2,'Niebieski'),
	(3,'Brązowy'),
	(4,'Żółty'),
	(5,'Blond'),
	(6,'Granatowy'),
	(7,'Szary'),
	(8,'Czarny'),
	(9,'Biały')
;

INSERT INTO religie(id,nazwa,opis) VALUES
	(1,'Czerwony Bóg','Religia opiera się na dualistycznym widzeniu świata. Rhllor, bóg światła, ciepła i życia, walczy z Wielkim Innym, bogiem lodu i śmierci. Są oni uwikłani w wieczną walkę o losy świata, która według starożytnej przepowiedni z Księgi Asshai, zakończy się tylko wtedy, gdy powróci Azor Ahai, boska postać, dzierżąca ognisty miecz - zwany Światłonoścą. Według Martina, wiara ta inspirowana jest Zaratusztrianizmem. Ta religia ma dualistyczne aspekty dobrego i złego boga.'),
	(2,'Wielki Pasterz','Religia mająca swoich wyznawców u Lhazareńczyków'),
	(3,'Wiara Siedmiu','Dominująca religia Siedmiu Królestw, a także praktykowana na znacznie mniejszą skalę w zachodniej części Essos. Jedyną częścią Westeros, gdzie Wiara nie jest powszechna jest Północ, gdzie wciąż praktykowana jest religia Starych Bogów.'),
	(4,'Starzy Bogowie','Bogowie dzieci lasu, bezimienne bóstwa kamieni, ziemi i drzew. Nazywane starymi bogami przez wyznawców Wiary Siedmiu (Nowi bogowie), religii która wyparła tę wiarę ze wszystkich regionów Westeros oprócz Północy. Wciąż jest tam praktykowana, popularna jest również wśród dzikich zza Muru'),
	(5,'Utopiony','Wiara w utopoionego boga')
;

INSERT INTO funkcje(id,nazwa) VALUES
	(1,'Członek Małej Rady'),
	(2,'Król'),
	(3,'Namiestnik'),
	(4,'Nestor rodu')
;

--założyciele rodów
INSERT INTO osoby VALUES
	(1,'Artys','Arryn','Mężczyzna',NULL,NULL,1,2,3),
	(2,'Orys','Baratheon','Mężczyzna',NULL,NULL,1,1,3),
	(3,'Morys','Bolton','Mężczyzna',NULL,NULL,1,1,4),
	(4,'Karlon','Stark','Mężczyzna',NULL,NULL,1,1,4),
	(5,'Morgan','Martell','Mężczyzna',NULL,NULL,1,1,3),
	(6,'Allester','Tyrell','Mężczyzna',NULL,NULL,1,1,3),
	(7,'Szary','Król','Mężczyzna',NULL,NULL,1,1,5),
	(8,'Walder','Frey','Mężczyzna',NULL,NULL,1,1,3),
	(9,'Lann','Sprytny','Mężczyzna',NULL,NULL,1,1,3),
	(10,'Bran','Budowniczy','Mężczyzna',NULL,NULL,1,1,4),
	(11,'Aegon','Targaryen','Mężczyzna',NULL,NULL,1,1,3)
;


INSERT INTO rody(id,nazwa,zalozyciel,stolica,godlo,dewiza) VALUES
	(1,'Arryn',1,1,1,'Tak wysoko, jak honor.'),
	(2,'Baratheon',2,5,2,'Nasza jest furia.'),
	(3,'Bolton',3,9,3,'Nasze ostrza są ostre.'),
	(4,'Karstark',4,11,4,'Słońce Zimy'),
	(5,'Martell',5,43,5,'Niezachwiani, Nieugięci, Niezłomni'),
	(6,'Tyrell',6,30,6,'Zbieramy siły.'),
	(7,'Greyjoy',7,66,7,'My nie siejemy.'),
	(8,'Frey',8,13,8,'Brak danych'),
	(9,'Lannister',9,7,9,'Słuchajcie mego ryku'),
	(10,'Stark',10,6,10,'Nadchodzi zima'),
	(11,'Targaryen',11,36,11,'Krew i ogień')
;

INSERT INTO rody_zaleznosci VALUES
	(DEFAULT,1,2,1),
	(DEFAULT,10,2,1),
	(DEFAULT,9,2,1),
	(DEFAULT,11,2,1),
	(DEFAULT,7,2,1),
	(DEFAULT,8,1,1),
	(DEFAULT,3,10,1),
	(DEFAULT,4,10,1),
	(DEFAULT,5,9,1),
	(DEFAULT,6,9,1)
;

INSERT INTO rody_miejsca SELECT 1, id_miejsce FROM miejsca_krainy WHERE id_kraina = 67; --Arryn
INSERT INTO rody_miejsca SELECT 2, id_miejsce FROM miejsca_krainy WHERE id_kraina IN(70,73,78); --Baratheon
INSERT INTO rody_miejsca SELECT 3, id_miejsce FROM miejsca_krainy WHERE id_kraina = 69 AND id_miejsce <> 13; --Bolton
INSERT INTO rody_miejsca SELECT 5, id_miejsce FROM miejsca_krainy WHERE id_kraina = 68; --Martel
INSERT INTO rody_miejsca SELECT 6, id_miejsce FROM miejsca_krainy WHERE id_kraina = 72; --Tyrell
INSERT INTO rody_miejsca SELECT 7, id_miejsce FROM miejsca_krainy WHERE id_kraina = 75; --Greyjoy
INSERT INTO rody_miejsca VALUES(8,13); --Frey
INSERT INTO rody_miejsca SELECT 9, id_miejsce FROM miejsca_krainy WHERE id_kraina = 71; --Lannister
INSERT INTO rody_miejsca SELECT 11,id_miejsce FROM miejsca_krainy WHERE id_kraina = 77; --Targaryen
INSERT INTO rody_miejsca VALUES (4,11); --Karstark
INSERT INTO rody_miejsca SELECT 10,id_miejsce FROM miejsca_krainy WHERE id_kraina = 76 AND id_miejsce <> 11; --Stark



END;
