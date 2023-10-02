--Traer el FirstName y LastName de Person.Person cuando el FirstName sea Mark.

select FirstName, LastName
from Person.Person
where FirstName = 'Mark';


--¿Cuántas filas hay dentro de Person.Person?

select COUNT(*) as 'Cantidad_filas_NOTNULL'
from Person.Person;


--Traer las 100 primeras filas de Production.Product donde el ListPrice no es 0

select top 100 *
from Production.Product
where ListPrice != 0;


--Traer todas las filas de de HumanResources.vEmployee donde los apellidos de los empleados empiecen con una letra inferior a “D”

--Opción 1:

select * 
from HumanResources.vEmployee
where LastName < 'D';

--Opción 2:

select * 
from HumanResources.vEmployee
where LEFT(LastName, 1) < 'D';


--¿Cuál es el promedio de StandardCost para cada producto donde StandardCost es mayor a $0.00? (Production.Product)

select ProductID, Name, AVG(StandardCost) as 'Promedio_StandardCost'
from Production.Product
where StandardCost > 0.00
group by ProductID, Name; --Con la sentencia 'GROUP BY ProductID' se obtiene un promedio para cada producto. 


--En la tabla Person.Person ¿cuántas personas están asociadas con cada tipo de persona (PersonType)?

select PersonType, COUNT(PersonType) as 'Cantidad'
from Person.Person
group by PersonType
order by Cantidad desc;


--Traer todas las filas y columnas de Person.StateProvince donde el CountryRegionCode sea CA.

select * 
from Person.StateProvince 
where CountryRegionCode = 'CA';


--¿Cuántos productos en Production.Product hay que son rojos (red) y cuántos que son negros (black)?

select Color, COUNT(Color) as 'Cantidad_productos'
from Production.Product
where Color = 'Red' OR Color = 'Black'
group by Color;


--¿Cuál es el valor promedio de Freight por cada venta? (Sales.SalesOrderHeader) donde la venta se dio en el TerriotryID 4?

select SalesOrderID, AVG(Freight) as 'Promedio_freight'
from Sales.SalesOrderHeader
where TerritoryID = 4
group by SalesOrderID;


--Traer a todos los clientes de Sales.vIndividualCustomer cuyo apellido sea Lopez, Martin o Wood, y sus nombres empiecen con cualquier letra entre la C y la L.

select *
from Sales.vIndividualCustomer
where (LastName = 'Lopez' or LastName = 'Martin' or LastName = 'Wood')
and (FirstName >= 'C' and FirstName <= 'L');


--Devolver el FirstName y LastName de Sales.vIndividualCustomer donde el apellido sea Smith, renombrar las columnas en español.

select FirstName as 'Nombre', LastName as 'Apellido'
from Sales.vIndividualCustomer
where LastName = 'Smith';


--Usando Sales.vIndividualCustomer traer a todos los clientes que tengan el CountryRegionCode de Australia ó todos los clientes que tengan un celular (Cell) 
--y en EmailPromotion sea 0.

select *
from Sales.vIndividualCustomer
where (CountryRegionName = 'Australia')
or (PhoneNumberType = 'Cell' and EmailPromotion = 0);


--¿Qué tan caro es el producto más caro, por ListPrice, en la tabla Production.Product?

--Opción 1:
select MAX(ListPrice) as 'Producto_mas_caro'
from Production.Product;

--Opción 2:
select AVG(ListPrice) as 'Precio_promedio', MAX(ListPrice) as 'Mayor_precio', 
	   (select  (MAX(ListPrice) - AVG(ListPrice) ) from Production.Product)  as 'Diferencia'
from Production.Product;
 

--¿Cuáles son las ventas por territorio para todas las filas de Sales.SalesOrderHeader?
-- Traer sólo los territorios que se pasen de $10 millones en ventas históricas, traer el total de las ventas y el TerritoryID.

select TerritoryID, SUM(TotalDue) as 'Total_ventas'
from Sales.SalesOrderHeader
group by TerritoryID
having sum(TotalDue) > 10000000;


