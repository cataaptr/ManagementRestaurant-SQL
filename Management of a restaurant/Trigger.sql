--A trigger is created to prevent an employee from exceeding a maximum salary limit:

CREATE OR REPLACE TRIGGER restrict_pret
BEFORE INSERT OR UPDATE ON meniuri
FOR EACH ROW
BEGIN
    
    IF :NEW.pret > 1000 THEN
        RAISE_APPLICATION_ERROR(-20203, 'Pretul nu poate depasi valoarea maxima permisa de 1000');
    END IF;
END;
/
INSERT INTO meniuri (cod_produs, denumire, categorie, pret, disponibilitate) 
VALUES (2, 'Truffle Pasta', 'Pasta', 1500, 'Disponibil');




--A trigger is created that will ensure that RESERVATION_DATE is in the future, that is, a reservation cannot be made for a date 
--earlier than the current date:

CREATE OR REPLACE TRIGGER check_reservation_date
BEFORE INSERT OR UPDATE ON rezervari
FOR EACH ROW
BEGIN
    IF :NEW.data_rezervare < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20205, 'Data rezervarii trebuie să fie în viitor.');
    END IF;
END;
/
INSERT INTO rezervari (cod_rezervare, cod_client, data_rezervare, nr_persoane)
VALUES (1, 2, TO_DATE('2023-05-01', 'YYYY-MM-DD'), 4);



--A trigger is created that will ensure that the quantity value is always greater than zero:

CREATE OR REPLACE TRIGGER check_quantity_positive
BEFORE INSERT OR UPDATE ON detalii_comenzi
FOR EACH ROW
BEGIN
    IF :NEW.cantitate <= 0 THEN
        RAISE_APPLICATION_ERROR(-20206, 'Cantitatea trebuie sa fie mai mare decat zero.');
    END IF;
END;
/

INSERT INTO detalii_comenzi (cod_detaliu, cod_comanda, cod_produs, cantitate, pret_unitar)
VALUES (2, 2, 3, 0, 15);

INSERT INTO detalii_comenzi (cod_detaliu, cod_comanda, cod_produs, cantitate, pret_unitar)
VALUES (3, 2, 3, -1, 15);
