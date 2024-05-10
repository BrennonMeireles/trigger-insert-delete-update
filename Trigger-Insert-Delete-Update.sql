CREATE DATABASE Fiama_Aulas2;
USE Fiama_Aulas2;

CREATE TABLE Aulas (
    pk_id INT PRIMARY KEY AUTO_INCREMENT,
    sala CHAR(5) UNIQUE, -- Tornando a coluna "sala" única
    periodo VARCHAR(11),
    dia DATETIME
);

CREATE TABLE Turmas (
    pk_id INT PRIMARY KEY AUTO_INCREMENT,
    fk_sala CHAR(5),
    FOREIGN KEY (fk_sala) REFERENCES Aulas(sala)
);

CREATE TABLE Log_Aulas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    operacao VARCHAR(10), -- Tipo de operação realizada: insert, update, delete
    new_sala CHAR(5),
    old_sala CHAR(5),
    new_periodo VARCHAR(11),
    old_periodo VARCHAR(11),
    new_dia DATETIME,
    old_dia DATETIME
);

DELIMITER //

-- adição
CREATE TRIGGER Trigger_Insert_Aula AFTER INSERT ON Aulas
FOR EACH ROW
BEGIN
    INSERT INTO Log_Aulas (operacao, new_sala, new_periodo, new_dia) VALUES ('insert', NEW.sala, NEW.periodo, NEW.dia);
END;
//

-- exclusão
CREATE TRIGGER Trigger_Delete_Aula AFTER DELETE ON Aulas
FOR EACH ROW
BEGIN
    INSERT INTO Log_Aulas (operacao, old_sala, old_periodo, old_dia) VALUES ('delete', OLD.sala, OLD.periodo, OLD.dia);
END;
//

-- atualização
CREATE TRIGGER Trigger_Update_Aula AFTER UPDATE ON Aulas
FOR EACH ROW
BEGIN
    INSERT INTO Log_Aulas (operacao, new_sala, new_periodo, new_dia, old_sala, old_periodo, old_dia) 
    VALUES ('update', NEW.sala, NEW.periodo, NEW.dia, OLD.sala, OLD.periodo, OLD.dia);
END;
//

DELIMITER ;

-- função para adicionar
INSERT INTO Aulas (sala, periodo, dia) VALUES ('3DM', 'Manhã', '2024-05-10 09:00:00');
INSERT INTO Aulas (sala, periodo, dia) VALUES ('4DM', 'Tarde', '2024-06-10 09:00:00');
INSERT INTO Aulas (sala, periodo, dia) VALUES ('A5',  'Noite', '2024-05-10 09:00:00');

-- função para atualizar
UPDATE Aulas SET sala = 'tes', periodo = 'Manhã', dia = '2024-05-10 09:00:00' WHERE pk_id = 4;
UPDATE Aulas SET sala = 'A1',  periodo = 'Manhã', dia = '2024-05-01 09:00:00' WHERE pk_id = 5;

-- função para deletar
DELETE FROM Aulas WHERE pk_id = 1;

SELECT * FROM Log_Aulas;
SELECT * FROM Aulas;
