--To display the employee with id 1 and the one with id 10. To treat the error that occurred if there is no employee with this code:

DECLARE
    v_nume CLIENTI_RESTAURANT.NUME%TYPE;
BEGIN
    SELECT NUME INTO v_nume
    FROM CLIENTI_RESTAURANT
    WHERE COD_CLIENT = 1;
    DBMS_OUTPUT.PUT_LINE('Numele clientului cu codul 1: ' || v_nume);
    SELECT NUME INTO v_nume
    FROM CLIENTI_RESTAURANT
    WHERE COD_CLIENT = 20;
    DBMS_OUTPUT.PUT_LINE('Numele clientului cu codul 20: ' || v_nume);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu există client cu id 20!');
END;
/


--Create a SELECT query to select orders that use a user-specified payment method using an implicit exception to handle any errors 
--that may occur during block execution:

DECLARE
    v_metoda_plata VARCHAR2(20); 
BEGIN
    v_metoda_plata := 'Card';
    FOR order_rec IN (
        SELECT c.COD_COMANDA, c.DATA_COMANDA, c.COST_TOTAL
        FROM COMENZI_RESTAURANT c
        JOIN PLATI p ON c.COD_COMANDA = p.COD_COMANDA
        WHERE p.METODA_PLATA = v_metoda_plata
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Comanda cu codul ' || order_rec.COD_COMANDA ||
                             ', data: ' || order_rec.DATA_COMANDA ||
                             ', cost total: ' || order_rec.COST_TOTAL);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare: ' || SQLERRM);
END;
/


--To delete all entries from the menu table. This will lead to the appearance of the error code -2292, representing the violation 
--of the referential restriction. The SQLCODE and SQLERRM values ​​will be inserted into the restaurant_errors table:

CREATE TABLE erori_restaurant (
  utilizator VARCHAR2(40),
  data DATE,
  cod_eroare NUMBER(10),
  mesaj_eroare VARCHAR2(255)
);

DECLARE
  cod NUMBER;
  mesaj VARCHAR2(255);
  del_exception EXCEPTION;
  PRAGMA EXCEPTION_INIT(del_exception, -2292);

BEGIN
  DELETE FROM MENIURI; 
EXCEPTION
  WHEN del_exception THEN
    dbms_output.put_line('Nu puteti sterge produsul. Exista comenzi asignate lui.');
    cod := SQLCODE;
    mesaj := SQLERRM;
    INSERT INTO erori_restaurant VALUES(USER, SYSDATE, cod, mesaj);
END;
/
SELECT *FROM erori_restaurant;


--Change client with client_code 5. If no update occurs (SQL%ROWCOUNT attribute value is 0) or if another exception occurs (OTHERS 
--clause):

DECLARE
  invalid_client EXCEPTION;
BEGIN
  UPDATE CLIENTI_RESTAURANT
  SET NUME = 'Trusca', PRENUME = 'Ioana', TELEFON = '0766145543', ADRESA = 'STR. Florii, Nr. 7', EMAIL = 'trusca.miha@yahoo.com'
  WHERE COD_CLIENT = 5; 

  IF SQL%NOTFOUND THEN
    RAISE invalid_client;
  END IF;

EXCEPTION
  WHEN invalid_client THEN
    DBMS_OUTPUT.PUT_LINE('Nu există client cu acest ID.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A apărut o eroare! Nu s-au putut actualiza datele clientului.');
END;
/

SELECT *FROM clienti_restaurant;


--Change the total_amount from the invoices table whose code is 1. If no update occurs (SQL%ROWCOUNT attribute value is 0) or if 
--another exception occurs (OTHERS clause):

DECLARE
  invalid_factura EXCEPTION;
BEGIN
  UPDATE FACTURI
  SET SUMA_TOTALA = 1000 
  WHERE COD_FACTURA = 1; 

  IF SQL%NOTFOUND THEN
    RAISE invalid_factura;
  END IF;
  COMMIT; 
  DBMS_OUTPUT.PUT_LINE('Factura a fost actualizată cu succes.');
EXCEPTION
  WHEN invalid_factura THEN
    DBMS_OUTPUT.PUT_LINE('Nu există factură cu acest ID.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A apărut o eroare! Nu s-a putut actualiza factura.');
    ROLLBACK; 
END;
/

SELECT *FROM facturi;

