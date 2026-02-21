# cloud-resume-2
I am rebuilding my cloud resume from the ground up using Python 

Need to set up the site as an Azure storage static website, then use a CDN for HTTPS. This might not work, as Azure has gone away with thier CDN Classic and now you have to use 
Azure Front door, which is way more expensive.
Looks like I should use Azure Static Web Apps as I can use Azure DNS to point to my custom domain: https://learn.microsoft.com/en-us/azure/static-web-apps/overview
I can also still use GitHub Actions for CI/CD.
I will use Lets encrypt for HTTPS on my domain: https://letsencrypt.org/getting-started/

Creating the API that populates the visiter data on the site, use the MS tutorial, it creates the foundation for you: https://learn.microsoft.com/en-us/azure/azure-functions/how-to-create-function-vs-code?pivots=programming-language-python

Ok I have the basic app created and tested that it works. I can supply a name via http request and it process it and returns a string.
Now I need to modifiy the function and make it so it updates the data in Cosmos DB






## List of azure services I need to create With Terraform
Azure Static Web App CHECK
Azure DNS? add this later when you have https figured out
Cosmos DB account with a database and container CHECK
Azure function app CHECK

Terraform is ready for check and creation

This is annoying... errors when running terraform validate:

Terraform is up to date on version 1.14.5 and the provider registry.terraform.io/hashicorp/azurerm v3.0.2
This is up to date and correct. I should be using "azurerm_static_web_app" as the resource, but it throws an error.
│ Error: Invalid resource type
│
│   on main.tf line 21, in resource "azurerm_static_web_app" "azureResume2-static-web-app":
│   21: resource "azurerm_static_web_app" "azureResume2-static-web-app" {
│
│ The provider hashicorp/azurerm does not support resource type "azurerm_static_web_app".
╵

According to the terraform docs the correct argument is "partition_key_pathS". note the plural.
but this is saying that the singular version is required but It errors when I use that one!
│ Error: Missing required argument
│
│   on main.tf line 102, in resource "azurerm_cosmosdb_sql_container" "azureResume2-cosmosdb-container":
│  102: resource "azurerm_cosmosdb_sql_container" "azureResume2-cosmosdb-container" {
│
│ The argument "partition_key_path" is required, but no definition was found.
╵

Continuation of above.... annoying
│ Error: Unsupported argument
│
│   on main.tf line 107, in resource "azurerm_cosmosdb_sql_container" "azureResume2-cosmosdb-container":
│  107:   partition_key_paths = ["/counter/id"]
│
│ An argument named "partition_key_paths" is not expected here. Did you mean "partition_key_path"?



