BEGIN;

-- ================================
-- Abilities & Candidate Skills
-- ================================
CREATE TABLE public.abilities (
    id              SERIAL PRIMARY KEY,
    ability_name    VARCHAR(100) NOT NULL
);

CREATE TABLE public.ability_candidates (
    id              SERIAL PRIMARY KEY,
    ability_id      INT NOT NULL REFERENCES public.abilities(id),
    candidate_id    INT NOT NULL REFERENCES public.candidates(id)
);

-- ================================
-- Activation Codes (for candidates and employers)
-- ================================
CREATE TABLE public.activation_codes (
    id              SERIAL PRIMARY KEY,
    activation_code VARCHAR(38) NOT NULL,
    is_confirmed    BOOLEAN NOT NULL DEFAULT FALSE,
    confirmed_date  DATE
);

CREATE TABLE public.activation_code_to_candidates (
    id              INT PRIMARY KEY REFERENCES public.activation_codes(id),
    candidate_id    INT NOT NULL REFERENCES public.candidates(id)
);

CREATE TABLE public.activation_code_to_employers (
    id              INT PRIMARY KEY REFERENCES public.activation_codes(id),
    employer_id     INT NOT NULL REFERENCES public.employers(id)
);

-- ================================
-- Core Users & Roles
-- ================================
CREATE TABLE public.users (
    id              SERIAL PRIMARY KEY,
    email           VARCHAR(100) NOT NULL UNIQUE,
    password_hash   TEXT NOT NULL  -- store hashes, not plain passwords
);

CREATE TABLE public.candidates (
    id              INT PRIMARY KEY REFERENCES public.users(id),
    first_name      VARCHAR(25) NOT NULL,
    last_name       VARCHAR(25) NOT NULL,
    identity_number VARCHAR(11) UNIQUE NOT NULL,
    birth_date      DATE NOT NULL
);

CREATE TABLE public.employees (
    id              INT PRIMARY KEY REFERENCES public.users(id),
    first_name      VARCHAR(25) NOT NULL,
    last_name       VARCHAR(25) NOT NULL
);

CREATE TABLE public.employers (
    id              INT PRIMARY KEY REFERENCES public.users(id),
    company_name    VARCHAR(255) NOT NULL,
    web_address     VARCHAR(100) NOT NULL,
    phone_number    VARCHAR(15) NOT NULL,
    is_activated    BOOLEAN NOT NULL DEFAULT FALSE
);

-- ================================
-- Employer Activation
-- ================================
CREATE TABLE public.employer_activation_by_employees (
    id                  SERIAL PRIMARY KEY,
    employer_id         INT NOT NULL REFERENCES public.employers(id),
    confirmed_employee_id INT REFERENCES public.employees(id),
    is_confirmed        BOOLEAN NOT NULL DEFAULT FALSE,
    confirmed_date      DATE
);

-- ================================
-- Job Advertisements
-- ================================
CREATE TABLE public.job_titles (
    id              SERIAL PRIMARY KEY,
    title           VARCHAR(50) NOT NULL
);

CREATE TABLE public.cities (
    id              SERIAL PRIMARY KEY,
    city_name       VARCHAR(50) NOT NULL
);

CREATE TABLE public.job_advertisements (
    id              SERIAL PRIMARY KEY,
    employer_id     INT NOT NULL REFERENCES public.employers(id),
    job_title_id    INT NOT NULL REFERENCES public.job_titles(id),
    description     TEXT NOT NULL,
    city_id         INT NOT NULL REFERENCES public.cities(id),
    quota           INT NOT NULL CHECK (quota > 0),
    application_deadline DATE NOT NULL,
    created_date    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    min_salary      NUMERIC(12,2),
    max_salary      NUMERIC(12,2),
    CHECK (min_salary IS NULL OR max_salary IS NULL OR min_salary <= max_salary)
);

-- ================================
-- Languages
-- ================================
CREATE TABLE public.languages (
    id              SERIAL PRIMARY KEY,
    language_name   VARCHAR(50) NOT NULL
);

CREATE TABLE public.language_level (
    id              SERIAL PRIMARY KEY,
    level_name      VARCHAR(10) NOT NULL
);

CREATE TABLE public.language_candidates (
    id              SERIAL PRIMARY KEY,
    candidate_id    INT NOT NULL REFERENCES public.candidates(id),
    language_id     INT NOT NULL REFERENCES public.languages(id),
    language_level_id INT NOT NULL REFERENCES public.language_level(id)
);

-- ================================
-- Education (Schools & Departments)
-- ================================
CREATE TABLE public.schools (
    id              SERIAL PRIMARY KEY,
    school_name     VARCHAR(100) NOT NULL
);

CREATE TABLE public.departments (
    id              SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE public.school_departments (
    id              SERIAL PRIMARY KEY,
    school_id       INT NOT NULL REFERENCES public.schools(id),
    department_id   INT NOT NULL REFERENCES public.departments(id)
);

CREATE TABLE public.school_candidates (
    id              SERIAL PRIMARY KEY,
    school_department_id INT NOT NULL REFERENCES public.school_departments(id),
    candidate_id    INT NOT NULL REFERENCES public.candidates(id),
    date_of_entry   DATE NOT NULL,
    date_of_graduation DATE
);

-- ================================
-- Workplaces & Experience
-- ================================
CREATE TABLE public.workplaces (
    id              SERIAL PRIMARY KEY,
    workplace_name  VARCHAR(100) NOT NULL
);

CREATE TABLE public.workplace_candidate (
    id              SERIAL PRIMARY KEY,
    candidate_id    INT NOT NULL REFERENCES public.candidates(id),
    workplaces_id   INT NOT NULL REFERENCES public.workplaces(id),
    job_title_id    INT NOT NULL REFERENCES public.job_titles(id),
    date_of_entry   DATE NOT NULL,
    date_of_graduation DATE
);

-- ================================
-- Social Media Links
-- ================================
CREATE TABLE public.social_medias (
    id              SERIAL PRIMARY KEY,
    candidate_id    INT NOT NULL REFERENCES public.candidates(id),
    github_link     VARCHAR(500),
    linkedin_link   VARCHAR(500)
);

COMMIT;
