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




