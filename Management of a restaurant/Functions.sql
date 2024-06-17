--Function that checks if a payment was made in cash, and if true, then returns true:

CREATE OR REPLACE FUNCTION verifica_plata_cash(
    p_cod_plata IN plati.cod_plata%TYPE
) RETURN BOOLEAN IS
    v_metoda_plata plati.metoda_plata%TYPE;
BEGIN
    SELECT metoda_plata INTO v_metoda_plata
    FROM plati
    WHERE cod_plata = p_cod_plata;
    IF v_metoda_plata = 'cash' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
/
DECLARE
    v_cod_plata plati.cod_plata%TYPE := 1; 
    v_plata_cash BOOLEAN;
BEGIN
    v_plata_cash := verifica_plata_cash(v_cod_plata);
    IF v_plata_cash THEN
        DBMS_OUTPUT.PUT_LINE('Plata este efectuata in numerar!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Plata nu este efectuata in numerar.');
    END IF;
END;
/

--A function that calculates the total amount of income made in a given period:

CREATE OR REPLACE FUNCTION calculeaza_venituri(
    p_data_start IN DATE,
    p_data_sfarsit IN DATE
) RETURN NUMBER IS
    v_venit_total NUMBER := 0;
BEGIN
    SELECT SUM(f.suma_totala)
    INTO v_venit_total
    FROM facturi f
    WHERE f.data_emitere BETWEEN p_data_start AND p_data_sfarsit;
    RETURN v_venit_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
    WHEN OTHERS THEN
        RETURN -1; 
END;
/
DECLARE
    v_venituri NUMBER;
BEGIN
    v_venituri := calculeaza_venituri(TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'));

    IF v_venituri >= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Veniturile in perioada specificata sunt: ' || v_venituri || ' lei');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Eroare la calcularea veniturilor');
    END IF;
END;
/


--A function that calculates how many bookings a particular customer has made:

CREATE OR REPLACE FUNCTION numar_rezervari_client(
    p_cod_client IN clienti_restaurant.cod_client%TYPE,
    p_data_start IN DATE,
    p_data_sfarsit IN DATE
) RETURN NUMBER IS
    v_numar_rezervari NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_numar_rezervari
    FROM rezervari
    WHERE cod_client = p_cod_client
    AND data_rezervare BETWEEN p_data_start AND p_data_sfarsit;

    RETURN v_numar_rezervari;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
    WHEN OTHERS THEN
        RETURN -1; 
END;
/
DECLARE
    v_numar_rezervari NUMBER;
BEGIN
    v_numar_rezervari := numar_rezervari_client(1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'));
    IF v_numar_rezervari >= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Numarul de rezervari in perioada specificata: ' || v_numar_rezervari);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Eroare in calcularea numarului de rezervari');
    END IF;
END;
/


--A function that calculates the total amount of invoices in a given period:

CREATE OR REPLACE FUNCTION calculeaza_suma_totala_facturi(
    p_data_start IN DATE,
    p_data_sfarsit IN DATE
) RETURN NUMBER IS
    v_suma_totala NUMBER := 0;
BEGIN
    SELECT SUM(f.suma_totala)
    INTO v_suma_totala
    FROM facturi f
    WHERE f.data_emitere BETWEEN p_data_start AND p_data_sfarsit;
    RETURN v_suma_totala;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
    WHEN OTHERS THEN
        RETURN -1; 
END;
/

DECLARE
    v_suma_totala NUMBER;
BEGIN
    v_suma_totala := calculeaza_suma_totala_facturi(TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'));

    IF v_suma_totala >= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Suma totala a facturilor in perioada specificata este: ' || v_suma_totala || ' lei');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Eroare in calcularea sumei totale a facturilor');
    END IF;
END;
/


--A function that displays the menu based on the specified category:

CREATE OR REPLACE FUNCTION afiseaza_meniu_dupa_categorie(
    p_categorie IN VARCHAR2
) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT cod_produs, denumire, pret
        FROM meniuri
        WHERE UPPER(categorie) = UPPER(p_categorie)
        AND disponibilitate = 'Disponibil';
    RETURN v_cursor;
END;
/
DECLARE
    v_categorie VARCHAR2(30) := 'Paste';
     v_meniu_cursor SYS_REFCURSOR;
    v_cod_produs MENIURI.COD_PRODUS%TYPE;
    v_denumire MENIURI.DENUMIRE%TYPE;
    v_pret MENIURI.PRET%TYPE;
BEGIN
    v_meniu_cursor := afiseaza_meniu_dupa_categorie(v_categorie);

    LOOP
        FETCH v_meniu_cursor INTO v_cod_produs, v_denumire, v_pret;
        EXIT WHEN v_meniu_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cod produs: ' || v_cod_produs || ', Denumire: ' || v_denumire || ', Pret: ' || v_pret);
    END LOOP;

    CLOSE v_meniu_cursor;
END;
/


