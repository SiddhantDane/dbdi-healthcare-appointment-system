# Module: Database Design and Implementation  
## Assignment Title: Healthcare Appointment and Patient Records System  

**Student Name:** Siddhant Sainath Dane  
**Programme:** BSc (Hons) Computer Science and Digitisation  
**Institution:** Berlin School of Business and Innovation (BSBI)  
**Academic Year:** 2025–2026  

---

# 1. Introduction

This project presents the design and implementation of a relational database system for managing healthcare appointments and patient records. The objective was to design a structured and normalized database capable of handling patients, doctors, facilities, treatments, and appointment scheduling in a consistent and scalable manner.

The system was first designed conceptually using an Entity-Relationship (ER) model and then implemented using MySQL 8+. Referential integrity was enforced using primary keys, foreign keys, constraints, and indexing. SQL queries were written to answer specific business questions and to demonstrate analytical capabilities.

---

# 2. ER Modelling and Conceptual Design

## 2.1 ER Diagram

The conceptual model consists of five primary entities:

- Patient  
- Doctor  
- Facility  
- Treatment  
- Appointment  

Because the system includes many-to-many relationships, three associative (junction) tables were introduced:

- Patient_Doctor  
- Patient_Treatment  
- Appointment_Treatment  

These tables resolve many-to-many relationships while maintaining relational integrity.

> The ER diagram is included in the `/screenshots` directory of this repository.

---

## 2.2 Relationship Types and Implementation

### One-to-One (1:1)
A one-to-one relationship is implemented using a foreign key with a UNIQUE constraint. This ensures that each record on one side corresponds to only one record on the other side.

### One-to-Many (1:N)
One-to-many relationships are implemented by placing a foreign key in the “many” table referencing the primary key of the “one” table.

Examples in this system:
- Patient → Appointment  
- Doctor → Appointment  
- Facility → Appointment  

### Many-to-Many (M:N)
Many-to-many relationships are resolved using junction tables that contain foreign keys referencing both related entities. These tables use composite primary keys.

Examples:
- Patient ↔ Doctor  
- Patient ↔ Treatment  
- Appointment ↔ Treatment  

---

# 3. Database Implementation

The database was implemented in MySQL using Data Definition Language (DDL) statements. The design includes:

- Primary keys for all tables  
- Foreign keys to enforce referential integrity  
- NOT NULL constraints where required  
- UNIQUE constraints on patient full name and doctor email  
- CHECK constraint on treatment cost  
- Index on `doctor_name` to improve search performance  

Sample data was inserted to simulate realistic healthcare relationships. The dataset ensures:

- Some patients consult multiple doctors  
- Some appointments include multiple treatments  
- Treatments occur at different facilities  

This structure allows meaningful analytical queries.

---

# 4. Business Queries and Analysis

Several SQL queries were implemented to answer business questions.

## Query (a)
List all appointments for a specific patient.  
This query joins patient, appointment, doctor, and facility tables to retrieve complete appointment details.

## Query (b)
Calculate the total number of treatments administered by each doctor.  
This uses `GROUP BY` and `COUNT` to aggregate treatment records.

## Query (c)
Identify doctors who have treated more than five patients.  
This uses `GROUP BY` and `HAVING` to filter aggregated results.

## Query (d)
Find facilities where a particular patient received treatment.  
This uses `DISTINCT` to avoid duplicate facility names.

## Query (e)
List patients along with their assigned doctors and treatments.  
This query demonstrates multi-table joins and relational mapping.

## Query (f)
Determine the most expensive treatment and the doctor who administered it.  
A subquery using `MAX(cost)` is used to identify the highest-cost treatment.

## Query (g)
Identify patients who have appointments in more than one facility.  
This uses `COUNT(DISTINCT)` and `HAVING`.

## CASE + GROUP BY Analysis
Facilities were classified as “High Activity” or “Low Activity” based on total treatments using a CASE statement combined with GROUP BY.

All query execution screenshots are provided in the `/screenshots` directory.

---

# 5. Normalisation Practice

## First Normal Form (1NF)

The initial unnormalized structure repeated appointment-level data for each treatment row. While values were atomic, redundancy existed because appointment information was duplicated for multiple treatments.

## Second Normal Form (2NF)

To achieve 2NF, partial dependencies were removed by separating:

- Appointment-level data  
- Patient data  
- Doctor data  
- Treatment data  

This ensured that non-key attributes depend fully on their primary key.

## Third Normal Form (3NF)

To achieve 3NF, transitive dependencies were eliminated:

- Patient_Name depends only on Patient_ID  
- Doctor_Name depends only on Doctor_ID  
- Treatment_Name and Cost depend only on Treatment_ID  

The final schema minimizes redundancy and prevents update, insertion, and deletion anomalies.

---

# 6. Conclusion

The healthcare appointment and patient records system was successfully designed and implemented using relational database principles. The ER model provided a structured conceptual foundation, and the MySQL implementation enforced data integrity through constraints and keys.

The system supports analytical reporting using JOIN, GROUP BY, HAVING, subqueries, and CASE statements. The normalization process ensures that the database is efficient, scalable, and consistent.

---

# Appendix A – GitHub Repository

The complete implementation of this assignment is available in the following public GitHub repository:

https://github.com/SiddhantDane/dbdi-healthcare-appointment-system

The repository contains:

- `healthcare_system.sql` – Complete MySQL implementation  
- `report/assignment_writeup.md` – Conceptual and analytical explanations  
- `screenshots/` – Execution proof and ER diagram  

---

# References (Harvard Style)

Connolly, T. and Begg, C. (2015) *Database Systems: A Practical Approach to Design, Implementation, and Management*. Pearson.

Codd, E.F. (1970) ‘A relational model of data for large shared data banks’, *Communications of the ACM*, 13(6), pp. 377–387.

Elmasri, R. and Navathe, S.B. (2016) *Fundamentals of Database Systems*. Pearson.

Silberschatz, A., Korth, H.F. and Sudarshan, S. (2020) *Database System Concepts*. McGraw-Hill.
