
# S2.04 Project Report

- create relational database
- data about french schools from the french
- government data: heacount, ips, segpa, ulis...
- populating
- statistical analyzis > linear regressions

- uml class diagram: basis
- gcir: weak functional deps: facilitates writing foreing keys
- csv files containing source data to infer attribute types
- ex: school lat and lng: float? no (rounding errors). High-precision required -> numeric
- compliance with relational model: not null
- SQL workbench to deploy

- dividing workload equally
- me: infering the type with provided data
- me: wrote the associations

(350 words)

This document is a report on the ongoing SAE 2.04 project. It's about its objectives, the technologies deployed, and my role in this project done in groups of two.

## 1. Project objectives

This project consists in setting up, populating and managing a realistic database.

As of now, we have completed our first task: to create the a relational database from an UML class diagram representing statistical data about french schools.

This data is from the French government. It contains things like the headcount of classes, the index of social position, the amount of students in programs like SEGPA or ULIS, and more.

Our second task consists in populating our database from this data.

Our third and last task consists in performing statistical analysises of the data, such as linear regressions.

## 2. Technologies used

The *UML* (Unified Modeling Language) class diagram we were provided describes the various classes and the relations between them. It served as the basis for our tables.

From it, we created a *referential integrity constraints graph* to represent the *weak functional dependencies* of the database. It
facilitated writing the *foreign keys* in the creation script.

We used the *CSV* (Comma-Separated Values) files representing the sample data to infer the type of the attributes.

Take as an example the latitude and longitude of a school. As they are real numbers, `float` or `double precision` may seem appropriate types to the naive programmer. But as **floating-point numbers**, they may cause rounding errors, which is dangerous for high-precision values like GPS coordinates. It is wiser to use the `numeric` type, which avoids this issue entirely.

To ensure compliance with the relational model, we also used the `not null` constraint to disallow missing values for attributes.

To deploy the database, we used *SQL Workbench* to connect to the remote database associated to our group and execute our creation script.

## 3. My role

Me and my partner Mattéo place a signficiant emphasis on dividing the workload equally. Thus, I took charge of infering the types from the provided data. Then, for writing the database creation script, I wrote the associations.
