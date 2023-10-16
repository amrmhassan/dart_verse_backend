# Project Layers
1. Settings Layer
1. Service Layer
1. Server Layer
1. Service-Server Layer

## Settings layer
Collects data from the user, settings, connection links, db passwords and things like that

## Service layer
The actual service that run like auth service, storage service, email service

## Server layer
The exposing layer- this layer exposes the all services, settings to the outer world( with authorization, authentication )

## Service-Server layer
The middle layer between the service layer, and the server layer  
and it handles the authentication and authorization to use the service from the server layer