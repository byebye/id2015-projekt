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
	(DEFAULT,'Artys','Arryn','Mężczyzna',NULL,NULL,1,2,3),
	(DEFAULT,'Orys','Baratheon','Mężczyzna',NULL,NULL,1,1,3),
	(DEFAULT,'Morys','Bolton','Mężczyzna',NULL,NULL,1,1,4),
	(DEFAULT,'Karlon','Stark','Mężczyzna',NULL,NULL,1,1,4),
	(DEFAULT,'Morgan','Martell','Mężczyzna',NULL,NULL,1,1,3),
	(DEFAULT,'Allester','Tyrell','Mężczyzna',NULL,NULL,1,1,3),
	(DEFAULT,'Szary','Król','Mężczyzna',NULL,NULL,1,1,5),
	(DEFAULT,'Walder','Frey','Mężczyzna',NULL,NULL,1,1,3),
	(DEFAULT,'Lann','Sprytny','Mężczyzna',NULL,NULL,1,1,3),
	(DEFAULT,'Bran','Budowniczy','Mężczyzna',NULL,NULL,1,1,4),
	(DEFAULT,'Aegon','Targaryen','Mężczyzna',NULL,NULL,1,1,3)
;

--Ród Starków
INSERT INTO osoby VALUES
	(DEFAULT,'Brandon','Stark','Mężczyzna',NULL,10,1,1,4),
	(DEFAULT,'Eddard','Stark','Mężczyzna',NULL,10,1,1,4),
	(DEFAULT,'Benjen','Stark','Mężczyzna',NULL,10,1,1,4),
	(DEFAULT,'Lyanna','Stark','Kobieta',NULL,10,1,1,4),
	(DEFAULT,'Robb','Stark','Mężczyzna',17,13,1,1,4),
	(DEFAULT,'Catelyn','Tully','Kobieta',NULL,NULL,1,1,3),
	(DEFAULT,'Sansa','Stark','Kobieta',17,13,1,1,4),
	(DEFAULT,'Tytos','Lannister','Mężczyzna',NULL,9,1,1,3),
	(DEFAULT,'Jayne','Marbrant','Kobieta',NULL,NULL,1,1,3),
	(DEFAULT,'Rhaegar','Targaryen','Mężczyzna',NULL,11,1,1,3),
	(DEFAULT,'Jon','Targaryen','Mężczyzna',15,21,1,1,3),
	(DEFAULT,'Tywin','Lannister','Mężczyzna',20,19,1,1,3),
	(DEFAULT,'Kevan','Lannister','Mężczyzna',20,19,1,1,3),
	(DEFAULT,'Tygetta','Hill','Kobieta',NULL,23,1,1,3),
	(DEFAULT,'Gerion','Hill','Mężczyzna',NULL,23,1,1,3),
	(DEFAULT,'Joanna','Lannister','Kobieta',NULL,NULL,1,5,3),
	(DEFAULT,'Cercei','Lannister','Kobieta',27,23,1,5,3),
	(DEFAULT,'Jaime', 'Lannister','Mężczyzna',27,23,2,5,3),
	(DEFAULT,'Tyrion','Lannister','Mężczyzna',27,23,3,5,3),
	(DEFAULT,'Joffrey','Baratheon','Mężczyzna',28,29,2,5,3),
	(DEFAULT,'Myrcella','Baratheon','Kobieta',28,29,2,5,3),
	(DEFAULT,'Tommen','Baratheon','Mężczyzna',28,29,2,5,3),
	(DEFAULT,'Margaery','Tyrell','Kobieta',NULL,NULL,3,3,NULL)
;

INSERT INTO osoby_wydarzenia VALUES
	(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),
	(12,2),(12,7),(12,8),
	(13,3),(13,9),
	(14,4),
	(15,5),(15,13),
	(16,11),
	(18,17),
	(17,6),(17,7),(17,9),
	(19,15),(19,16),
	(20,16),
	(21,18),(21,13),
	(22,12),(22,14),
	(28,20),(29,21),(30,22),(31,23),(32,24),(33,25),
	(34,26),
	(34,27),(31,27), -- ślub Joeffreya i Maergary
	(31,28), -- śmierć Joeffreya
	(34,29),(33,29), -- ślub Tommena i Maergary
	(30,30),(18,30), -- ślub Sansy i Tyriona
	(23,31),(27,31) -- ślub Tywina i Joanny
;

INSERT INTO rody(id,nazwa,zalozyciel,stolica,godlo,dewiza) VALUES
	(DEFAULT,'Arryn',1,1,1,'Tak wysoko, jak honor.'),
	(DEFAULT,'Baratheon',2,5,2,'Nasza jest furia.'),
	(DEFAULT,'Bolton',3,9,3,'Nasze ostrza są ostre.'),
	(DEFAULT,'Karstark',4,11,4,'Słońce Zimy'),
	(DEFAULT,'Martell',5,43,5,'Niezachwiani, Nieugięci, Niezłomni'),
	(DEFAULT,'Tyrell',6,30,6,'Zbieramy siły.'),
	(DEFAULT,'Greyjoy',7,66,7,'My nie siejemy.'),
	(DEFAULT,'Frey',8,13,8,'Brak danych'),
	(DEFAULT,'Lannister',9,7,9,'Słuchajcie mego ryku'),
	(DEFAULT,'Stark',10,6,10,'Nadchodzi zima'),
	(DEFAULT,'Targaryen',11,36,11,'Krew i ogień')
;

INSERT INTO rody_zaleznosci VALUES
	(DEFAULT,1,2,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,10,2,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,9,2,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,11,2,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,7,2,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,8,1,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,3,10,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,4,10,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,5,9,(select id from wydarzenia where nazwa = 'Akt podziału królestwa')),
	(DEFAULT,6,9,(select id from wydarzenia where nazwa = 'Akt podziału królestwa'))
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


--wstaw wydarzenie o aneksji ziem
INSERT INTO wydarzenia(data,nazwa,typ,opis,miejsce)
	SELECT date '0001-01-01','Nadanie ziem',13,NULL,id FROM miejsca;

INSERT INTO rody_wydarzenia
	SELECT R.id_rodu, W.id
	FROM wydarzenia W JOIN rody_miejsca R ON R.id_miejsce = W.miejsce
	WHERE W.typ = 13
;


END;
