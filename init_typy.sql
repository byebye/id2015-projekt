--Skrypt dodający do bazy wszystkie _typy
BEGIN;

--Typy dokumentow
INSERT INTO dokumenty_typy(nazwa) VALUES
	('Obraz'),
	('Portret'),
	('Kronika'),
	('Ballada'),
	('Pieśń'),
	('List'),
	('Akt prawny'),
	('Akt własności'),
	('Umowa'),
	('Legenda')
;

--Typy miejsc
INSERT INTO miejsca_typy(nazwa) VALUES
	('Zamek'),
	('Miasto'),
	('Miasteczko'),
	('Lenno'),
	('Wieś'),
	('Ziemia'),
	('Twierdza')
;

--Typy wydarzen
INSERT INTO wydarzenia_typy(nazwa) VALUES
	('Narodziny'),
	('Zgon naturalny'),
	('Śmierć nienaturalna'),
	('Zabójstwo'),
	('Wojna'),
	('Bitwa'),
	('Koronowanie'),
	('Chrzciny'),
	('Wydziedziczenie'),
	('Rozwod'),
	('Nadanie ziem'),
	('Uznanie bękarta'),
	('Wstąpienie do Nocnej Straży'),
	('Pasowanie'),
	('Aneksja ziem'),
	('Banicja')
;




