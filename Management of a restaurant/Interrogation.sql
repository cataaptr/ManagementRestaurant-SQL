--Display order lists and total amount for each customer, sorted by total amount in descending order:
SELECT C.COD_CLIENT, C.NUME, C.PRENUME, SUM(COM.COST_TOTAL) AS SUMA_TOTALA
FROM CLIENTi C
JOIN COMENZI COM ON C.COD_CLIENT = COM.COD_CLIENT
GROUP BY C.COD_CLIENT, C.NUME, C.PRENUME
ORDER BY SUMA_TOTALA DESC;

--Display payments for orders placed in the last 30 days:
SELECT P.*
FROM PLATI P
JOIN COMENZI C ON P.COD_COMANDA = C.COD_COMANDA
WHERE C.DATA_COMANDA >= SYSDATE - 30;

--Display data about bookings made in a specific month:
SELECT R.*
FROM REZERVARI R
WHERE TO_CHAR(R.DATA_REZERVARE, 'YYYY-MM') = '2024-01';

--Display customers whose names start with the letter "P":
SELECT *FROM CLIENTI
WHERE UPPER(SUBSTR(NUME, 1, 1)) = 'P';

--Display the first names of customers who do not have a phone number:
SELECT PRENUME FROM CLIENTI WHERE TELEFON IS NULL;

--Display payment details along with payment method and customer information:
SELECT P.COD_PLATA, P.DATA_PLATA, P.METODA_PLATA, P.SUMA,
C.COD_COMANDA, C.DATA_COMANDA, C.COST_TOTAL,
CL.NUME AS NUME_CLIENT, CL.PRENUME AS PRENUME_CLIENT, CL.TELEFON, CL.ADRESA, CL.EMAIL
FROM PLATI P
JOIN COMENZI C ON P.COD_COMANDA = C.COD_COMANDA
JOIN CLIENTI CL ON C.COD_CLIENT = CL.COD_CLIENT;

--Display the total amount collected for each distinct payment method:
SELECT METODA_PLATA, SUM(SUMA) AS TOTAL_INCASAT
FROM PLATI
GROUP BY METODA_PLATA;

--Display the average number of people in a booking and excluding bookings that have less than 2 people:
SELECT DATA_REZERVARE, AVG(NR_PERSOANE) AS NUMAR_MEDIU_PERSOANE
FROM REZERVARI
GROUP BY DATA_REZERVARE
HAVING AVG(NR_PERSOANE) >= 2;

--Display the total amount of costs for each order, excluding orders that have a total cost of less than 30 monetary units:
SELECT COD_COMANDA, SUM(COST_TOTAL) AS TOTAL_COST
FROM COMENZI
GROUP BY COD_COMANDA
HAVING SUM(COST_TOTAL) >= 30;

--Display product names and price by adding "Pret:" in front of the price value:
SELECT DENUMIRE, 'Pret: ' || TO_CHAR(PRET, '9999.99') AS PRET_FORMATAT
FROM MENIURI;

--Display order data showing the corresponding month:
SELECT DATA_COMANDA, EXTRACT(MONTH FROM DATA_COMANDA) AS LUNA_COMANDA
FROM COMENZI;

--Display all orders and all reservations (union):
SELECT COD_COMANDA, 'Comanda' AS TIP_OPERATIE FROM COMENZI
UNION
SELECT COD_REZERVARE, 'Rezervare' AS TIP_OPERATIE FROM REZERVARI;

--Display all the products in the menu that are available and all the products that are not available (difference):
SELECT DENUMIRE, 'Disponibil' AS DISPONIBILITATE FROM MENIURI WHERE DISPONIBILITATE = 'Disponibil'
MINUS
SELECT DENUMIRE, 'Indisponibil' AS DISPONIBILITATE FROM MENIURI WHERE DISPONIBILITATE = 'Indisponibil';

--Display all orders that have an associated payment (intersection):
SELECT COD_COMANDA FROM COMENZI
INTERSECT
SELECT COD_COMANDA FROM PLATI;

--Display virtual table with all commands:
CREATE VIEW V_COMENZI_DETALII AS
SELECT C.COD_COMANDA, C.DATA_COMANDA, C.COST_TOTAL,
DC.COD_DETALIU, DC.COD_PRODUS, DC.CANTITATE, DC.PRET_UNITAR
FROM COMENZI C
JOIN DETALII_COMANDA DC ON C.COD_COMANDA = DC.COD_COMANDA;

--Create synonym for CUSTOMER table:
CREATE SYNONYM CUMPARATOR FOR CLIENTI;

--Creation and deletion of index on the COMENZI table:
CREATE INDEX IDX_COMANDA_COD_CLIENT ON COMENZI(COD_CLIENT);
DROP INDEX IDX_COMANDA_COD_CLIENT;

--Creating a sequence to ensure the uniqueness of the primary key
in the FACTURI table:
CREATE SEQUENCE SEQ_COD_FACTURI
START WITH 1
INCREMENT BY 1
MAXVALUE 999999
NOCYCLE;

--Display the number of people using CASE:
SELECT NR_PERSOANE,
CASE
WHEN NR_PERSOANE = 1 THEN 'Singur'
WHEN NR_PERSOANE = 2 THEN 'Dublu'
ELSE 'Grup'
END AS TIP_REZERVARE
FROM REZERVARI;

--Display products that are part of the "Pasta" or "Pizza" category:
SELECT COD_PRODUS, DENUMIRE
FROM MENIURI
WHERE CATEGORIE IN ('Pizza', 'Paste');