--Skrypt dodający do bazy wszystkie _typy
BEGIN;

--Typy dokumentow
INSERT INTO dokumenty_typy(nazwa, wiarygodny) VALUES
	('Obraz', false),
	('Portret', false),
	('Kronika', true),
	('Ballada', false),
	('Pieśń', false),
	('List', false),
	('Akt prawny', true),
	('Akt własności', true),
	('Umowa', true),
	('Legenda', false)
;

--Typy miejsc
INSERT INTO miejsca_typy(nazwa) VALUES
	('Zamek'),
	('Miasto'),
	('Krainy')
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

END;
