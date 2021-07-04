### API & CLIENT ###
resource "aws_ssm_parameter" "nazolog_api_baseurl" {
    name = "/nazolog/url/api"
    value = "https://api.mystery-logger.com"
    type = "String"
    description = "APIのURL"
}

resource "aws_ssm_parameter" "nazolog_client_url" {
    name = "/nazolog/url/client"
    value = "https://mystery-logger.com"
    type = "String"
    description = "フロントのURL"
}

resource "aws_ssm_parameter" "nazolog_unique_token" {
    name = "/nazolog/token/original"
    value = "ExampleToken"
    type = "SecureString"
    description = "フロントとAPI共通の文字列"

    lifecycle {
        ignore_changes = [ value ]
    }
}

### API ###
resource "aws_ssm_parameter" "nazolog_laravel_app-env" {
    name = "/nazolog/laravel/app_env"
    value = "production"
    type = "String"
    description = "APP_ENV"
}

resource "aws_ssm_parameter" "nazolog_laravel_app_debug" {
    name = "/nazolog/laravel/app_debug"
    value = "false"
    type = "String"
    description = "APP_DEBUG"
}

resource "aws_ssm_parameter" "nazolog_laravel_log_channel" {
    name = "/nazolog/laravel/log_channel"
    value = "stack"
    type = "String"
    description = "LOG_CHANNEL"
}

###### DB ###### 
resource "aws_ssm_parameter" "nazolog_laravel_db_connection" {
    name = "/nazolog/laravel/db_connection"
    value = "pgsql"
    type = "String"
    description = "DB_CONNECTION"
}

resource "aws_ssm_parameter" "nazolog_laravel_db_host" {
    name = "/nazolog/laravel/db_host"
    value = "ExampleHost"
    type = "SecureString"
    description = "DB_HOST"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_db_port" {
    name = "/nazolog/laravel/db_port"
    value = "5432"
    type = "String"
    description = "DB_PORT"
}

resource "aws_ssm_parameter" "nazolog_laravel_db_database" {
    name = "/nazolog/laravel/db_database"
    value = "ExampleDatabase"
    type = "SecureString"
    description = "DB_DATABASE"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_db_username" {
    name = "/nazolog/laravel/db_username"
    value = "ExampleUsername"
    type = "SecureString"
    description = "DB_USERNAME"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_db_password" {
    name = "/nazolog/laravel/db_password"
    value = "ExamplePassword"
    type = "SecureString"
    description = "DB_PASSWORD"

    lifecycle {
        ignore_changes = [ value ]
    }
}

###### CACHE / SESSION / QUEUE ######
resource "aws_ssm_parameter" "nazolog_laravel_cache_driver" {
    name = "/nazolog/laravel/cache_driver"
    value = "redis"
    type = "String"
    description = "CACHE_DRIVER"
}

resource "aws_ssm_parameter" "nazolog_laravel_queue_connection" {
    name = "/nazolog/laravel/queue_connection"
    value = "sqs"
    type = "String"
    description = "QUEUE_CONNECTION"
}

resource "aws_ssm_parameter" "nazolog_laravel_session_driver" {
    name = "/nazolog/laravel/session_driver"
    value = "redis"
    type = "String"
    description = "SESSION_DRIVER"
}

resource "aws_ssm_parameter" "nazolog_laravel_session_lifetime" {
    name = "/nazolog/laravel/session_lifetime"
    value = "120"
    type = "String"
    description = "SESSION_LIFETIME"
}

resource "aws_ssm_parameter" "nazolog_laravel_redis_host" {
    name = "/nazolog/laravel/redis_host"
    value = "ExampleHost"
    type = "SecureString"
    description = "REDIS_HOST"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_redis_password" {
    name = "/nazolog/laravel/redis_password"
    value = "ExamplePass"
    type = "SecureString"
    description = "REDIS_PASSOWORD"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_redis_port" {
    name = "/nazolog/laravel/redis_port"
    value = "6379"
    type = "String"
    description = "REDIS_PORT"
}

resource "aws_ssm_parameter" "nazolog_laravel_redis_client" {
    name = "/nazolog/laravel/redis_client"
    value = "predis"
    type = "String"
    description = "REDIS_CLIENT"
}

###### MAIL ######
resource "aws_ssm_parameter" "nazolog_laravel_mail_driver" {
    name = "/nazolog/laravel/mail_driver"
    value = "smtp"
    type = "String"
    description = "MAIL_DRIVER"
}

resource "aws_ssm_parameter" "nazolog_laravel_mail_host" {
    name = "/nazolog/laravel/mail_host"
    value = "ExampleHost"
    type = "SecureString"
    description = "MAIL_HOST"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_mail_port" {
    name = "/nazolog/laravel/mail_port"
    value = "2587"
    type = "String"
    description = "MAIL_PORT"
}

resource "aws_ssm_parameter" "nazolog_laravel_mail_username" {
    name = "/nazolog/laravel/mail_username"
    value = "ExampleUsername"
    type = "SecureString"
    description = "MAIL_USERNAME"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_mail_password" {
    name = "/nazolog/laravel/mail_password"
    value = "ExamplePass"
    type = "SecureString"
    description = "MAIL_PASSWORD"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_mail_encryption" {
    name = "/nazolog/laravel/mail_encryption"
    value = "TLS"
    type = "String"
    description = "MAIL_ENCRYPTION"
}

resource "aws_ssm_parameter" "nazolog_laravel_mail_from_address" {
    name = "/nazolog/laravel/mail_from_address"
    value = "info@mail.mystery-logger.com"
    type = "String"
    description = "MAIL_FROM_ADDRESS"
}

resource "aws_ssm_parameter" "nazolog_laravel_mail_from_name" {
    name = "/nazolog/laravel/mail_from_name"
    value = "なぞログ"
    type = "String"
    description = "MAIL_FROM_NAME"
}

resource "aws_ssm_parameter" "nazolog_laravel_aws_default_region" {
    name = "/nazolog/laravel/aws_default_region"
    value = "ap-northeast-1"
    type = "String"
    description = "AWS_DEFAULT_REGION"
}

resource "aws_ssm_parameter" "nazolog_laravel_aws_image_bucket" {
    name = "/nazolog/laravel/aws_image_bucket"
    value = "ExampleBucket"
    type = "SecureString"
    description = "AWS_BUCKET"

    lifecycle {
        ignore_changes = [ value ]
    }
}

resource "aws_ssm_parameter" "nazolog_laravel_aws_sqs_url" {
    name = "/nazolog/laravel/aws_sqs_url"
    value = "ExampleSQS"
    type = "SecureString"
    description = "AWS_SQS_URL"

    lifecycle {
        ignore_changes = [ value ]
    }
}
