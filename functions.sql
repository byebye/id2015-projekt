-- Funkcje i widoki
BEGIN;

-- Trigger: jeśli przy wstawianiu do tabeli 'dokumenty' nie zostanie zdefiniowana wiarygodność, to zostanie przypisana domyślna wartość ustalona w 'dokumenty_typy'
CREATE OR REPLACE FUNCTION set_dokument_wiarygodny() 
   RETURNS trigger AS $set_dokument_wiarygodny$
BEGIN
   NEW.wiarygodny = coalesce(NEW.wiarygodny, (SELECT wiarygodny 
                                                FROM dokumenty_typy
                                                WHERE NEW.typ = id
                                             )
                            );
   RETURN NEW;
END;
$set_dokument_wiarygodny$ LANGUAGE plpgsql;

CREATE TRIGGER set_dokument_wiarygodny BEFORE INSERT ON dokumenty
   FOR EACH ROW EXECUTE PROCEDURE set_dokument_wiarygodny();

-- Function: dla osoby o danym id wyświetla wydarzenia o danym typie (podanym jako nazwa, nie id)

CREATE OR REPLACE FUNCTION get_wydarzenia(osoba int, VARIADIC wydarzenie_typy text[]) 
   RETURNS SETOF wydarzenia AS $$
BEGIN
   RETURN QUERY
      SELECT wyd.*
         FROM osoby_wydarzenia os_wyd
         JOIN wydarzenia wyd ON wyd.id = id_wydarzenie
         JOIN wydarzenia_typy wt ON wt.id = wyd.typ
         WHERE id_osoba = osoba
            AND wt.nazwa = ANY (wydarzenie_typy)
   ;
END;
$$ LANGUAGE plpgsql;

-- Function: dla danej osoby zwraca datę śmierci

CREATE OR REPLACE FUNCTION get_data_smierci(osoba int) 
   RETURNS table(data date) AS $$
BEGIN
   RETURN QUERY
      SELECT get_wydarzenia.data FROM get_wydarzenia(osoba, 'Zgon naturalny', 'Śmierć nienaturalna');
END;
$$ LANGUAGE plpgsql;

-- Function: sprawdza, czy dana osoba żyła o podanej dacie

CREATE OR REPLACE FUNCTION czy_byla_zywa(osoba int, data date)
   RETURNS bool AS $$
DECLARE
   narodziny date;
   smierc    date;
BEGIN
   narodziny = (SELECT wyd.data FROM get_wydarzenia(osoba, 'Narodziny') wyd);
   smierc = (SELECT wyd.data FROM get_data_smierci(osoba) wyd);
   RETURN narodziny <= data AND data <= smierc;
END;
$$ LANGUAGE plpgsql;

-- Function: sprawdza, czy rodzic urodził się przed dzieckiem i był żywy w trakcie narodzin (matka) i poczęcia (oboje)

CREATE OR REPLACE FUNCTION czy_moze_byc_rodzicem(rodzic int, dziecko int) 
   RETURNS bool AS $$
DECLARE
   dziecko_narodziny date;
BEGIN
   dziecko_narodziny = (SELECT data FROM get_wydarzenia(dziecko, 'Narodziny'));
   IF 'Kobieta' = (SELECT plec FROM osoby WHERE osoby.id = rodzic) THEN
      RETURN (czy_byla_zywa(rodzic, (dziecko_narodziny - interval '9 months')::date) AND czy_byla_zywa(rodzic, dziecko_narodziny));
   ELSE
      RETURN czy_byla_zywa(rodzic, (dziecko_narodziny - interval '9 months')::date);
   END IF;
END;
$$ LANGUAGE plpgsql;

-- Trigger: rodzice muszą być odpowiedniej płci, starsi od swojego dziecka, a matka żywa w trakcie jego narodzin

CREATE OR REPLACE FUNCTION check_rodzice() 
   RETURNS trigger AS $check_rodzice$
DECLARE
   matka record;
   ojciec record;
