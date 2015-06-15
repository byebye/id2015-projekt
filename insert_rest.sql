START TRANSACTION;

INSERT INTO wydarzenia_z_lista_uczestnikow VALUES 
(DEFAULT, 'Czerwone Wesele', NULL, getId('miejsca', 'nazwa', 'Bliźniaki'), 'Wesele', 7, '{"Robb Stark"}');

COMMIT;
