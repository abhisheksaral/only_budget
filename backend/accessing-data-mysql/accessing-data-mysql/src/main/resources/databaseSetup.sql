USE project172;
CREATE TABLE expenses (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                        user_id INT,
                        title VARCHAR(255),
                        category VARCHAR(255),
                        amount DOUBLE,
                        dt DATETIME);

CREATE TABLE users (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
                    user_name VARCHAR(255),
                    picture VARCHAR(255),
                    income DOUBLE);
