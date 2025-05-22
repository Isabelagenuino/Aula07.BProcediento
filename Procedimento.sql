/*
Questão 01. Crie um procedimento denominado salaryHistogram, que distribua as frequências dos salários dos Professores em intervalos (Histograma).
*/
CREATE PROCEDURE dbo.salaryHistogram @qtdIntervalo INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @salarioMinimo AS NUMERIC (10,2);
	DECLARE @salarioMaximo AS NUMERIC (10,2);
	DECLARE @intervalo AS NUMERIC (10,2);
	
SELECT @salarioMinimo = min(salary) FROM instructor;
SELECT @salarioMaximo = max(salary) FROM instructor;
SET @intervalo = (@salarioMaximo-@salarioMinimo)/@qtdIntervalo;

CREATE TABLE #Histograma(
valorMinimo NUMERIC(10,2),
valorMaximo NUMERIC(10,2),
total INT
);

DECLARE @i INT = 0;
WHILE @i < @qtdIntervalo
BEGIN
	DECLARE @valorMin NUMERIC (10,2);
	SET @valorMin = @salarioMinimo + (@i * @intervalo);
	DECLARE @valorMax NUMERIC (10,2);
	SET @valorMax = @salarioMinimo + ((@i+1)* @intervalo);

INSERT INTO #Histograma (valorMinimo,valorMaximo,total) SELECT @valorMin, @valorMax, count(*) FROM instructor WHERE salary >= @valorMin AND salary < @valorMax; 

SET @i = @i+1;
END

UPDATE #Histograma SET total = total + (SELECT COUNT(*) FROM instructor WHERE salary = @salarioMaximo) WHERE valorMaximo = @salarioMaximo;
SELECT * FROM #Histograma;
DROP TABLE #Histograma;
END

