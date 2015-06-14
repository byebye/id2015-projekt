BEGIN;

-- Trigger: zapewnia, że stolica przy wstawianiu do tabeli 'ziemie' ma typ 'Miasto'

CREATE OR REPLACE FUNCTION check_stolica_miasto() 
   RETURNS trigger AS $check_stolica_miasto$
BEGIN
   IF 'Miasto' = (SELECT typy.nazwa
                     FROM miejsca
                     JOIN miejsca_typy typy ON typy.id = miejsca.typ
                     WHERE miejsca.id = NEW.stolica
                  ) THEN
      RETURN NEW;
   ELSE
      RAISE EXCEPTION 'Stolica musi mieć typ "Miasto"';
   END IF; 
END;
$check_stolica_miasto$ LANGUAGE plpgsql;

CREATE TRIGGER check_stolica_miasto BEFORE INSERT ON ziemie
   FOR EACH ROW EXECUTE PROCEDURE check_stolica_miasto();

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

CREATE OR REPLACE FUNCTION get_wydarzenia(osoba int, wydarzenie_typ text) 
   RETURNS table(id int, data date, nazwa varchar(100), typ int, opis varchar(300), miejsce int, czy_potwierdzone bool) AS $$
BEGIN
   RETURN QUERY
      SELECT wyd.*
         FROM osoby_wydarzenia os_wyd
         JOIN wydarzenia wyd ON wyd.id = id_wydarzenie
         WHERE id_osoba = osoba
         AND wyd.typ = (SELECT typy.id 
                           FROM wydarzenia_typy typy 
                           WHERE typy.nazwa = wydarzenie_typ
                        )
   ;
END;
$$ LANGUAGE plpgsql;

-- Function: dla danej osoby zwraca datę śmierci

CREATE OR REPLACE FUNCTION get_data_smierci(osoba int) 
   RETURNS table(data date) AS $$
BEGIN
   RETURN QUERY
      SELECT get_wydarzenia.data FROM get_wydarzenia(osoba, 'Zgon naturalny')
      UNION 
      SELECT get_wydarzenia.data FROM get_wydarzenia(osoba, 'Śmierć nienaturalna');
END;
$$ LANGUAGE plpgsql;

-- Function: sprawdza, czy dana osoba żyła o podanej dacie

CREATE OR REPLACE FUNCTION czy_byla_zywa(osoba int, data date)
   RETURNS bool AS $$
DECLARE
   narodziny date;
   smierc    date;
BEGIN
   narodziny = (SELECT data FROM get_wydarzenia(osoba, 'Narodziny'));
   smierc = (SELECT data FROM get_data_smierci(osoba));
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
      RETURN czy_byla_zywa(rodzic, dziecko_narodziny - interval '9 months') AND czy_byla_zywa(rodzic, dziecko_narodziny);
   ELSE
      RETURN czy_byla_zywa(rodzic, dziecko_narodziny - interval '9 months');
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
   matka  = (SELECT FROM osoby WHERE id = NEW.matka_biol);
   ojciec = (SELECT FROM osoby WHERE id = NEW.ojciec_biol);
   IF matka.plec != 'Kobieta' OR ojciec.plec != 'Mężczyzna' THEN
      RAISE EXCEPTION 'Rodzice muszą być odpowiedniej płci';
   ELSIF !czy_moze_byc_rodzicem(matka.id, NEW.id) OR !czy_moze_byc_rodzicem(ojciec.id, NEW.id) THEN
      RAISE EXCEPTION 'Rodzice muszą być starsi i żywi (tylko matka) w trakcie narodzin dziecka i jego poczęcia (oboje)';
   ELSE
      RETURN NEW;
   END IF; 
END;
$check_rodzice$ LANGUAGE plpgsql;

CREATE TRIGGER check_rodzice BEFORE INSERT ON osoby
   FOR EACH ROW EXECUTE PROCEDURE check_rodzice();

END;

--Function: wszystkie osoby biorące udział w danym wydarzeniu
CREATE OR REPLACE FUNCTION kto_bral_udzial(id_wydarzenia numeric)
   RETURNS TABLE(
      'id osoby' numeric,
      'imie i nazwisko' varchar(100),
      'ród' varchar(50)
   )AS$$
      BEGIN
         RETURN QUERY 
            SELECT 
               id_osoba,
               (SELECT imie||' '||nazwisko FROM osoby WHERE id = id_osoba),
               (SELECT LAST(R.nazwa) FROM rody R JOIN osoby_rody O ON R.id = O.id_rodu WHERE R.id_osoba = id_osoba)
            FROM osoby_wydarzenia
            WHERE id_wydarzenie = id_wydarzenia;
      END;
$$ LANGUAGE 'plpgsql';


