import azure.functions as func
import logging
from azure.cosmos import CosmosClient
import os

# these are the environment variables that will be set in azure via the az CLI
# Dont worry about the errors here the keys dont exist yet
URL = os.environ.get('COSMOS_DB_URL')
KEY = os.environ.get('COSMOS_DB_KEY')
DATABASE = os.environ.get('COSMOS_DB_DATABASE')
CONTAINER = os.environ.get('COSMOS_DB_CONTAINER')
# this is our connection to Cosmos DB, it goes all the way to the container level and we should be able to pull the data from it and mofify it
container = CosmosClient(URL, credential=KEY).get_database_client(DATABASE).get_container_client(CONTAINER)

# Create an instance of the FunctionApp and set the authentication level to anonymous
app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

# Define a route for the Azure Function and specify the HTTP methods it should respond to
@app.route(route="azureFunction")
def azureFunction(req: func.HttpRequest): #-> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    # Really what I want to do here is take the Cosmos DB connection string
    # use it to connect to the database, incriment the database value by 1 and return the new data in the response
    # use params 'id' for the data value ID which should always stay the same
    # and use param 'counter' for the data and incriment this by 1

    # id (str) – ID (name) of the container.
    # container_link (str) – The URL path of the container.
    # To update or replace an existing item, use the ContainerProxy.upsert_item() method

    counter = container.read_item(item='counter', partition_key='counter')['counter']
    counter += 1
    container.upsert_item({'id': 'counter', 'counter': counter})



    # name = req.params.get('name')
    # if not name:
    #     try:
    #         req_body = req.get_json()
    #     except ValueError:
    #         pass
    #     else:
    #         name = req_body.get('name')

    # if name:
    #     return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    # else:
    #     return func.HttpResponse(
    #          "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
    #          status_code=200
    #     )