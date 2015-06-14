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

--Function: wszystkie osoby biorące udział w danym wydarzeniu
CREATE OR REPLACE FUNCTION kto_bral_udzial(id_wydarzenia numeric)
   RETURNS TABLE(
      "id osoby" numeric,
      "imie i nazwisko" varchar(100),
      "ród" varchar(50)
   ) AS $$
BEGIN
   RETURN QUERY 
      SELECT 
         id_osoba,
         (SELECT imie||' '||nazwisko FROM osoby WHERE id = id_osoba),
         (SELECT LAST(R.nazwa) FROM rody R JOIN osoby_rody O ON R.id = O.id_rodu WHERE R.id_osoba = id_osoba)
      FROM osoby_wydarzenia
      WHERE id_wydarzenie = id_wydarzenia;
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

END;
