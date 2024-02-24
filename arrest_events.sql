-- Create the 'public2' schema
CREATE SCHEMA public2;

CREATE TABLE public2.crime_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR UNIQUE
);

CREATE TABLE public2.arrest_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR UNIQUE
)

CREATE TABLE public2.arrest_subjects (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    dob DATE,
    gender VARCHAR(1),
    race VARCHAR
);

CREATE TABLE public2.organizations (
    id SERIAL PRIMARY KEY,
    name VARCHAR UNIQUE
);

CREATE TABLE public2.officers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    dob DATE,
    gender VARCHAR(1),
    employment_start_date DATE,
    organization_id INT,
    FOREIGN KEY (organization_id) REFERENCES public2.organizations (id)
);

CREATE TABLE public2.arrest_events (
    id SERIAL PRIMARY KEY,
    officer_id INT,
    subject_id INT,
    arrest_type_id INT,
    arrested_at TIMESTAMP,
    crime_type_id INT,
    FOREIGN KEY (officer_id) REFERENCES public2.officers (id),
    FOREIGN KEY (subject_id) REFERENCES public2.arrest_subjects (id),
    FOREIGN KEY (crime_type_id) REFERENCES public2.crime_type (id)
);



-- Example data
INSERT INTO public2.crime_type (name) VALUES
    ('Assault'),
    ('Burglary'),
    ('Drug Possession'),
    ('DUI'),
    ('Robbery');

INSERT INTO public2.arrest_type (name) VALUES
    ('Cited/Summoned'),
    ('Custodial Arrest'),
    ('Refer for Charges');

INSERT INTO public2.arrest_subjects (first_name, last_name, dob, gender, race) VALUES
    ('John', 'Doe', '1990-05-15', 'M', 'White'),
    ('Jane', 'Smith', '1985-09-20', 'F', 'Black'),
    ('Michael', 'Johnson', '1978-03-10', 'M', 'Hispanic'),
    ('Emily', 'Williams', '1995-11-25', 'F', 'Asian'),
    ('David', 'Brown', '1980-07-18', 'M', 'White');

INSERT INTO public2.organizations (name) VALUES
    ('Police Department'),
    ('Sheriff Office'),
    ('State Patrol'),
    ('FBI'),
    ('DEA');

INSERT INTO public2.officers (first_name, last_name, dob, gender, employment_start_date, organization_id) VALUES
    ('Kelvin', 'Space', '1985-03-20', 'M', '2010-01-15', 1),
    ('Jennifer', 'Smith', '1978-07-12', 'F', '2005-07-20', 2),
    ('Mike', 'Johnson', '1980-11-05', 'M', '2015-03-01', 3),
    ('Selena', 'Watson', '1992-09-28', 'F', '2008-11-10', 1),
    ('Dave', 'Bennett', '1983-12-15', 'M', '2012-06-05', 2);

INSERT INTO public2.arrest_events (officer_id, subject_id, arrest_type_id, arrested_at, crime_type_id) VALUES
    (1, 1, 1, '2023-02-10 08:30:00', 1),
    (2, 2, 2, '2023-02-12 15:45:00', 2),
    (3, 3, 3, '2023-02-14 10:20:00', 3),
    (4, 4, 4, '2023-02-16 18:00:00', 4),
    (5, 5, 5, '2023-02-18 11:10:00', 5);
