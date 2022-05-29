-- a. nombres de las asignaturas que tienen mas de 12 alumnos aprobados en la 2 evaluacion

SELECT denoAsig
FROM asignaturas INNER JOIN (SELECT idAsig, COUNT(*)
                            FROM evaluaciones
                            WHERE nota > 5 AND eval = 2
                            GROUP BY idAsig
                            HAVING COUNT(*) > 12) AS T1
                ON asignaturas.idAsig ) T1.idAsig

-- b. que profesor (id) imparte clases a menos alumnos y a cuantos? en caso de empate, sacarlos todos



-- c. que asignaturas (id) se imparten en el IES los lunes a tercera?

SELECT LECCIONES.idAsig
FROM LECCIONES INNER JOIN (SELECT idAsig
                            FROM horario
                            WHERE dia = 'lunes' AND hora = 3) AS T1
                ON T1.idAsig = LECCIONES.idAsig

-- a2. Sacar listado con nombre autor y numero albumes diferentes que tiene, pero solo autores que tengan menos albumes que los
-- que tiene king africa

SELECT nomAutor, COUNT(nomAlbum) AS albumes
FROM ALBUMES


-- b2. Que cds de 74m de longitud tienen musica de mecano?

SELECT ALBUMES.cd
FROM ALBUMES INNER JOIN (SELECT cd 
                            FROM CDS
                            WHERE longitud = 74) AS T1
            ON T1.cd = ALBUMES.cd
WHERE nomAutor = 'Mecano'



