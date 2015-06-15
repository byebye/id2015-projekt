--Skrypt dodający do bazy wszystkie _typy
BEGIN;

--Typy dokumentow
INSERT INTO dokumenty_typy(id, nazwa, wiarygodny) VALUES
	(DEFAULT, 'Obraz', false),
	(DEFAULT, 'Portret', false),
	(DEFAULT, 'Kronika', true),
	(DEFAULT, 'Ballada', false),
	(DEFAULT, 'Pieśń', false),
	(DEFAULT, 'List', false),
	(DEFAULT, 'Akt prawny', true),
	(DEFAULT, 'Akt własności', true),
	(DEFAULT, 'Umowa', true),
	(DEFAULT, 'Legenda', false),
	(DEFAULT, 'Godło',true)
;

--Typy miejsc
INSERT INTO miejsca_typy(id, nazwa) VALUES
	(DEFAULT, 'Zamek'),
	(DEFAULT, 'Miasto'),
	(DEFAULT, 'Krainy')
;

--Typy wydarzen
INSERT INTO wydarzenia_typy(id, nazwa) VALUES
	(DEFAULT, 'Narodziny'),
	(DEFAULT, 'Zgon naturalny'),
	(DEFAULT, 'Śmierć nienaturalna'),
	(DEFAULT, 'Pogrzeb'),
	(DEFAULT, 'Zabójstwo'),
	(DEFAULT, 'Wojna'),
	(DEFAULT, 'Bitwa'),
	(DEFAULT, 'Koronowanie'),
	(DEFAULT, 'Chrzciny'),
	(DEFAULT, 'Wydziedziczenie'),
	(DEFAULT, 'Rozwód'),
	(DEFAULT, 'Małżeństwo'),
	(DEFAULT, 'Nadanie ziem'),
	(DEFAULT, 'Uznanie bękarta'),
	(DEFAULT, 'Wstąpienie do Nocnej Straży'),
	(DEFAULT, 'Pasowanie'),
	(DEFAULT, 'Aneksja ziem'),
	(DEFAULT, 'Banicja'),
	(DEFAULT, 'Rozejm'),
	(DEFAULT, 'Początek świata'),
	(DEFAULT, 'Adopcja'),
	(DEFAULT, 'Przejęcie władzy')
;

END;