BEGIN
      IF NEW.matka_biol = NULL OR NEW.ojciec_biol = NULL THEN RETURN NEW;
      END IF;
      SELECT id, plec FROM osoby WHERE id = NEW.matka_biol INTO matka;
      SELECT id, plec FROM osoby WHERE id = NEW.ojciec_biol INTO ojciec;
      IF matka.plec != 'Kobieta' OR ojciec.plec != 'Mężczyzna' THEN
         RAISE EXCEPTION 'Rodzice muszą być odpowiedniej płci';
      ELSIF NOT czy_moze_byc_rodzicem(matka.id, NEW.id) OR NOT czy_moze_byc_rodzicem(ojciec.id, NEW.id) THEN
         RAISE EXCEPTION 'Rodzice muszą być starsi i żywi (tylko matka) w trakcie narodzin dziecka i jego poczęcia (oboje)';
      ELSE
         RETURN NEW;
      END IF;
END;
$check_rodzice$ LANGUAGE plpgsql;

CREATE TRIGGER check_rodzice BEFORE INSERT OR UPDATE ON osoby
   FOR EACH ROW EXECUTE PROCEDURE check_rodzice();

-- Function: dla podanej osoby i liczby n zwraca id wszystkich przodków n-kroków wstecz wraz ze stopniem pokrewieństwa. Dla n = -1 zwraca wszystkich przodków

CREATE OR REPLACE FUNCTION get_przodkowie(osoba int, n int DEFAULT -1) 
   RETURNS table(id int, poziom int) AS $$
BEGIN
   RETURN QUERY
      WITH RECURSIVE get_przodkowie_helper(os, poziom) AS (
         SELECT osoby.id, 0 AS poziom
            FROM osoby
            WHERE osoby.id = osoba
      UNION
         SELECT osoby.id, przodek.poziom + 1
         FROM osoby, get_przodkowie_helper przodek
         WHERE (przodek.poziom < n OR n = -1)
               AND 
               (
                  osoby.id = (SELECT matka_biol
                                 FROM osoby 
                                 WHERE osoby.id = przodek.os
                              )
                  OR
                  osoby.id = (SELECT ojciec_biol 
                                 FROM osoby 
                                 WHERE osoby.id = przodek.os
                              )
               )
      )
      SELECT *
      FROM get_przodkowie_helper;
END;
$$ LANGUAGE plpgsql;

-- Function: dla podanej osoby i liczby n zwraca id wszystkich potomków n-kroków w przód wraz ze stopniem pokrewieństwa. Dla n = -1 zwraca wszystkich potomków

CREATE OR REPLACE FUNCTION get_potomkowie(osoba int, n int DEFAULT -1) 
   RETURNS table(id int, poziom int) AS $$
BEGIN
   RETURN QUERY
      WITH RECURSIVE get_potomkowie_helper(os, poziom) AS (
         SELECT osoby.id, 0 AS poziom
            FROM osoby
            WHERE osoby.id = osoba
      UNION
         SELECT osoby.id, potomek.poziom + 1
         FROM osoby, get_potomkowie_helper potomek
         WHERE (potomek.poziom < n OR n = -1)
               AND 
               osoby.id IN (SELECT osoby.id
                              FROM osoby
                              WHERE ojciec_biol = potomek.os OR matka_biol = potomek.os
                           )
      )
      SELECT *
      FROM get_potomkowie_helper;
END;
$$ LANGUAGE plpgsql;

-- Function: sprawdza, czy dane dwie osoby są spokrewnione w sensie biologicznym, tzn. czy mają wspólnych przodków

CREATE OR REPLACE FUNCTION czy_spokrewnieni(osoba_A int, osoba_B int) 
   RETURNS bool AS $$
BEGIN
   RETURN 
      (SELECT array_agg(id) FROM get_przodkowie(osoba_A))
      &&
      (SELECT array_agg(id) FROM get_przodkowie(osoba_B))
   ;
END;
$$ LANGUAGE plpgsql;

-- Function: wszystkie osoby biorące udział w danym wydarzeniu

CREATE OR REPLACE FUNCTION kto_bral_udzial(wydarzenie int)
   RETURNS SETOF osoby AS $$
