--In a PL/SQL block, go through all customers with id from 1 to 6, displaying the name, first name, and if they made an order, 
--display its amount, and otherwise display a corresponding message:

DECLARE 
    v_nume clienti_restaurant.nume%TYPE;
    v_prenume clienti_restaurant.prenume%TYPE;
    v_cost_total comenzi_restaurant.cost_total%TYPE;
    v_cost_count NUMBER;
    v_id NUMBER := 1;
BEGIN
    FOR v_id IN 1..6 LOOP
        SELECT nume, prenume INTO v_nume, v_prenume
        FROM clienti_restaurant 
        WHERE cod_client = v_id;
        
        SELECT COUNT(*) INTO v_cost_count
        FROM comenzi_restaurant 
        WHERE cod_client = v_id;
        
        IF v_cost_count > 0 THEN
            SELECT cost_total INTO v_cost_total
            FROM comenzi_restaurant 
            WHERE cod_client = v_id;
            DBMS_OUTPUT.PUT_LINE('ID CLIENT: ' || v_id || ' NUME: ' || v_nume || ' ' || v_prenume || ' Cost comanda: ' || v_cost_total);
        ELSE
            DBMS_OUTPUT.PUT_LINE('ID CLIENT: ' || v_id || ' NUME: ' || v_nume || ' ' || v_prenume || ' nu a plasat o comanda.');
        END IF;
    END LOOP;
END;
/
INSERT INTO CLIENTI_RESTAURANT (COD_CLIENT, NUME, PRENUME, TELEFON, ADRESA, EMAIL) VALUES (6, 'Popescu', 'Ion', '0788123456', 'Piata Unirii, Nr. 7', 'ion.pop2002@email.com'); -- am inserat si un client fara comanda pt a se verifica 


--In a PL/SQL block, go through all the customers, displaying the name, first name, and if they have made a reservation, display
-- their number, and otherwise display a corresponding message:

DECLARE 
    v_nume clienti_restaurant.nume%TYPE;
    v_prenume clienti_restaurant.prenume%TYPE;
    v_nr_rezervari NUMBER;
    v_client_id NUMBER;
    v_max_client_id NUMBER;
BEGIN
    SELECT MAX(cod_client) INTO v_max_client_id FROM clienti_restaurant;
    v_client_id := 1; 
    WHILE v_client_id <= v_max_client_id LOOP
        SELECT nume, prenume INTO v_nume, v_prenume
        FROM clienti_restaurant 
        WHERE cod_client = v_client_id;
        
        SELECT COUNT(*) INTO v_nr_rezervari
        FROM rezervari 
        WHERE cod_client = v_client_id;
        
        IF v_nr_rezervari > 0 THEN
            DBMS_OUTPUT.PUT_LINE('ID CLIENT: ' || v_client_id || ' NUME: ' || v_nume || ' ' || v_prenume || ' Număr total de rezervări: ' || v_nr_rezervari);
        ELSE
            DBMS_OUTPUT.PUT_LINE('ID CLIENT: ' || v_client_id || ' NUME: ' || v_nume || ' ' || v_prenume || ' nu a efectuat nicio rezervare.');
        END IF;
        
        v_client_id := v_client_id + 1;
    END LOOP;
END;
/


--In a PL/SQL block, read a string variable that displays the total of orders according to the payment method (cash/card):

DECLARE
    v_total NUMERIC(10, 2);
    v_metoda_plata PLATI.METODA_PLATA%TYPE;
BEGIN
    v_metoda_plata := UPPER('&metoda_plata'); 

    CASE v_metoda_plata
        WHEN 'CASH' THEN
            SELECT SUM(SUMA) INTO v_total
            FROM PLATI
            WHERE METODA_PLATA = 'Cash';
            dbms_output.put_line('Totalul comenzilor platite cash este: ' || v_total);
        WHEN 'CARD' THEN
            SELECT SUM(SUMA) INTO v_total
            FROM PLATI
            WHERE METODA_PLATA = 'Card';
            dbms_output.put_line('Totalul comenzilor platite cu cardul este: ' || v_total);
        ELSE
            dbms_output.put_line('Metoda de plata introdusa nu este valida. Va rugam sa alegeti intre Cash si Card.');
    END CASE;
END;


--In a PL/SQL block to remove the products from the 'Pizza' category that were not ordered and show how many were deleted and 
--cancel the deletion:

BEGIN
  BEGIN

        DELETE FROM MENIURI m
        WHERE CATEGORIE = 'Pizza' AND NOT EXISTS (
            SELECT 1
            FROM DETALII_COMENZI d
            WHERE m.COD_PRODUS = d.COD_PRODUS
        );
        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' randuri sterse');
    END;
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' randuri afectate');
END;


--In a PL/SQL block to display the name of the first customer using a default cursor:

DECLARE
    v_nume_client CLIENTI_RESTAURANT.NUME%TYPE;
BEGIN
    SELECT NUME INTO v_nume_client FROM CLIENTI_RESTAURANT WHERE ROWNUM = 1;

    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Numele primului client este: ' || v_nume_client);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nu s-a găsit niciun client.');
    END IF;
END;
/


--Într-un bloc PL/SQL să se afișeze facturile care sunt mai mari decât 15:

DECLARE
    CURSOR factura_cursor IS
        SELECT COD_FACTURA, SUMA_TOTALA
        FROM FACTURI
        WHERE SUMA_TOTALA > 15;
    factura_rec factura_cursor%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Lista facturilor cu un cost total mai mare de 15 lei:');
    OPEN factura_cursor;
    LOOP
        FETCH factura_cursor INTO factura_rec;
        EXIT WHEN factura_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Factura ' || factura_rec.COD_FACTURA || ' are costul total: ' || factura_rec.SUMA_TOTALA || ' lei');
    END LOOP;
    CLOSE factura_cursor;
END;
/


--In a PL/SQL block to display reservations with at least 3 people:

DECLARE
    CURSOR rezervari_cursor IS
        SELECT COD_REZERVARE, NR_PERSOANE
        FROM REZERVARI
        WHERE NR_PERSOANE > 2;
    rezervari_rec rezervari_cursor%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Lista rezervarilor cu mai mult de trei persoane:');

    OPEN rezervari_cursor;
    LOOP
        FETCH rezervari_cursor INTO rezervari_rec;
        EXIT WHEN rezervari_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Rezervarea ' || rezervari_rec.COD_REZERVARE || ' are ' || rezervari_rec.NR_PERSOANE || ' persoane');
    END LOOP;
    CLOSE rezervari_cursor;
END;
/