--Usando la query anterior, hacer un join hacia Sales.SalesTerritory y reemplazar el TerritoryID con el nombre del territorio. [NUEVO]

select t.Name , SUM(h.TotalDue) as 'Total_ventas'
from Sales.SalesOrderHeader as h
inner join Sales.SalesTerritory as t on h.TerritoryID = t.TerritoryID
group by h.TerritoryID, t.Name
having sum(h.TotalDue) > 10000000;


--Traer todos los empleados de HumanResources.vEmployeeDepartment que sean del departamento de “Executive”, “Tool Design”, y “Engineering”. 
--Cuáles son las dos formas de hacer esta consulta.

--Forma 1 (con el operador OR):

select * 
from HumanResources.vEmployeeDepartment
where Department = 'Executive' or Department = 'Tool Design' or Department = 'Engineering';

--Forma 2 (con el operador IN):

select *
from HumanResources.vEmployeeDepartment
where Department in ( 'Executive', 'Tool Design', 'Engineering');


--Usando HumanResources.vEmployeeDepartment traer a todos los empleados que hayan empezado entre el primero de Julio del 2000 y el 30 de Junio del 2002.
-- Hay dos posibilidades para hacer esta consulta. Hacer ambas.

--La menor fecha de comienzo de los empleados es 2006 según la ste consulta:
select min(StartDate)
from HumanResources.vEmployeeDepartment;

--Entonces busqué entre el 2010 y el 2012.

--Opción 1 con el operador AND:

select *
from HumanResources.vEmployeeDepartment
where StartDate > '2010-07-01' and StartDate < '2012-06-30' ;

--Opción 2 con el operador BETWEEN:

select *
from HumanResources.vEmployeeDepartment
where StartDate between '2010-07-01' and '2012-06-30'


--Traer todas las filas de Sales.SalesOrderHeader donde exista un vendedor (SalesPersonID) 

select *
from Sales.SalesOrderHeader
where SalesPersonID is not null;

--¿Cuántas filas en Person.Person no tienen NULL en MiddleName?

select count(MiddleName) as 'Cantidad_filas_NOT_NULL'
from Person.Person;
--La función COUNT() cuenta sólo valores no nulos, es decir,
-- no tiene en cuenta los valores NULL por eso no hace falta especificar la condición de NOT NULL con una sentencia WHERE. 


--Traer SalesPersonID y TotalDue de Sales.SalesOrderHeader por todas las ventas que no tienen valores vacíos en SalesPersonID y TotalDue excede $70000

select SalesPersonID, TotalDue
from Sales.SalesOrderHeader
where SalesPersonID is not null and TotalDue > 70000;


--Traer a todos los clientes de Sales.vIndividualCustomer cuyo apellido empiece con R

--Opción 1 con el operador LIKE:

select * 
from Sales.vIndividualCustomer 
where LastName like 'R%';

--Opción 2 con la función LEFT():

select * 
from Sales.vIndividualCustomer 
where LEFT(LastName,1 ) = 'R';


--Traer a todos los clientes de Sales.vIndividualCustomer cuyo apellido termine con R.

--Opción 1 con el operador LIKE:

select * 
from Sales.vIndividualCustomer 
where LastName like '%r';

--Opción 2 con la función RIGHT():

select * 
from Sales.vIndividualCustomer 
where RIGHT(LastName,1 ) = 'r';


--Usando Production.Product encontrar cuántos productos están asociados con cada color. Ignorar las filas donde el color no tenga datos (NULL). 
--Luego de agruparlos, devolver sólo los colores que tienen al menos 20 productos en ese color.

select Color, count(Color)
from Production.Product
where Color is not null
group by Color
having count(Color) >= 20;


--Hacer un join entre Production.Product y Production.ProductInventory sólo cuando los productos aparecen en ambas tablas. Hacerlo sobre el ProductID. 
--Production.ProductInventory tiene la cantidad de cada producto, si se vende cada producto con un ListPrice mayor a cero, ¿cuánto dinero se ganaría? 