BEGIN
   RETURN QUERY 
      SELECT osoby.*
      FROM osoby_wydarzenia ow
      JOIN osoby ON osoby.id = ow.id_osoba
      WHERE ow.id_wydarzenie = wydarzenie;
END;
$$ LANGUAGE plpgsql;

-- Function: zwraca id wszystkich osób żyjących w danym przedziale czasu

CREATE OR REPLACE FUNCTION get_zyjacy(pocz date, koniec date)
   RETURNS SETOF int AS $$
DECLARE
   narodziny date;
   smierc date;
   id int;
BEGIN
   FOR id in (SELECT osoby.id FROM osoby) LOOP
      narodziny = (get_wydarzenia(id, 'Narodziny')).data;
      smierc = get_data_smierci(id);
      IF (narodziny < koniec AND coalesce(koniec <= smierc, true))
         OR (narodziny <= pocz AND coalesce(pocz < smierc, true))
         OR (pocz <= narodziny AND smierc <= koniec)
      THEN
         RETURN NEXT id;
      END IF;
   END LOOP;
   RETURN;
END;
$$ LANGUAGE plpgsql;

-- Trigger: sprawdza, czy osoba dodana do wydarzenia była w jego trakcie żywa (wyłączając narodziny, śmierć, pogrzeb) i sprawdza, czy nie próbujemy wstawić kolejnych narodzin lub śmierci

CREATE OR REPLACE FUNCTION check_wydarzenie_osoba()
   RETURNS trigger AS $check_wydarzenie_osoba$
DECLARE
   wyd record;
   typ varchar(50);
BEGIN
   SELECT * FROM wydarzenia w WHERE w.id = NEW.id_wydarzenie INTO wyd;
   typ = (SELECT nazwa 
            FROM wydarzenia_typy wt
            WHERE wt.id = wyd.typ
         );
   IF typ IN ('Narodziny', 'Zgon naturalny', 'Śmierć nienaturalna', 'Pogrzeb') THEN
      IF (SELECT COUNT(*) FROM get_wydarzenia(NEW.id_osoba, typ)) > 0 THEN
         RAISE EXCEPTION 'Narodziny, śmierć i pogrzeb nie mogą się powtarzać';
      ELSE
         RETURN NEW;
      END IF;
   ELSIF NOT czy_byla_zywa(NEW.id_osoba, wyd.data) THEN
      RAISE EXCEPTION 'Osoba musi być żywa w trakcie danego wydarzenia';
   ELSE
      RETURN NEW;
   END IF; 
END;
$check_wydarzenie_osoba$ LANGUAGE plpgsql;

CREATE TRIGGER check_wydarzenie_osoba BEFORE INSERT OR UPDATE ON osoby_wydarzenia
   FOR EACH ROW EXECUTE PROCEDURE check_wydarzenie_osoba();

--Trigger: po śmierci osoby automatycznie kończ jego funkcję
CREATE OR REPLACE FUNCTION update_osoby_funkcje_jesli_smierc() 
   RETURNS TRIGGER AS $update_osoby_funkcje_jesli_smierc$
DECLARE
   wyd record;
   typ varchar(50);
   osoba int;
   data date;
BEGIN
   SELECT * FROM wydarzenia WHERE id = NEW.id_wydarzenie INTO wyd;
   osoba := NEW.id_osoba;
   typ := (SELECT nazwa FROM wydarzenia_typy WHERE id = wyd.typ);
   data := (SELECT data FROM wydarzenia WHERE id = NEW.id_wydarzenie);

   IF typ IN ('Narodziny', 'Zgon naturalny', 'Śmierć nienaturalna', 'Pogrzeb') THEN
      UPDATE osoby_funkcje
      SET data_zakonczenia=wyd.data
      WHERE id_osoba = osoba AND data_zakonczenia IS NULL;
   END IF;
END;
$update_osoby_funkcje_jesli_smierc$ LANGUAGE plpgsql;

