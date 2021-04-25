resource "aws_kms_key" "nazolog_kms" {
    description = "Customer Master Key"
    enable_key_rotation = true
    is_enabled = true
    deletion_window_in_days = 30
}

resource "aws_kms_alias" "nazolog_kms_alias" {
    name = "alias/nazolog"
    target_key_id = aws_kms_key.nazolog_kms.key_id
}