select p.ProductID, p.Name,
       SUM(p.ListPrice * i.Quantity)  as 'Dinero_total_ventas'
from Production.Product as p
inner join Production.ProductInventory as i on p.ProductID = i.ProductID
where p.ListPrice > 0.00
group by  p.ProductID, p.Name;


--Traer FirstName y LastName de Person.Person.
-- Crear una tercera columna donde se lea “Promo 1” si el EmailPromotion es 0, “Promo 2” si el valor es 1 o “Promo 3” si el valor es 2

select FirstName, LastName,
case 
	when EmailPromotion = 0 then 'Promo 1'
	when EmailPromotion = 1 then 'Promo 2'
	when EmailPromotion = 2 then 'Promo 3' 
end as 'Tipo_promo'
from Person.Person ;


--Traer el BusinessEntityID y SalesYTD de Sales.SalesPerson, juntarla con Sales.SalesTerritory de tal manera que Sales.SalesPerson devuelva valores 
--aunque no tenga asignado un territorio. Traes el nombre de Sales.SalesTerritory.

select sp.BusinessEntityID, sp.SalesYTD, sp.TerritoryID, st.Name
from Sales.SalesPerson as sp
left join Sales.SalesTerritory as st on sp.TerritoryID = st.TerritoryID;


--Usando el ejemplo anterior, vamos a hacerlo un poco más complejo. Unir Person.Person para traer también el nombre y apellido. 
--Sólo traer las filas cuyo territorio sea “Northeast” o “Central”.

select sp.BusinessEntityID, p.FirstName, p.LastName, sp.SalesYTD, sp.TerritoryID, st.Name
from Sales.SalesPerson as sp
inner join Person.Person as p on sp.BusinessEntityID = p.BusinessEntityID
left join Sales.SalesTerritory as st on sp.TerritoryID = st.TerritoryID
where (st.Name = 'Northeast' or st.Name = 'Central');


--Usando Person.Person y Person.Password hacer un INNER JOIN trayendo FirstName, LastName y PasswordHash.

select per.FirstName, per.LastName, pas.PasswordHash
from Person.Person as per
inner join Person.Password as pas on per.BusinessEntityID = pas.BusinessEntityID;


--Traer el título de Person.Person. Si es NULL devolver “No hay título”.

select isnull(Title, 'No tiene') as 'Título'
from Person.Person;
--Elegí devolver ‘No tiene’ porque se ve que la columna tiene una cantidad muy limitada de caracteres. 


--Si MiddleName es NULL devolver FirstName y LastName concatenados, con un espacio de por medio.
-- Si MiddeName no es NULL devolver FirstName, MiddleName y LastName concatenados, con espacios de por medio.

select BusinessEntityID,
	case 
		when MiddleName is null then concat(FirstName ,' ', LastName)
		when MiddleName is not null then Firstname + ' ' + MiddleName + ' '+ LastName
	end as 'Nombre_completo'
from Person.Person
order by BusinessEntityID;

--Tuve que mostrar y ordenar por el BusinessEntityID porque me traía todas las filas mezcladas. 


--Usando Production.Product si las columnas MakeFlag y FinishedGoodsFlag son iguales, que devuelva NULL

Select ProductID, Name, ProductNumber, Makeflag, FinishedGoodsFlag,
      case
		when MakeFlag = FinishedGoodsFlag then null
		else MakeFlag
	  end as 'Resultado'
from Production.Product as pp;


--Usando Production.Product si el valor en color no es NULL devolver “Sin color”. 
--Si el color sí está, devolver el color. Se puede hacer de dos maneras, desarrollar ambas.

--Opción 1 con la función ISNULL():

select ProductID, Name, ProductNumber, isnull(Color, 'Sin color') as 'Color'
from Production.Product;

--Opción 2 con la cláusula CASE:

select ProductID, Name, ProductNumber,
	case 
		when Color is null then 'Sin color'
		else Color
	end as 'Color'
from Production.Product;

