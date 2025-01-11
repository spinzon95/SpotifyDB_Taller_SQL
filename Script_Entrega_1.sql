
-- Creación de la base de datos
CREATE DATABASE SpotifyDB;
USE SpotifyDB;

-- Tabla: Artistas
CREATE TABLE Artistas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    genero VARCHAR(50)
);

-- Tabla: Álbumes
CREATE TABLE Albumes (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    anio INT,
    id_artista INT,
    FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista) ON DELETE CASCADE
);

-- Tabla: Canciones
CREATE TABLE Canciones (
    id_cancion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    id_album INT,
    duracion_ms INT,
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album) ON DELETE CASCADE
);

-- Tabla: Características
CREATE TABLE Caracteristicas (
    id_cancion INT PRIMARY KEY,
    energia DECIMAL(3,2),
    bailabilidad DECIMAL(3,2),
    instrumentalidad DECIMAL(3,2),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- Tabla: Popularidad
CREATE TABLE Popularidad (
    id_cancion INT PRIMARY KEY,
    popularidad INT,
    reproducciones BIGINT,
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion) ON DELETE CASCADE
);

-- Insertar datos aleatorios en la tabla Artistas
INSERT INTO Artistas (nombre, genero) VALUES
('Taylor Swift', 'Pop'),
('Ed Sheeran', 'Pop/Folk'),
('Adele', 'Soul'),
('Coldplay', 'Rock'),
('Billie Eilish', 'Alternative');

-- Insertar datos aleatorios en la tabla Albumes
INSERT INTO Albumes (titulo, anio, id_artista) VALUES
('1989', 2014, 1),
('Divide', 2017, 2),
('25', 2015, 3),
('Parachutes', 2000, 4),
('Happier Than Ever', 2021, 5);

-- Insertar datos aleatorios en la tabla Canciones
INSERT INTO Canciones (titulo, id_album, duracion_ms) VALUES
('Shake It Off', 1, 242000),
('Perfect', 2, 263000),
('Hello', 3, 295000),
('Yellow', 4, 269000),
('Bad Guy', 5, 194000);

-- Insertar datos aleatorios en la tabla Caracteristicas
INSERT INTO Caracteristicas (id_cancion, energia, bailabilidad, instrumentalidad) VALUES
(1, 0.80, 0.75, 0.00),
(2, 0.70, 0.65, 0.00),
(3, 0.55, 0.40, 0.00),
(4, 0.60, 0.50, 0.00),
(5, 0.85, 0.90, 0.10);

-- Insertar datos aleatorios en la tabla Popularidad
INSERT INTO Popularidad (id_cancion, popularidad, reproducciones) VALUES
(1, 95, 1200000000),
(2, 90, 950000000),
(3, 85, 750000000),
(4, 80, 670000000),
(5, 98, 1500000000);

-- Función para agregar un artista
DELIMITER //
CREATE PROCEDURE AgregarArtista (
    IN p_nombre VARCHAR(100),
    IN p_genero VARCHAR(50)
)
BEGIN
    INSERT INTO Artistas (nombre, genero) VALUES (p_nombre, p_genero);
END //
DELIMITER ;

-- Función para eliminar un artista
DELIMITER //
CREATE PROCEDURE EliminarArtista (
    IN p_id_artista INT
)
BEGIN
    DELETE FROM Artistas WHERE id_artista = p_id_artista;
END //
DELIMITER ;

-- Función para agregar un álbum
DELIMITER //
CREATE PROCEDURE AgregarAlbum (
    IN p_titulo VARCHAR(150),
    IN p_anio INT,
    IN p_id_artista INT
)
BEGIN
    INSERT INTO Albumes (titulo, anio, id_artista) VALUES (p_titulo, p_anio, p_id_artista);
END //
DELIMITER ;

-- Función para eliminar un álbum
DELIMITER //
CREATE PROCEDURE EliminarAlbum (
    IN p_id_album INT
)
BEGIN
    DELETE FROM Albumes WHERE id_album = p_id_album;
END //
DELIMITER ;

-- Función para agregar una canción
DELIMITER //
CREATE PROCEDURE AgregarCancion (
    IN p_titulo VARCHAR(200),
    IN p_id_album INT,
    IN p_duracion_ms INT
)
BEGIN
    INSERT INTO Canciones (titulo, id_album, duracion_ms) VALUES (p_titulo, p_id_album, p_duracion_ms);
END //
DELIMITER ;

-- Función para eliminar una canción
DELIMITER //
CREATE PROCEDURE EliminarCancion (
    IN p_id_cancion INT
)
BEGIN
    DELETE FROM Canciones WHERE id_cancion = p_id_cancion;
END //
DELIMITER ;

-- Función para actualizar popularidad
DELIMITER //
CREATE PROCEDURE ActualizarPopularidad (
    IN p_id_cancion INT,
    IN p_popularidad INT,
    IN p_reproducciones BIGINT
)
BEGIN
    UPDATE Popularidad SET 
        popularidad = p_popularidad, 
        reproducciones = p_reproducciones
    WHERE id_cancion = p_id_cancion;
END //
DELIMITER ;

-- Función para agregar características de una canción
DELIMITER //
CREATE PROCEDURE AgregarCaracteristicas (
    IN p_id_cancion INT,
    IN p_energia DECIMAL(3,2),
    IN p_bailabilidad DECIMAL(3,2),
    IN p_instrumentalidad DECIMAL(3,2)
)
BEGIN
    INSERT INTO Caracteristicas (id_cancion, energia, bailabilidad, instrumentalidad) 
    VALUES (p_id_cancion, p_energia, p_bailabilidad, p_instrumentalidad);
END //
DELIMITER ;

-- Función para obtener canciones por artista
DELIMITER //
CREATE PROCEDURE ObtenerCancionesPorArtista (
    IN p_id_artista INT
)
BEGIN
    SELECT c.id_cancion, c.titulo, a.titulo AS album
    FROM Canciones c
    JOIN Albumes a ON c.id_album = a.id_album
    WHERE a.id_artista = p_id_artista;
END //
DELIMITER ;

-- Función para listar los álbumes de un artista
DELIMITER //
CREATE PROCEDURE ListarAlbumesPorArtista (
    IN p_id_artista INT
)
BEGIN
    SELECT id_album, titulo, anio
    FROM Albumes
    WHERE id_artista = p_id_artista;
END //
DELIMITER ;

-- Función para listar todas las canciones
DELIMITER //
CREATE PROCEDURE ListarCanciones ()
BEGIN
    SELECT id_cancion, titulo, id_album, duracion_ms FROM Canciones;
END //
DELIMITER ;

-- Ejemplo de función para buscar canciones por popularidad
DELIMITER //
CREATE PROCEDURE BuscarCancionesPorPopularidad (
    IN p_popularidad_min INT
)
BEGIN
    SELECT c.titulo, p.popularidad
    FROM Canciones c
    JOIN Popularidad p ON c.id_cancion = p.id_cancion
    WHERE p.popularidad >= p_popularidad_min;
END //
DELIMITER ;
