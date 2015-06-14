START TRANSACTION;


INSERT INTO wydarzenia (nazwa, typ, opis, miejsce) VALUES
('Czerwone Wesele', 7, 'Wesele na którym zginął Robb, Catelyn, i inni', (select id from miejsca where nazwa = 'Bliźniaki'));

INSERT INTO osoby(imie, nazwisko, plec) VALUES
('Robb', 'Stark', 'Mężczyzna');

INSERT INTO osoby_wydarzenia 
   SELECT (SELECT id from osoby where imie = 'Robb' and nazwisko = 'Stark'),
        (SELECT id from wydarzenia where nazwa = 'Czerwone Wesele');

COMMIT;
