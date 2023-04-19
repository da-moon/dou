# Group requirements
variable "gitlab_group_name" {
  description = "Group name"
}

# User access_level

variable "owner" {
  description = "Gitlab owners"

  default = {
    "members" = [
      "_eMdOS_",            # Emilio Ojeda
      "aram-cuu",           # Aram Rascon
      "cardenas.alejandro", # Alejandro Cardenas
      "cesarbecerra",       # Cesar Becerra
      "gmlp",               # Gonzalo Lopez
      "isaacma4",           # Isaac Ma
      "Ivan4j",             # Ivan Hernandez
      "jasmeetkohlisingh",  # Jasmeet Kohli
      "javierlimonr",       # Javier Limon
      "julio-arriaga",      # Julio Arriaga
      "marcourrea-dou",     # Marco Urrea
      "msede25",            # Monserrat Sedeno
      "nhtzr.rg",           # Ezequiel Rosas Garcia
      "rhughes1",           # Ryan Hughes
      "simba23",            # Parminder Singh
      "stuartpurgavie",     # Stuart Purgavie
      "thetonymaster",      # Antonio Cabrera
      "xfrarod",            # Francisco Rodriguez
    ]
  }
}

variable "maintainer" {
  description = "Gitlab maintainers"

  default = {
    "members" = [
    ]
  }
}

variable "developer" {
  description = "Gitlab developers"

  default = {
    "members" = [
      "abeortega", # Abraham Ortega
      "acanto95",
      "aditya_tatiparthi",
      "adiv413",
      "alanDOU",
      "alejandro.moralesDOU",
      "alejandro.padillam",
      "alhelysanchez",
      "alma33",
      "amanheir",      # Amandeep Kaur
      "amarsamarth22", # Amar Samarth
      "amritapuranik1802",
      "andoniArb",
      "andrea.guzman",
      "ankitg1984", # Ankit Gupta24
      "arielazem",
      "artrojort",
      "asael.dou",
      "avoyer",
      "B3n1gno",      # Benigno Castro
      "BasultoBryan", # Bryan Basulto
      "Ben1gno85",
      "berisberis",
      "bernardogza",
      "brandonvilla21",
      "cahldou", # Carlos Alberto Hernandez Lopez
      "cbravodou",
      "christochi", # Tochi Ibegbulam
      "da-moon",    # Damoon Azarpazhooh
      "daniel_montero",
      "Dany998",
      "dawasz",
      "dhanesh131",
      "dou-gabriel.delarosa",
      "dou-gerardorh",
      "dou-marko",
      "dou.armandom",
      "douernesto",
      "eduardo.hernandez",
      "eduardo.lopez.dou",
      "eduardo.manrique.digital",
      "elizhl",
      "enri.carba", # Enrique Cabral
      "enri.carba", # Enrique Carbajal
      "erickpt125",
      "esauaguigar", # Esau Aguilar
      "estepon2",    # Julio Briones
      "etrejo.developer",
      "fabian.reyes",
      "faresssaleh",
      "gabmtzg",
      "german.muzquiz.digitalonus",
      "gonzalezhugo",
      "Heber.crv", # Heber Cervantes
      "ileonelperea",
      "imleo",
      "IrvingLV", # Irving Lopez
      "israel.capetillo",
      "janiceherrera", # Janice Herrera
      "JavierClairvaux",
      "jcestrada1",
      "jdbsandoval",
      "jejinkonye", # Jude Ejinkonye
      "jesus.vidal.go",
      "jlunadou",
      "jorge.dom",
      "jorgeahn",
      "kaarlag",
      "keane369",
      "kia.akrami",
      "kind-grape",
      "kjsebastian1", # Kevin Sebastian"
      "krprem81",     # Prem Kumar
      "lchumberto",
      "luciocanche",
      "luis.camacho365",
      "luisfdz",
      "LuisHMM", # Luis Medina
      "lupita.contreras",
      "maemm",
      "Manuel_Lopez", # Manuel Lopez
      "manuel.flores.cobian",
      "Marianag20", # Mariana Mendoza
      "mavagoen",
      "melonger", # Adam Melong
      "mugdha.pandit",
      "NahimValleEsquer",
      "ninjew1",
      "OctavioPal", # Octavio Palacios
      "oscar.perez5",
      "Ozrlz",
      "patricio-martinez",
      "prksingh",     # Pravin Kumar Singh _
      "raghuramanbr", # Raghuraman Balakrishnan
      "ramakanth16",
      "ravi.dou65",
      "ravi.sudhireddy", # Ravi Shankar R Sudhireddy
      "ricardo.jimenez.dou",
      "rlagunas",
      "rubiodou",
      "sachiketha",
      "sajjas",
      "SangeethaGajam",
      "santoshraghu94",
      "skonda",
      "spcruzaley",
      "ssalgueroDOU",
      "sudhirbatchu",
      "sukeshdonepudi", # Venkata Sukesh Donepudi
      "surapaneni",     # Naga Shiva Krishna Surapaneni
      "thegitlogin",    # Asif Mohammad
      "tmobbsy",        # Tim Mobbs
      "varungsk15",
      "vhgodinez95",
      "vicrojas_mx",
      "victormidp",
      "vivekdigital", # Vivek Saxena
      "xlsmearlx",
    ]
  }
}
variable "reporter" {
  description = "Gitlab reporters"

  default = {
    "members" = [
    ]
  }
}

variable "guest" {
  description = "Gitlab guests"

  default = {
    "members" = [

    ]
  }
}

variable "gitlab_solutions" {
  description = "Solutions Team WaaS"

  default = {
    "members" = [
      "esauaguigar", # Esau Aguilar
      "Marianag20",  # Mariana Mendoza
      # "gmlp",      # Gonzalo Lopez - Disabled here because global owner
    ]
  }
}
