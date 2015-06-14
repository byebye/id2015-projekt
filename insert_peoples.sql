INSERT INTO kolory(nazwa) VALUES
	('Zielony'),
	('Niebieski'),
	('Brązowy'),
	('Żółty'),
	('Blond'),
	('Granatowy'),
	('Szary'),
	('Czarny'),
	('Biały')
;

INSERT INTO religie(nazwa,opis) VALUES
	('Czerwony Bóg','Religia opiera się na dualistycznym widzeniu świata. Rhllor, bóg światła, ciepła i życia, walczy z Wielkim Innym, bogiem lodu i śmierci. Są oni uwikłani w wieczną walkę o losy świata, która według starożytnej przepowiedni z Księgi Asshai, zakończy się tylko wtedy, gdy powróci Azor Ahai, boska postać, dzierżąca ognisty miecz - zwany Światłonoścą. Według Martina, wiara ta inspirowana jest Zaratusztrianizmem. Ta religia ma dualistyczne aspekty dobrego i złego boga.'),
	('Wielki Pasterz','Religia mająca swoich wyznawców u Lhazareńczyków'),
	('Wiara Siedmiu','Dominująca religia Siedmiu Królestw, a także praktykowana na znacznie mniejszą skalę w zachodniej części Essos. Jedyną częścią Westeros, gdzie Wiara nie jest powszechna jest Północ, gdzie wciąż praktykowana jest religia Starych Bogów.'),
	('Starzy Bogowie','Bogowie dzieci lasu, bezimienne bóstwa kamieni, ziemi i drzew. Nazywane starymi bogami przez wyznawców Wiary Siedmiu (Nowi bogowie), religii która wyparła tę wiarę ze wszystkich regionów Westeros oprócz Północy. Wciąż jest tam praktykowana, popularna jest również wśród dzikich zza Muru'),
	('Utopiony','Wiara w utopoionego boga')
;

INSERT INTO funkcje(nazwa) VALUES
	('Członek Małej Rady'),
	('Król'),
	('Namiestnik'),
	('Nestor rodu')
;

--założyciele rodów
INSERT INTO osoby(imie,nazwisko,plec,matka_biol,ojciec_biol,kolor_oczu,kolor_wlosow,religia) VALUES
	('Artys','Arryn','Mężczyzna',NULL,NULL,1,2,3),
	('Orys','Baratheon','Mężczyzna',NULL,NULL,1,1,3),
	('Morys','Bolton','Mężczyzna',NULL,NULL,1,1,4),
	('Karlon','Stark','Mężczyzna',NULL,NULL,1,1,4),
	('Morgan','Martell','Mężczyzna',NULL,NULL,1,1,3),
	('Allester','Tyrell','Mężczyzna',NULL,NULL,1,1,3),
	('Szary','Król','Mężczyzna',NULL,NULL,1,1,5),
	('Walder','Frey','Mężczyzna',NULL,NULL,1,1,3),
	('Lann','Sprytny','Mężczyzna',NULL,NULL,1,1,3),
	('Bran','Budowniczy','Mężczyzna',NULL,NULL,1,1,4),
	('Aegon','Targaryen','Mężczyzna',NULL,NULL,1,1,3),
;


INSERT INTO rody(nazwa,zalozyciel,stolica,godlo,dewiza) VALUES
	('Arryn',1,1,1,'Tak wysoko, jak honor.'),
	('Baratheon',2,5,2,'Nasza jest furia.'),
	('Bolton',3,9,3,'Nasze ostrza są ostre.'),
	('Karstark',4,11,4,'Słońce Zimy'),
	('Martell',5,43,5,'Niezachwiani, Nieugięci, Niezłomni'),
	('Tyrell',6,30,6,'Zbieramy siły.'),
	('Greyjoy',7,66,7,'My nie siejemy.'),
	('Frey',8,13,8,'Brak danych'),
	('Lannister',9,7,9,'Słuchajcie mego ryku'),
	('Stark',10,6,10,'Nadchodzi zima'),
	('Targaryen',11,36,11,'Krew i ogień')
;