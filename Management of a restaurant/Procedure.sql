--The modify_reservation procedure receives two parameters: p_reservation_code and p_person_number and changes the number of persons 
--in that reservation with the given number:

CREATE OR REPLACE PROCEDURE modifica_rezervare(p_cod_rezervare IN NUMERIC, p_nr_persoane IN NUMER) AS
BEGIN
    UPDATE REZERVARI
    SET NR_PERSOANE = p_nr_persoane
    WHERE COD_REZERVARE = p_cod_rezervare;
END;
/
CALL modifica_rezervare(1, 5);
SELECT* FROM rezervari;


--The procedure by which a customer's phone number is changed based on id:

CREATE OR REPLACE PROCEDURE modifica_telefon_client(
    p_cod_client NUMBER,
    p_nou_telefon VARCHAR2
) AS
BEGIN
    UPDATE CLIENTI_RESTAURANT
    SET TELEFON = p_nou_telefon
    WHERE COD_CLIENT = p_cod_client;
END;
/
CALL modifica_telefon_client(2, '0723456789');
SELECT* FROM clienti_restaurant;

--Cancellation of a reservation based on reservation_code:

CREATE OR REPLACE PROCEDURE anuleaza_rezervare(
    p_cod_rezervare NUMERIC
) AS
BEGIN
    DELETE FROM REZERVARI
    WHERE COD_REZERVARE = p_cod_rezervare;
END;
/
CALL anuleaza_rezervare(4);
SELECT* FROM rezervari;


--Increase by 10 the amount of the invoice that is of the "cash" type:

CREATE OR REPLACE PROCEDURE actualizeaza_facturi_cash AS
BEGIN
    UPDATE FACTURI
    SET SUMA_TOTALA = SUMA_TOTALA + 10
    WHERE COD_COMANDA IN (
        SELECT COD_COMANDA
        FROM PLATI
        WHERE METODA_PLATA = 'Cash'
    );
END;
/


CALL actualizeaza_facturi_cash();
SELECT * FROM FACTURI WHERE COD_COMANDA IN (SELECT COD_COMANDA FROM PLATI WHERE METODA_PLATA = 'Cash');
