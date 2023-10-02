
--1. Mostrar a todos los empleados que se encuentran en el departamento de manufactura y de aseguramiento de la calidad.


--Utilizando la tabla HR.Employee. 
--Es decir, mostrando los empleados con la información de la tabla HR.Employee, 
--y condicionando la búsqueda por el nombre del grupo de los departamentos (GroupName) 
--para los valores “Manufacturing” (por manufactura) y “Quality Assurance” (por aseguramiento de la calidad): 
 


SELECT E.* ,  D.GroupName
FROM HumanResources.Employee as E, HumanResources.EmployeeDepartmentHistory as EDP, HumanResources.Department as D
WHERE (D.GroupName = 'Manufacturing' OR D.GroupName = 'Quality Assurance')
AND D.DepartmentID = EDP.DepartmentID
AND EDP.BusinessEntityID = E.BusinessEntityID;

--Utilizando la tabla P.Person, es decir, mostrando los empleados como personas con sus datos personales con la información 
--de la tabla Person.Person y condicionando la búsqueda por el nombre del grupo de los departamentos (GroupName)
-- para los valores “Manufacturing” (por manufactura) y “Quality Assurance” (por aseguramiento de la calidad): 

SELECT P.* , D.GroupName
FROM HumanResources.EmployeeDepartmentHistory as EDP, HumanResources.Department as D, Person.Person as P
WHERE (D.GroupName = 'Manufacturing' OR D.GroupName = 'Quality Assurance')
AND D.DepartmentID = EDP.DepartmentID
AND EDP.BusinessEntityID = P.BusinessEntityID;


--Seleccionando los datos del empleado de la tabla Person.Person 
--y condicionando la búsqueda por el nombre (Name) del departamento, para los valores “Production” (por manufactura)
 --y “Quality Assurance”  (por aseguramiento de la calidad):

SELECT P.BusinessEntityID, CONCAT(P.FirstName ,' ', P.LastName) AS 'Nombre_completo', D.Name AS 'Nombre_departamento'
FROM HumanResources.EmployeeDepartmentHistory as EDP, HumanResources.Department as D, Person.Person as P
WHERE (D.Name= 'Production' OR D.Name = 'Quality Assurance')
AND D.DepartmentID = EDP.DepartmentID
AND EDP.BusinessEntityID = P.BusinessEntityID;

--Seleccionando la información de la tabla HumanResources.Employee y utilizando INNER JOIN, condicionando a búsqueda por el nombre del grupo (GroupName):

SELECT E.*
FROM HumanResources.Employee AS E
INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH ON E.BusinessEntityID = EDH.BusinessEntityID
INNER JOIN HumanResources.Department AS D ON EDH.DepartmentID = D.DepartmentID
WHERE D.GroupName = 'Manufacturing' OR D.GroupName = 'Quality Assurance';



--2. Indicar el listado de los empleados del sexo masculino y que son solteros


--Seleccionando solamente la información de la tabla HumanResources.Employee:

SELECT * 
FROM HumanResources.Employee AS E
WHERE E.Gender = 'M' AND E.MaritalStatus = 'S';

--Seleccionando información de la tabla HumanResources.Employee y de la tabla Person.Person:

SELECT P.BusinessEntityID, CONCAT(P.FirstName, ' ', P.LastName) AS 'Nombre_completo', E.Gender, E.MaritalStatus
FROM HumanResources.Employee AS E, Person.Person AS P
WHERE E.BusinessEntityID = P.BusinessEntityID 
AND E.Gender = 'M' AND E.MaritalStatus = 'S';



--3. Empleados cuyo apellido sea con la letra “S”


--Con la función LEFT():

SELECT P.BusinessEntityID, CONCAT( P.FirstName, ' ',P.LastName ) AS 'Nombre_completo'
FROM HumanResources.Employee AS E, Person.Person AS P
WHERE E.BusinessEntityID = P.BusinessEntityID
AND LEFT(P.LastName, 1) = 'S';

--Con el operador LIKE:

SELECT P.BusinessEntityID, CONCAT( P.FirstName, ' ',P.LastName ) AS 'Nombre_completo'
FROM HumanResources.Employee AS E, Person.Person AS P
WHERE E.BusinessEntityID = P.BusinessEntityID
AND P.LastName LIKE 'S%';



--4. Los empleados que son del estado de Florida


--La consulta sería así:

SELECT P.BusinessEntityID,  CONCAT( P.FirstName, ' ',P.LastName ) AS 'Nombre_completo', SP.Name, E.*
FROM   HumanResources.Employee AS E, Person.Person AS P, Person.StateProvince AS SP, Person.BusinessEntityAddress AS BA, Person.Address AS A
WHERE E.BusinessEntityID = P.BusinessEntityID
AND P.BusinessEntityID = BA.BusinessEntityID
AND BA.AddressID = A.AddressID
AND A.StateProvinceID = SP.StateProvinceID
AND SP.Name = 'Florida';

--Pero no devuelve ninguna fila, entonces podría suponer que no hay empleados (de la tabla HR.Employee) de Florida,
-- pero si hay personas (de la tabla Person.Person) y direcciones (de la tabla Person.Address) cuyo estado es Florida: 

SELECT P.BusinessEntityID,  CONCAT( P.FirstName, ' ',P.LastName ) AS 'Nombre_completo', SP.Name
FROM   Person.Person AS P, Person.StateProvince AS SP, Person.BusinessEntityAddress AS BA, Person.Address AS A
WHERE P.BusinessEntityID = BA.BusinessEntityID
AND BA.AddressID = A.AddressID
AND A.StateProvinceID = SP.StateProvinceID
AND SP.Name = 'Florida';


