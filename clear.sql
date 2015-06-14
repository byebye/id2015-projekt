-- Skrypt usuwający wszystkie utworzone tabele --
DROP TABLE IF EXISTS dokumenty_typy CASCADE;
DROP TABLE IF EXISTS dokumenty CASCADE;
DROP TABLE IF EXISTS miejsca_typy CASCADE;
DROP TABLE IF EXISTS miejsca CASCADE;
DROP TABLE IF EXISTS miejsca_dokumenty CASCADE;
DROP TABLE IF EXISTS wydarzenia_typy CASCADE;
DROP TABLE IF EXISTS wydarzenia CASCADE;
DROP TABLE IF EXISTS wydarzenia_dokumenty CASCADE;
DROP TABLE IF EXISTS kolory CASCADE;
DROP TABLE IF EXISTS religie CASCADE;
DROP TABLE IF EXISTS religie_dokumenty CASCADE;
DROP TABLE IF EXISTS funkcje CASCADE;
DROP TABLE IF EXISTS osoby CASCADE;
DROP TABLE IF EXISTS rody CASCADE;
DROP TABLE IF EXISTS rody_dokumenty CASCADE;
DROP TABLE IF EXISTS rody_wydarzenia CASCADE;
DROP TABLE IF EXISTS rody_zaleznosci CASCADE;
DROP TABLE IF EXISTS osoby_rody CASCADE;
DROP TABLE IF EXISTS osoby_funkcje CASCADE;
DROP TABLE IF EXISTS osoby_dokumenty CASCADE;
DROP TABLE IF EXISTS osoby_wydarzenia CASCADE;
DROP TABLE IF EXISTS rody_miejsca;
DROP TABLE IF EXISTS miejsca_krainy;
DROP FUNCTION IF EXISTS check_stolica_miasto () CASCADE;
DROP TRIGGER IF EXISTS check_stolica_miasto ON ziemie CASCADE;
DROP FUNCTION IF EXISTS set_dokument_wiarygodny () CASCADE;
DROP TRIGGER IF EXISTS set_dokument_wiarygodny ON dokumenty CASCADE;
DROP FUNCTION IF EXISTS get_wydarzenia (int, text) CASCADE;
DROP FUNCTION IF EXISTS get_data_smierci (int) CASCADE;
DROP FUNCTION IF EXISTS czy_byla_zywa (int, date) CASCADE;
DROP FUNCTION IF EXISTS czy_moze_byc_rodzicem (int, int) CASCADE;
DROP FUNCTION IF EXISTS check_rodzice () CASCADE;
DROP TRIGGER IF EXISTS check_rodzice ON osoby CASCADE;
DROP TRIGGER IF EXISTS check_rody_stolice ON rody CASCADE;
DROP FUNCTION IF EXISTS get_przodkowie (int, int) CASCADE;
DROP FUNCTION IF EXISTS kto_bral_udzial (numeric) CASCADE;
