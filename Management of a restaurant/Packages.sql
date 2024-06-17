-A package that provides the functionality to calculate the total cost of an order based on the items ordered, using functions, 
--procedures, repetitive structures:

CREATE OR REPLACE PACKAGE RestaurantPackage AS
    TYPE MeniuTip IS TABLE OF MENIURI%ROWTYPE INDEX BY PLS_INTEGER;
    
    PROCEDURE adauga_articol_la_comanda(
        p_cod_produs IN MENIURI.COD_PRODUS%TYPE,
        p_cantitate IN NUMBER
    );
    
    FUNCTION calculeaza_cost_total_comanda RETURN NUMBER;
END RestaurantPackage;
/

CREATE OR REPLACE PACKAGE BODY RestaurantPackage AS
    v_comanda MeniuTip;
    
    PROCEDURE adauga_articol_la_comanda(
        p_cod_produs IN MENIURI.COD_PRODUS%TYPE,
        p_cantitate IN NUMBER
    ) IS
        v_articol MENIURI%ROWTYPE;
    BEGIN
        SELECT * INTO v_articol FROM MENIURI WHERE COD_PRODUS = p_cod_produs;
        
        FOR i IN 1..p_cantitate LOOP
            v_comanda(v_comanda.COUNT + 1) := v_articol;
        END LOOP;
    END adauga_articol_la_comanda;
    
    FUNCTION calculeaza_cost_total_comanda RETURN NUMBER IS
        v_cost_total NUMBER := 0;
    BEGIN
        FOR i IN 1..v_comanda.COUNT LOOP
            v_cost_total := v_cost_total + v_comanda(i).PRET;
        END LOOP;
        
        RETURN v_cost_total;
    END calculeaza_cost_total_comanda;
END RestaurantPackage;
/
DECLARE
    v_cost_total NUMBER;
BEGIN
    RestaurantPackage.adauga_articol_la_comanda(1, 2); 
    RestaurantPackage.adauga_articol_la_comanda(3, 1); 
    
    v_cost_total := RestaurantPackage.calculeaza_cost_total_comanda;
    
    DBMS_OUTPUT.PUT_LINE('Costul total al comenzii este: ' || v_cost_total);
END;
/


--A package to provide functionality for managing the invoice table containing: a procedure to automatically generate the invoice 
--number, a function to calculate the total amount of invoices issued in a certain time interval, and a cursor to iterate through 
--the invoices and perform specific operations.

CREATE OR REPLACE PACKAGE BODY FacturarePackage AS
    PROCEDURE genereaza_numar_factura(
        p_cod_comanda IN COMENZI_RESTAURANT.COD_COMANDA%TYPE,
        p_data_emitere IN DATE
    ) IS
        v_nr_factura FACTURI.COD_FACTURA%TYPE;
    BEGIN
        v_nr_factura := DBMS_RANDOM.VALUE(1000, 9999);
        
        INSERT INTO FACTURI (COD_COMANDA, DATA_EMITERE, COD_FACTURA)
        VALUES (p_cod_comanda, p_data_emitere, v_nr_factura);
        
        COMMIT;
    END genereaza_numar_factura;
    
    FUNCTION calculeaza_suma_facturi(
        p_data_inceput IN DATE,
        p_data_sfarsit IN DATE
    ) RETURN NUMBER IS
        v_suma_totala NUMBER := 0;
    BEGIN
         SELECT SUM(SUMA_TOTALA)
        INTO v_suma_totala
        FROM FACTURI
        WHERE DATA_EMITERE BETWEEN p_data_inceput AND p_data_sfarsit;
        
        RETURN v_suma_totala;
    END calculeaza_suma_facturi;
    
    FUNCTION get_facturi_cursor RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
        SELECT *
        FROM FACTURI;
        
        RETURN v_cursor;
    END get_facturi_cursor;
    
END FacturarePackage;
/
DECLARE
    v_cod_comanda COMENZI_RESTAURANT.COD_COMANDA%TYPE := 1;
    v_data_emitere DATE := SYSDATE; 
    v_data_inceput DATE := TO_DATE('2024-01-01', 'YYYY-MM-DD');
    v_data_sfarsit DATE := TO_DATE('2024-01-31', 'YYYY-MM-DD');
    v_suma_totala NUMBER;
    v_cursor SYS_REFCURSOR;
    v_factura FACTURI%ROWTYPE;
BEGIN
    FacturarePackage.genereaza_numar_factura(v_cod_comanda, v_data_emitere);
    v_suma_totala := FacturarePackage.calculeaza_suma_facturi(v_data_inceput, v_data_sfarsit);
    DBMS_OUTPUT.PUT_LINE('Suma totala a facturilor emise in intervalul specificat este: ' || v_suma_totala);
    v_cursor := FacturarePackage.get_facturi_cursor;
    LOOP
        FETCH v_cursor INTO v_factura;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Factura cu codul ' || v_factura.COD_FACTURA || ' pentru comanda ' || v_factura.COD_COMANDA || ' a fost emisa la data de ' || TO_CHAR(v_factura.DATA_EMITERE, 'DD-MON-YYYY'));
    END LOOP;
    CLOSE v_cursor;
    
END;
/