CREATE TRIGGER update_osoby_funkcje_jesli_smierc BEFORE UPDATE ON osoby_wydarzenia
   FOR EACH ROW EXECUTE PROCEDURE update_osoby_funkcje_jesli_smierc();

--FUNKCJA: ile osób z danego rodu żyło na świecie
CREATE OR REPLACE FUNCTION ile_osob_zylo(num int)
   RETURNS int AS $$
DECLARE
   result int;
BEGIN
   result := (SELECT COUNT(*) FROM osoby_rody O WHERE O.id_rodu = num);
RETURN result;
END;
$$ LANGUAGE plpgsql;

-- WIDOK: protoplaści rodów
CREATE OR REPLACE VIEW protoplasci AS
   SELECT
      R.nazwa AS nazwa, O.imie ||' '||O.nazwisko AS "Imię i nazwisko"
   FROM
      rody R 
      JOIN osoby O ON R.zalozyciel = O.id
;

--TRIGGER: kraina musi miec typ 3
CREATE OR REPLACE FUNCTION check_miejsca_krainy()
   RETURNS TRIGGER AS $check_miejsca_krainy$
DECLARE
   typ1 int;
   typ2 int;
BEGIN
   typ1 := (SELECT typ FROM miejsca M WHERE M.id = NEW.id_miejsce);
   typ2 := (SELECT typ FROM miejsca M WHERE M.id = NEW.id_kraina);

   IF typ1 = 3 THEN
      RAISE EXCEPTION 'Pierwsza wartość nie może być krainą!';
   ELSEIF typ2 <> 3 THEN
      RAISE EXCEPTION 'Druga wartość musi być krainą!';
   ELSE return NEW;
   END IF;
END;
$check_miejsca_krainy$ LANGUAGE plpgsql;

CREATE TRIGGER check_miejsca_krainy BEFORE INSERT OR UPDATE ON miejsca_krainy
   FOR EACH ROW EXECUTE PROCEDURE check_miejsca_krainy();

--TRIGGER: stolica rodu musi być zamkiem lub miastem
CREATE OR REPLACE FUNCTION check_rody_stolice()
   RETURNS TRIGGER AS $check_rody_stolice$
DECLARE
   typ int;
BEGIN
   typ := (SELECT M.typ FROM miejsca M WHERE M.id = NEW.stolica);

   IF typ <> 1 AND typ <> 2 THEN
      RAISE EXCEPTION 'Stolica musi być miastem lub zamkiem!';
   ELSE return NEW;
   END IF;
END;
$check_rody_stolice$ LANGUAGE plpgsql;

CREATE TRIGGER check_rody_stolice BEFORE INSERT OR UPDATE ON rody
   FOR EACH ROW EXECUTE PROCEDURE check_rody_stolice();


-- Function: dla danej osoby zwraca wszystkich małżonków wraz z datami rozpoczęcia i zakończenia związku

CREATE OR REPLACE FUNCTION get_malzenstwa(osoba int)
   RETURNS TABLE(malzonek_id int, poczatek date, koniec date) AS $$
DECLARE
   malzonki_id int[];
BEGIN
   malzonki_id := (SELECT array_agg(os.id)
                     FROM get_wydarzenia(osoba, 'Małżeństwo') AS w
                     JOIN osoby_wydarzenia ow ON ow.id_wydarzenie = w.id
                     JOIN osoby os ON os.id = ow.id_osoba
                     WHERE os.id != osoba);
   IF array_length(malzonki_id, 1) = 0 THEN
      RETURN QUERY SELECT NULL;
   ELSE
      RETURN QUERY  
         SELECT a.malzonek_id, 
                a.poczatek,
                CASE WHEN a.koniec = '' THEN NULL ELSE a.koniec::date END
            FROM (
               SELECT 
                  unnest(malzonki_id) AS malzonek_id,
                  unnest((
                     SELECT array_agg(data)
                        FROM get_wydarzenia(osoba, 'Małżeństwo')
                  )) AS poczatek,
                  unnest((
                     (SELECT array_agg(data)
                        FROM get_wydarzenia(osoba, 'Rozwód', 'Zgon naturalny', 'Śmierć nienaturalna')
                     )::text[] || ''::text
                  )) AS koniec
                  LIMIT (array_length(malzonki_id, 1))
            ) a;
      END IF;
