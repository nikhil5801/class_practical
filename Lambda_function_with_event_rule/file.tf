
data "archive_file" "start" {
  type        = "zip"
  source_file = "start_instance_code.py"
  output_path = "start_instances.zip"
}


data "archive_file" "stop" {
  type        = "zip"
  source_file = "stop_instance_code.py"
  output_path = "stop_instances.zip"
}

