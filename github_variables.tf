
variable "github_groups" {
  description = "DigitalOnUs managed groups"
  default = [
    "admin",
    "caas",
    "development",
    "devops",
    "digitalonus",
    "innovation",
    "qe",
  ]
}

variable "admin_team" {
  description = "Github users for Admin Team"
  default = [
    "acardenasnet",   # Alejandro Cardenas
    "burstingninja",  # Marco Urrea
    "mons3rrat",      # Monserrat Sedeno
    "rhughes1",       # Ryan Hughes
    "simba23",        # Parminder Singh
    "stuartpurgavie", # Stuart Purgavie
    "thetonymaster",  # Antonio Cabrera
    "xfrarod",        # Francisco Rodriguez
  ]
}

variable "devops_team" {
  description = "Github users for DevOps Team"

  default = {
    "maintainers" = [
      "xfrarod",
    ],
    "members" = [
      "adiv413",
      "amarsamarth22", # Amar Samarth TechM
      "amritapuranik1802",
      "ankitg1984", # Ankit Gupta TechM
      "AR00834167", # Andres Rodriguez
      "aram-cuu",
      "arielazem",
      "artrojort",
      "AureliaPerez", # aurelia perez
      "bernardogza",
      "betov04",        # alberto Valle
      "blacksubmarine", # Gustavo Aleman
      "BryanBasulto",   # Bryan Basulto
      "burstingninja",
      "Carlos-Aviles",
      "da-moon", # Damoon Azarpazhooh
      "DanielHolguinT",
      "Dany998",
      "Darkirondan", # Dan Rodriguez
      "esauaguigar", # Esau Aguilar
      "faresssalehDOU",
      "FernandoFloresTechM", # Fernando barron
      "gabriel-delarosa",
      "GenazaP", # Genaro Paredes
      "gmlp",
      "GRivera53", # ER00842641@TechMahindra.com gerardo rivera
      "heber-crv", # Heber Cervantes
      "ideloza",
      "ileonelperea",
      "IrvinGalindo-TM",
      "jasmeetkohli",
      "javierclairvaux",
      "JavierLimon",
      "jcestrada1",
      "jmflores86",
      "jorgearavill",
      "juanbaas48",   # Juan Baas
      "juanjodevops", # Juanjo Cervantes
      "jvidalg",
      "keane369",
      "kind-grape", # Richard Peng
      "krprem81",   # Prem Kumar TechM
      "lchumberto",
      "lecsdexter", # Lucio Canche
      "Likarus",    # Abraham García Ortega
      "lop-mnl",    # Manuel Lopez
      "manuel220x",
      "Mariana0820",    # Mariana Mendoza
      "MarioRoblesDOU", # Mario Robles
      "markonibre",     # Marko Zlatanovic
      "melonger",       # Adam Melong
      "mm00849095",     # Monica Mercado
      "mons3rrat",
      "MonseGuzman",
      "nagister",    # Nahim Valle
      "Nelly123Her", # Nelly Hernandez
      "ninjew1",
      "OctaPal", # Octavio Palacio
      "Ozrlz",
      "prksingh606",  # Pravin Kumar Singh TechM
      "raghuramanbr", # Raghuraman Balakrishnan TechM
      "ramonpizana",  # ramon pizana
      "raulsainztm",  # Raul Sainz
      "rayploski",    # ray ploski Hashi
      "rhughes1",     # Ryan Hughes
      "sachiketha",   # Sachiketha Reddy
      "SangeethaGajam",
      "simba23",
      "snskdevops", # Naga Shiva Krishna Surapaneni TechM
      "stuartpurgavie",
      "stvnorg",
      "sukeshdonepudi", # Venkata Sukesh Donepudi
      "thegitlogin",    # Asif Mohammad
      "timmobbs",
      "vivek7sa",
    ]
  }
}

variable "development_team" {
  description = "Github users for Development Team"

  default = {
    "maintainers" = ["acardenasnet"],
    "members" = [
      "german-muzquiz",
      "yadirazavala",
    ]
  }
}

variable "qe_team" {
  description = "Github users for QE Team"

  default = {
    "maintainers" = ["isaguel"],
    "members" = [
      "isaguel",
      "OmarToMo",
    ]
  }
}

variable "innovation_team" {
  description = "Github users for Innovation Team"

  default = {
    "maintainers" = ["thetonymaster"],
    "members" = [
      "elizhl",
      "leofigy",
    ]
  }
}

variable "caas_team" {
  description = "Github users for CAAS Team"

  default = {
    "maintainers" = ["burstingninja"], # Marco Urrea
    "members" = [
      "adiv413",
      "artrojort",
      "burstingninja",
      "cass-development", # CaaS/WaaS Service Account
      "coderGo93",        # Edgar Lopez
      "EnriCarbak",       # Enrique Carbajal
      "esauaguigar",      # Esau Aguilar
      "gabriel-delarosa",
      "gmlp",         # Gonzalo Lopez
      "heber-crv",    # Heber Cervantes
      "ileonelperea", # Leonel 
      "javierlga",
      "jcestrada1", # Julio Estrada
      "keane369",
      "lecsdexter",  # Lucio Canche
      "Mariana0820", # Mariana Mendoza
      "melonger",    # Adam Melong
      "MonseGuzman",
      "Nagister",       # Nahim Valle
      "OctaPal",        # Octavio Palacio
      "rhughes1",       # Ryan Hughes
      "rodrigo-valdes", # Rodrigo Valdes
      "SangeethaGajam",
      "stvnorg",
      "timmobbs", # Tim Mobbs
    ]
  }
}
