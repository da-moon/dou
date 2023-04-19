
variable "user_emails" {
  description = "Users_emails"

  default = {
    "members" = [
    ]
  }
}


# US Resource Groups
variable "east_us" {
  description = "East US resource groups"

  default = {
    "members" = [
      "faress.saleh@digitalonus.com",
      "sai.prakash@digitalonus.com",
      "swathi.kondakalla@digitalonus.com",
      "vivek.saxena@digitalonus.com",
      "mukul.kapoor@digitalonus.com",
    ]
  }
}

variable "east_us_2" {
  description = "East US 2 resource groups"

  default = {
    "members" = [
      "varun.senthilkumar@digitalonus.com",

    ]
  }
}
variable "north_central_us" {
  description = "North Central US resource groups"

  default = {
    "members" = [
    ]
  }
}

variable "central_us" {
  description = "Central US 2 resource groups"

  default = {
    "members" = [
    ]
  }
}

variable "south_central_us" {
  description = "South Central US resource groups"

  default = {
    "members" = [
      "abraham.ortega@digitalonus.com",
      "ariel.mendoza@digitalonus.com",
      "bernardo.garza@digitalonus.com",
      "bryan.basulto@digitalonus.com",
      "carlos.bravo@digitalonus.com",
      "cristian.conte@digitalonus.com",
      "didier.valdez@digitalonus.com",
      "edgar.lopez@digitalonus.com",
      "enrique.carbajal@digitalonus.com",
      "ernesto.gonzalez@digitalonus.com",
      "gerardo.rosales@digitalonus.com",
      "gonzalo.lopez@digitalonus.com",
      "humberto.lozano@digitalonus.com",
      "isai.deloza@digitalonus.com",
      "ivan.rivas@digitalonus.com",
      "javier.limon@digitalonus.com",
      "javier.reyes@digitalonus.com",
      "juan.baas@digitalonus.com",
      "karla.garcia@digitalonus.com",
      "leonel.perea@digitalonus.com",
      "lucio.canche@digitalonus.com",
      "luis.barragan@digitalonus.com",
      "luis.medina@digitalonus.com",
      "marco.urrea@digitalonus.com",
      "mario.robles@digitalonus.com",
      "miguel.rodriguez@digitalonus.com",
      "monserrat.guzman@digitalonus.com",
      "nikole.perez@digitalonus.com",
      "octavio.palacios@digitalonus.com",
      "pedro.herrera@digitalonus.com",
      "sudhir.batchu@digitalonus.com",
      "victor.godinez@digitalonus.com",
      "yadira.zavala@digitalonus.com",
    ]
  }
}

variable "west_central_us" {
  description = "West Central US resource groups"

  default = {
    "members" = [
    ]
  }
}

variable "west_us" {
  description = "West US resource groups"

  default = {
    "members" = [
    ]
  }
}

variable "west_us_2" {
  description = "West US 2 resource groups"

  default = {
    "members" = [
      "javier.cabrera@digitalonus.com",
      "timothy.mobbs@digitalonus.com",
    ]
  }
}

# Canada Resource groups

variable "canada_east" {
  description = "Canada East resource groups"

  default = {
    "members" = [
      "aditya.vasantharao@digitalonus.com",
      "amrita.puranik@digitalonus.com",
      "asif.mohammad@digitalonus.com",
      "jithendher.kommula@digitalonus.com",
      "kevin.sebastian@digitalonus.com",
      "sangeetha.gajam@digitalonus.com",
      "tochukwu.ibegbulam@digitalonus.com",
      "venkata.donepudi@digitalonus.com",
    ]
  }
}

variable "canada_central" {
  description = "Canada central resource groups"

  default = {
    "members" = [
      "dawas.zaidi@digitalonus.com",
      "isaac.ma@digitalonus.com",
      "jude.ejinkonye@digitalonus.com",
      "ravi.periketi@digitalonus.com",
      "ryan.hughes@digitalonus.com",
      "santosh.thundi@digitalonus.com",
    ]
  }
}
#

variable "university_central_us" {
  description = "Central US resource groups for DOUniversity"


  default = {
    "members" = [
      "alberto.valle@digitalonus.com",
      "aurelia.perez@digitalonus.com",
      "carlos.hernandez@digitalonus.com",
      "esau.aguilar@digitalonus.com",
      "heber.cervantes@digitalonus.com",
      "luis.perez@digitalonus.com",
      "manuel.lopez@digitalonus.com",
      "mariana.mendoza@digitalonus.com",
    ]
  }
}
variable "university_east_us" {
  description = "East US resource groups for DOUniversity"

  default = {
    "members" = [
    ]
  }
}
variable "university_west_us" {
  description = "West US resource groups for DOUniversity"

  default = {
    "members" = [
    ]
  }
}