END;
$$ LANGUAGE plpgsql;

-- Function: zwraca wszystkich bękartów danej osoby - nieślubne dzieci

CREATE OR REPLACE FUNCTION get_bekarci(osoba int)
   RETURNS TABLE(id_dziecko int) AS $$
DECLARE
   dziecko record;
   dziecko_narodziny date;
   prawdziwy_rodzic int;
   malzonek int;
BEGIN
   FOR dziecko IN (SELECT * FROM get_potomkowie(osoba, 1) WHERE poziom > 0)
   LOOP
      dziecko_narodziny := (get_wydarzenia(dziecko.id, 'Narodziny')).data;
      prawdziwy_rodzic := (SELECT p.id 
                              FROM get_przodkowie(dziecko.id, 1) AS p
                              WHERE poziom > 0 AND p.id != osoba
                           );
      malzonek := (SELECT m.malzonek_id 
                     FROM get_malzenstwa(osoba) AS m
                     WHERE m.poczatek <= dziecko_narodziny 
                        AND coalesce(dziecko_narodziny <= m.koniec, true)
                  );
      IF malzonek IS NULL OR prawdziwy_rodzic != malzonek THEN
         RETURN QUERY SELECT dziecko.id;
      END IF;
   END LOOP;
   RETURN;
END;
$$ LANGUAGE plpgsql;


-- Funkcja get

create or replace function getId(tablename text, known_col_name text, known_value text) returns int
as
$$
DECLARE
    res int;
BEGIN
    EXECUTE format('SELECT id from %s WHERE %s = %s', tablename, known_col_name, quote_literal(known_value)) INTO res;
    return res;
END;
$$LANGUAGE PLPGSQL;

-- Widok pozwalający na wstawianie wydarzenia wraz z listą uczestników (oraz jego pokazywanie)

CREATE OR REPLACE VIEW wydarzenia_z_lista_uczestnikow AS
    SELECT w.id as id_wydarzenia, w.nazwa as nazwa_wydarzenia, w.data as data_wydarzenia, w.miejsce as miejsce_wydarzenia,
        w.opis as opis_wydarzenia, w.typ as typ_wydarzenia,  array_agg(o.imie || ' ' || o.nazwisko) as lista_uczestnikow
        FROM wydarzenia w 
        JOIN osoby_wydarzenia ow
            on w.id = ow.id_wydarzenie
        JOIN osoby o
            on ow.id_osoba = o.id
        GROUP BY w.id;

-- Funkcja: historia zmian panowania nad daną ziemią
CREATE OR REPLACE FUNCTION historia_zmian(mid int)
   RETURNS TABLE(kto varchar(50), kiedy date) AS $$

BEGIN
   RETURN QUERY
      SELECT R.nazwa, W.data
      FROM
         (wydarzenia W JOIN rody_wydarzenia RW ON W.id = RW.id_wydarzenie) JOIN rody R ON RW.id_rodu = R.id
      WHERE (W.typ = 13 OR W.typ = 17) AND W.miejsce = mid
      ORDER BY W.data;
END;
$$ LANGUAGE plpgsql;

CREATE RULE wydarzenia_z_lista_uczestnikow_on_insert AS ON INSERT TO wydarzenia_z_lista_uczestnikow
DO INSTEAD (
    INSERT INTO wydarzenia(data, nazwa, typ, opis, miejsce) VALUES
    (NEW.data_wydarzenia, NEW.nazwa_wydarzenia, NEW.typ_wydarzenia, NEW.opis_wydarzenia, NEW.miejsce_wydarzenia);
    INSERT INTO osoby_wydarzenia
        select getId('osoby', 'imie || ' ||  quote_literal(' ')  || ' || nazwisko', unnest(NEW.lista_uczestnikow)), getId('wydarzenia', 'nazwa', NEW.nazwa_wydarzenia);
);
END;


