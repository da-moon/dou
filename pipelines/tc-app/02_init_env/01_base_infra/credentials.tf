
locals {
  secrets_prefix = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}" : "tc-${var.env_name}"
}

resource "random_id" "secret_id" {
  byte_length = 5
}

#---------------------------------------
# Main db credentials
#---------------------------------------
resource "random_password" "db_pass" {
  length           = 16
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "db_user" {
  name                    = "/teamcenter/${var.env_name}/db/admin_user"
  description             = "Database username"
  recovery_window_in_days = 0

  tags = {
    Name            = "/teamcenter/${var.env_name}/db/admin_user"
    XML-coordinates = "fnd0_tcdbserver.fnd0_oracleDBUser"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret" "db_pass" {
  name                    = "/teamcenter/${var.env_name}/db/admin_pass"
  description             = "Database password"
  recovery_window_in_days = 0

  tags = {
    Name            = "/teamcenter/${var.env_name}/db/admin_pass"
    XML-coordinates = "fnd0_tcdbserver.fnd0_oracleDBUserPassword"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "db_user" {
  secret_id     = aws_secretsmanager_secret.db_user.id
  secret_string = var.db_user

}

resource "aws_secretsmanager_secret_version" "db_pass" {
  secret_id     = aws_secretsmanager_secret.db_pass.id
  secret_string = random_password.db_pass.result
}


#---------------------------------------
# Infodba credentials
#---------------------------------------
resource "random_password" "infodba_pass" {
  length           = 16
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "infodba_user" {
  name                    = "/teamcenter/${var.env_name}/db/infodba_user"
  description             = "Username for infodba account"
  recovery_window_in_days = 0

  tags = {
    Name            = "/teamcenter/${var.env_name}/db/infodba_user"
    XML-coordinates = "fnd0_corporateserver.fnd0_tcAdminUser"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret" "infodba_pass" {
  name                    = "/teamcenter/${var.env_name}/db/infodba_pass"
  description             = "Password for infodba account"
  recovery_window_in_days = 0

  tags = {
    Name            = "/teamcenter/${var.env_name}/db/infodba_pass"
    XML-coordinates = "fnd0_corporateserver.fnd0_tcAdminPassword"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "infodba_user" {
  secret_id     = aws_secretsmanager_secret.infodba_user.id
  secret_string = var.infodba_user
}

resource "aws_secretsmanager_secret_version" "infodba_pass" {
  secret_id     = aws_secretsmanager_secret.infodba_pass.id
  secret_string = random_password.infodba_pass.result
}


#---------------------------------------
# Indexing engine machine credentials
#---------------------------------------
resource "random_password" "indexing_engine_machine_pass" {
  length           = 16
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "indexing_engine_machine_user" {
  name                    = "${local.secrets_prefix}-idx-machine_user-${random_id.secret_id.hex}"
  description             = "Username for solr indexing engine machine"
  recovery_window_in_days = 0

  tags = {
    Name            = "${local.secrets_prefix}-idx-machine_user-${random_id.secret_id.hex}"
    XML-coordinates = "aws2_indexingengine.aws2_machineUser"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret" "indexing_engine_machine_pass" {
  name                    = "${local.secrets_prefix}-idx-machine-pass-${random_id.secret_id.hex}"
  description             = "Password for solr indexing engine machine"
  recovery_window_in_days = 0

  tags = {
    Name            = "${local.secrets_prefix}-idx-machine-pass-${random_id.secret_id.hex}"
    XML-coordinates = "aws2_indexingengine.aws2_machinePassword"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "indexing_engine_machine_user" {
  secret_id     = aws_secretsmanager_secret.indexing_engine_machine_user.id
  secret_string = var.indexing_engine_machine_user
}

resource "aws_secretsmanager_secret_version" "indexing_engine_machine_pass" {
  secret_id     = aws_secretsmanager_secret.indexing_engine_machine_pass.id
  secret_string = random_password.indexing_engine_machine_pass.result
}


#---------------------------------------
# Indexing engine credentials
#---------------------------------------
resource "random_password" "indexing_engine_pass" {
  length           = 16
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "indexing_engine_user" {
  name                    = "${local.secrets_prefix}-idx-user-${random_id.secret_id.hex}"
  description             = "Username for solr indexing engine"
  recovery_window_in_days = 0

  tags = {
    Name            = "${local.secrets_prefix}-idx-user-${random_id.secret_id.hex}"
    XML-coordinates = "aws2_indexingengine.aws2_indexingEngineUser"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret" "indexing_engine_pass" {
  name                    = "${local.secrets_prefix}-idx-pass-${random_id.secret_id.hex}"
  description             = "Password for solr indexing engine"
  recovery_window_in_days = 0

  tags = {
    Name            = "${local.secrets_prefix}-idx-pass-${random_id.secret_id.hex}"
    XML-coordinates = "aws2_indexingengine.aws2_indexingEngineUserPassword"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "indexing_engine_user" {
  secret_id     = aws_secretsmanager_secret.indexing_engine_user.id
  secret_string = var.indexing_engine_user
}

resource "aws_secretsmanager_secret_version" "indexing_engine_pass" {
  secret_id     = aws_secretsmanager_secret.indexing_engine_pass.id
  secret_string = random_password.indexing_engine_pass.result
}


#---------------------------------------
# Microservice credentials
#---------------------------------------
resource "random_password" "ms_keystore_pass" {
  length           = 16
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "ms_keystore_pass" {
  name                    = "${local.secrets_prefix}-ms-keystore-pass-${random_id.secret_id.hex}"
  description             = "Password for the microservices keystore"
  recovery_window_in_days = 0

  tags = {
    Name            = "${local.secrets_prefix}-ms-keystore-pass-${random_id.secret_id.hex}"
    XML-coordinates = "fnd0_microservice.fnd0_microservice_keyStorePassword"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "ms_keystore_pass" {
  secret_id     = aws_secretsmanager_secret.ms_keystore_pass.id
  secret_string = random_password.ms_keystore_pass.result
}


#---------------------------------------
# Server Manager db credentials
#---------------------------------------
resource "random_password" "db_sm_pass" {
  length           = 16
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "db_sm_user" {
  name                    = "/teamcenter/${var.env_name}/db/sm_user"
  description             = "Database username for Server Manager pool configuration"
  recovery_window_in_days = 0

  tags = {
    Name            = "/teamcenter/${var.env_name}/db/sm_user"
    XML-coordinates = "fnd0_serverpool_DBConfig.fnd0_serverManagerOracleDBUser"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret" "db_sm_pass" {
  name                    = "/teamcenter/${var.env_name}/db/sm_pass"
  description             = "Database password for Server Manager pool configuration"
  recovery_window_in_days = 0

  tags = {
    Name            = "/teamcenter/${var.env_name}/db/sm_pass"
    XML-coordinates = "fnd0_serverpool_DBConfig.fnd0_serverManagerOracleDBUserPassword"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "db_sm_user" {
  secret_id     = aws_secretsmanager_secret.db_sm_user.id
  secret_string = var.db_sm_user
}

resource "aws_secretsmanager_secret_version" "db_sm_pass" {
  secret_id     = aws_secretsmanager_secret.db_sm_pass.id
  secret_string = random_password.db_sm_pass.result
}


#---------------------------------------
# FSC machine credentials
#---------------------------------------
resource "random_password" "fsc_machine_pass" {
  length           = 16
  special          = true
  override_special = "-"
}

resource "aws_secretsmanager_secret" "fsc_machine_user" {
  name                    = "${local.secrets_prefix}-fsc-machine-user-${random_id.secret_id.hex}"
  description             = "User name for FSC machine"
  recovery_window_in_days = 0

  tags = {
    Name            = "${local.secrets_prefix}-fsc-machine-user-${random_id.secret_id.hex}"
    XML-coordinates = "fnd0_fsc.fnd0_fsc_machineUser"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret" "fsc_machine_pass" {
  name                    = "${local.secrets_prefix}-fsc-machine-pass-${random_id.secret_id.hex}"
  description             = "Password for FSC machine"
  recovery_window_in_days = 0

  tags = {
    Name            = "${local.secrets_prefix}-fsc-machine-pass-${random_id.secret_id.hex}"
    XML-coordinates = "fnd0_fsc.fnd0_fsc_machinePassword"
    Env             = var.env_name
    Installation    = var.installation_prefix != "" ? var.installation_prefix : null
  }
}

resource "aws_secretsmanager_secret_version" "fsc_machine_user" {
  secret_id     = aws_secretsmanager_secret.fsc_machine_user.id
  secret_string = var.fsc_machine_user
}

resource "aws_secretsmanager_secret_version" "fsc_machine_pass" {
  secret_id     = aws_secretsmanager_secret.fsc_machine_pass.id
  secret_string = random_password.fsc_machine_pass.result
}

