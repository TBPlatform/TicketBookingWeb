# Online Event Booking Application:ticket:

## Introduction

Welcome to the MusicBandTeam's online event booking platform. As a group of passionate students from the University of Melbourne, we've developed this application to streamline the process of booking live music events across Australia. Inspired by established services like Ticketek, our platform is designed to simplify the booking experience, making it both efficient and user-friendly.

## Key Features

- User Registration and Authentication: Secure login/logout functionality.
- Administrator Role: Administrators can manage venues, view customer profiles, and oversee bookings.
- Event Planner Role: Event planners have the ability to create, manage, and co-manage musical events. They can also handle bookings and collaborate with other planners.
- Customer Role: Customers can search for events and book tickets as long as they are available.

## Deployment

- **Link To Website**: [Click Here](https://ticketbookingweb.onrender.com):sparkles:

**Note:** The application is hosted on Render. Users may experience a "Not Found" error during login authentication or delays during the initial request. These are known issues and typically resolve by revisiting the homepage.

## Repository Structure

```
├── event-app/              # Frontend developed with React(JavaScript)
│   ├── src/
|
├── event-backend/          # Backend developed with Java
└── README.md               # Project README file
```

## Project Architecture

**Class Diagram**(![Board overview](https://github.com/TBPlatform/TicketBookingWeb/blob/main/resource/Diagram.png))

**Design Patterns Employed**

- **Data Mapper:** To decrease coupling between our domain model and the database itself, we implemented data mappers for each object in the business domain. All object mappers extend this AbstractMapper and, depending on their relevant fields, implement the helper functions for the key operations differently.

- **Unit Of Work:** Each time that our system runs a transaction, any relevant objects are stored in the UnitOfWork class.

- **Lazy Load:** We implemented the lazy load pattern for the Section data within an EventSection, as often it is unnecessary for it to be loaded when Users are requesting event data. It allows to query the database if necessary. It is then up to our Logic classes to determine if the unloaded information is necessary or not.

- **Authentication and Authorization:** Since our application is implemented as separate frontend and backend components, we utilised the Java JWT library to generate JSON Web Tokens upon a frontend client’s login, so that the frontend can use them to authenticate itself on our Spring Security-managed backend, and receive authorization to send requests to routes that require certain tier/s of access.

## Part 3 - Concurrency Management

As a part of our SWEN90007 project, this section deals with concurrency issues that arise due to multiple users interacting with the application simultaneously. Some of the challenges include:

- Multiple customers trying to purchase tickets to the same event simultaneously.
- Multiple event planners managing the same event.

### Concurrency Solutions

- **Issue 1: Multiple Ticket Bookings**

  - Solution: Optimistic Online Locks
  - Testing: Simulated multiple users trying to purchase the same ticket.

- **Issue 2: Multiple Event Management**

  - Solution: Optimistic Online Locks
  - Testing: Simulated multiple event planners editing the same event.

- **Issue 3: Multiple Venue Editing Management**
  - Solution: Permistic Online Locks
  - Testing: Simulated one admin view and editing the same venue.

## Team Member

[Jade](https://github.com/Xi3xi)
[Jan](https://github.com/JanZhang666)
[Vivien](https://github.com/vguo2037)

**Credentials**:

- **Administrator**:
  - Username: admin@email.com
  - Password: admin

Detailed data samples can be found [here](docs/data-samples).