--5. La suma de las ventas hechas por cada empleado, y agrupadas por año

--Opción 1 (ordenado por año por defecto):

select  BusinessEntityID, SUM(SalesQuota) as 'Total_ventas' , YEAR(QuotaDate) as 'Año'
from Sales.SalesPersonQuotaHistory
GROUP BY BusinessEntityID , YEAR(QuotaDate);

--Opción 2 (result set más completo y ordenado por empleado):

select sqh.BusinessEntityID, CONCAT(pp.FirstName, ' ', pp.LastName) as 'Nombre_completo' , SUM(sqh.SalesQuota) as 'Total_ventas' , YEAR(sqh.QuotaDate) as 'Año'
from Sales.SalesPersonQuotaHistory as sqh, Person.Person as pp
where sqh.BusinessEntityID = pp.BusinessEntityID
GROUP BY sqh.BusinessEntityID, pp.FirstName, pp.LastName , YEAR(QuotaDate)
ORDER BY sqh.BusinessEntityID;

--Opción 3 (= a opción 2 pero con inner join):

select pp.BusinessEntityID, CONCAT(pp.FirstName, ' ', pp.LastName) as 'Nombre_completo' , SUM(sqh.SalesQuota) as 'Total_ventas', YEAR(sqh.QuotaDate) as 'Año'
from Sales.SalesPersonQuotaHistory as sqh
inner join Person.Person as pp on sqh.BusinessEntityID = pp.BusinessEntityID
group by pp.BusinessEntityID, pp.FirstName, pp.LastName, YEAR(sqh.QuotaDate)
order by pp.BusinessEntityID;


--6. ¿Cuál es el producto más vendido?

--Opción 1 con ‘offset .. fetch first…’:

select ProductID, COUNT(ProductID) as 'Total_vendido'
from Sales.SalesOrderDetail
group by ProductID
order by Total_vendido desc
offset 0 rows fetch first 1 rows only;

--Opción 1 bis  (uniendo la tabla de productos para mostrar el nombre del producto):

select ss.ProductID, pp.Name, COUNT(ss.ProductID) as 'Total_vendido'
 from Sales.SalesOrderDetail as ss, Production.Product as pp
 where ss.ProductID = pp.ProductID
 group by ss.ProductID, pp.name
 order by Total_vendido desc
 offset 0 rows fetch first 1 rows only;

--Con otro SGBD usaría LIMIT 1 pero SQL Server no aceptaba LIMIT como una cláusula válida.

--Opción 2 con la cláusula TOP:

select top 1 ProductID, COUNT(ProductID) as 'Total_vendido'
from Sales.SalesOrderDetail
group by ProductID
order by Total_vendido desc;


--7. ¿Cuál es el producto menos vendido?

--Para este punto se realiza la misma consulta que en el anterior pero en vez de ordenar de forma descendente se ordena de forma ascendente. 

--Opción 1: 

select ProductID, COUNT(ProductID) as 'Total_vendido'
from Sales.SalesOrderDetail
group by ProductID
order by Total_vendido asc
offset 0 rows fetch first 1 rows only;

--Opción 2:

select top 1 ProductID, COUNT(ProductID) as 'Total_vendido'
from Sales.SalesOrderDetail
group by ProductID
order by Total_vendido asc; 

--Opción 2 bis (uniendo la tabla de productos para mostrar el nombre del producto):

select top 1 ss.ProductID, pp.Name, COUNT(ss.ProductID) as 'Total_vendido'
from Sales.SalesOrderDetail as ss, Production.Product as pp
where ss.ProductID = pp.ProductID
group by ss.ProductID, pp.name
order by Total_vendido asc; --No es necesario agregarle la cláusula asc porque group by por defecto ordena de forma ascendente. 


--8. Listado de productos por número de ventas ordenando de mayor a menor

select ss.ProductID, pp.Name, pp.ProductNumber, pp.ListPrice, COUNT(ss.ProductID) as 'Total_veces_vendido'
from Sales.SalesOrderDetail as ss, Production.Product as pp
where ss.ProductID = pp.ProductID 
group by ss.ProductID, pp.Name,  pp.ProductNumber, pp.ListPrice
order by Total_veces_vendido desc;

--La consulta la hice uniendo las tablas con un where, pero podría hacerse con un inner join. Idem para los puntos 6 y 7.


--9. Ventas por territorio

--Opción 1 (entendiendo por “ventas” el cantidad de ventas por territorio):

select count(sh.SalesOrderID) as 'Cantidad_ventas', sh.TerritoryID, t.Name
from Sales.SalesOrderHeader as sh, Sales.SalesTerritory t
where sh.TerritoryID = t.TerritoryID
group by sh.TerritoryID, t.Name;

--Opción 2 (entendiendo por “ventas” el valor total de las ventas por territorio): 

select sum(sd.LineTotal) as 'Total_ventas', sh.TerritoryID, t.Name
from Sales.SalesOrderHeader as sh, Sales.SalesTerritory t, Sales.SalesOrderDetail as sd
where sh.TerritoryID =  t.TerritoryID
and sh.SalesOrderID = sd.SalesOrderID
group by sh.TerritoryID, t.Name
order by Total_ventas desc;



