--Skrypt dodający do bazy wszystkie _typy
BEGIN;

--Typy dokumentow
INSERT INTO dokumenty_typy(id, nazwa, wiarygodny) VALUES
	(1, 'Obraz', false),
	(2, 'Portret', false),
	(3, 'Kronika', true),
	(4, 'Ballada', false),
	(5, 'Pieśń', false),
	(6, 'List', false),
	(7, 'Akt prawny', true),
	(8, 'Akt własności', true),
	(9, 'Umowa', true),
	(10, 'Legenda', false),
	(11, 'Godło',true)
;

--Typy miejsc
INSERT INTO miejsca_typy(id, nazwa) VALUES
	(1, 'Zamek'),
	(2, 'Miasto'),
	(3, 'Krainy')
;

--Typy wydarzen
INSERT INTO wydarzenia_typy(id, nazwa) VALUES
	(1, 'Narodziny'),
	(2, 'Zgon naturalny'),
	(3, 'Śmierć nienaturalna'),
	(4, 'Pogrzeb'),
	(5, 'Zabójstwo'),
	(6, 'Wojna'),
	(7, 'Bitwa'),
	(8, 'Koronowanie'),
	(9, 'Chrzciny'),
	(10, 'Wydziedziczenie'),
	(11, 'Rozwód'),
	(12, 'Małżeństwo'),
	(13, 'Nadanie ziem'),
	(14, 'Uznanie bękarta'),
	(15, 'Wstąpienie do Nocnej Straży'),
	(16, 'Pasowanie'),
	(17, 'Aneksja ziem'),
	(18, 'Banicja'),
	(19, 'Rozejm'),
	(20, 'Początek świata'),
	(21, 'Adopcja')
;

END;
