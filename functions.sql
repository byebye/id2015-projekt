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

END;