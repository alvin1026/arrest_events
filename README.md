# Arrest Event API Documentation

## Overview

The Flask app provides endpoints for managing arrest events. The Kafka consumer app enables process of streaming data.

Base URL: `http://localhost:5100`

Kafka topic: `arrest_event`

## Endpoints

### Get All Arrest Events

- **URL:** `/arrest_events`
- **Method:** `GET`
- **Description:** Retrieve a list of all arrest events.
- **Request Parameters:** None
### Get Arrest Event by ID

- **URL:** `/arrest_events/<int:event_id>`
- **Method:** `GET`
- **Description:** Retrieve an arrest event by its ID.
- **Request Parameters:**
  - `event_id` (integer): The ID of the arrest event to retrieve.

### Create Arrest Event

- **URL:** `/arrest_events`
- **Method:** `POST`
- **Description:** Create a new arrest event.
- **Request Parameters:**
  - `officer_id` (integer): The ID of the arresting officer.
  - `subject_id` (integer): The ID of the arrested subject.
  - `arrest_type_id` (integer): The ID of the arrest type.
  - `arrested_at` (string): The timestamp of the arrest in ISO 8601 format.
  - `crime_type_id` (integer): The ID of the crime type.

### Update Arrest Event

- **URL:** `/arrest_events/<int:event_id>`
- **Method:** `PUT`
- **Description:** Update an existing arrest event.
- **Request Parameters:**
  - `event_id` (integer): The ID of the event to update.
- **Request Body:**
  - JSON object containing the fields to update.

### Delete Arrest Event

- **URL:** `/arrest_events/<int:event_id>`
- **Method:** `DELETE`
- **Description:** Delete an existing arrest event.
- **Request Parameters:**
  - `event_id` (integer): The ID of the event to delete.


## Design

### Scalability
- Deployment with WSGI Server: Instead of relying on Flask's built-in development server for production, deploying the application with a robust WSGI server like Gunicorn would be beneficial. Utilizing such servers enables support for asynchronous request handling, enhancing concurrency and scalability.

- Horizontal Scaling with Load Balancing: Deploying multiple instances of the Flask application behind a load balancer is a strategic move. This approach distributes incoming requests across multiple servers, facilitating the handling of higher loads and providing fault tolerance. Employing orchestration tools like Kubernetes enables efficient monitoring of CPU/memory usage in each pod, allowing for automatic scaling based on demand.

- Database Optimization: To improve database performance, strategic optimizations are crucial. Utilizing indexes where necessary enhances query performance. Additionally, considering database sharding or replication can effectively distribute the database load across multiple servers, further enhancing scalability and performance.


