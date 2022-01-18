# Itemizer
An inventory tracking app with a focus on backend implementation.  

App features:
   - CRUD functionality for all resources
   - Keep track of inventory products
   - Keep track of shipments and assign a specific number of each product to it
   - Changes to shipments are automatically reflected in the inventory (ex. adding 2 item of a specific product to a shipment decreases inventory levels for that product by 2)  

Technologies:
   - Backend Framework: Rails
   - Backend Database: PostgreSQL
   - Frontend: React + Material UI
   - Containerization: Docker
# Table of contents
- [Running the Project](#running-the-project)
  - [Prerequisites](#prerequisites)
  - [Install and Run](#install-and-run)
  - [Run the Test Cases (Optional)](#run-the-test-cases-optional)
  - [Populate the Database (Optional)](#populate-the-database-optional)
- [Main Files](#main-files)
- [API](#api)
  - [Available endpoints](#available-endpoints)
  - [Submitting Data](#submitting-data)
  - [Reading Reponses](#reading-reponses)
- [Notes](#notes)
  - [API Remarks](#api-remarks)
  - [Future Considerations](#future-considerations)

# Running the Project
## Prerequisites
Docker: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)  
Git: [https://git-scm.com/downloads](https://git-scm.com/downloads)
## Install and Run
1. Clone the project into your preferred working directory using git:

	   git clone https://github.com/manzik/itemizer

2. Open a terminal an navigate to the project's folder.
3. Copy `.env.example` to `.env`:

	   cp .env.example .env

4. Run the app using docker-compose:

	   docker-compose up

5. Open [http://localhost:3000](http://localhost:3000) to access the frontend interacting with the backend.
## Run the Test Cases (Optional)
Run the integration and unit tests:  

	docker-compose exec web rails test

## Populate the Database (Optional)
Just to have some basic data in the database to see the api's functionality, you can populate the database with fixtures:
   
	docker-compose exec web rails db:fixtures:load

# Main Files

- Database: [db/](db/)
  - Schema: [db/schema.rb](db/schema.rb)
  - Migration files: [db/migrate](db/migrate)
- Models: [app/models/](app/models/)
- Serializers: [app/serializers/api/v1/](app/serializers/api/v1/)
- Controllers: [app/controllers/api/v1/](app/controllers/api/v1/)
- Tests: [test/](test/)
  - Fixtures: [test/fixtures/](test/fixtures/)
  - Controllers: [test/controllers/](test/controllers/)
  - Models: [test/models/](test/models/)
- Frontend: [public/](public/)

# API

Note: In an actual application, a more comprehensive documentation is needed for all available endpoints.  
A good tool for this purpose would be [swagger](https://swagger.io/).

## Available endpoints

Retrieved from [http://localhost:3000/rails/info/routes](http://localhost:3000/rails/info/routes):

- Products
  - /api/v1/products `GET` `POST`
  - /api/v1/products/:id `GET` `PATCH` `PUT` `DELETE`
- Shipments
  - /api/v1/shipments `GET` `POST`
  - /api/v1/shipments/:id `GET` `PATCH` `PUT` `DELETE`
- Shipping Products (products in a shipment)
  - /api/v1/shipping_products `GET` `POST`
  - /api/v1/shipping_products/:id `GET` `PATCH` `PUT` `DELETE`
  - /api/v1/products/:product_id/shipping_products `GET` `POST`
  - /api/v1/products/:product_id/shipping_products/:id `GET` `PATCH` `PUT` `DELETE`
  - /api/v1/shipments/:shipment_id/shipping_products `GET` `POST`
  - /api/v1/shipments/:shipment_id/shipping_products/:id `GET` `PATCH` `PUT` `DELETE`

## Submitting Data
For POST, PUT and PATCH requests, use the following convention in your request's body:
```json
{
    "entity": {
        "key1": "value1",
        "key2": "value2",
        "key3": "value3"
    }
}
```
Where entity is the type of object you are submitting.  
For example, to add a new product you can do:  

`POST` /api/v1/products/  
Request:
```json
{
    "product": {
        "name": "Air Fryer",
        "description": "The ultimate cooking appliance.",
        "quantity": 6
    }
}
```

## Reading Reponses
- If successful, the result is sent back under the `data` key in the response.  
  For example, when you get the list of all products:  
  
  `GET` /api/v1/products/  
  Response:
  ```json
  {
      "data": [
          {
              "id": 1,
              "name": "Magnifying Glass",
              "description": "A little less cool than a microscope.",
              "quantity": 40,
              "shipping_products": [
                  {
                      "id": 1,
                      "quantity": 2
                  }
              ]
          },
          {
              "id": 2,
              "name": "Encyclopedia of Fish",
              "description": "The pages of this book are all warped from water damage.",
              "quantity": 12,
              "shipping_products": [
                  {
                      "id": 1,
                      "quantity": 2
                  },
                  {
                      "id": 2,
                      "quantity": 3
                  }
              ]
          }
      ]
  }
  ```
- If not successful, a list of errors would be available under the `errors` key.  
  For example, when trying to make a shipment with an empty tracking number field:  
  
  `POST` /api/v1/shippings/  
  Request:
  ```json
  {
      "tracking_number": ""
  }
  ```
  Response:
  ```json
  {
      "errors": [
          "Tracking number can't be blank"
      ]
  }
  ```
  
# Notes
## API Remarks
   - Adding/updating the products in a shipment automatically adjusts the related product's quantity in the inventory.
   - Deleting a product is not allowed if it is currently being shipped to a user to preserve the information associated with that shipment.
   - Deleting the ShippingProduct and Shipment resources do not return their items to inventory by default.  
     In order to return the related items to inventory when deleting:
      - REST: Make your `DELETE` request with the query parameter `return_items=true`.
      - Rails: Call the `destroy_with_return_items` function implemented in the model instead of `destroy`.
## Future Considerations
   - Adding Sidekiq and Rails to our stack would be useful for future thread-blocking task implementations like image thumbnail rendering and report generation.
