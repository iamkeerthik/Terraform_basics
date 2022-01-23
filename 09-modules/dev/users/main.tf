module "user_module" {
  source = "../../terraform-modules/users"
  environment= "dev"
} 

// here we are using user module from terraform modules to create user for dev environment