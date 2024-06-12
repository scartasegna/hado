variable "aws_access_key" {
    description = "The IAM public access key"
    default = ""
}

variable "aws_secret_key" {
    description = "IAM secret access key"
    default = ""
}

variable "aws_region" {
    description = "The AWS region things are created in"
    default=""
}

variable "ec2_task_execution_role_name" {
    description = "ECS task execution role name"
    default = "myEcsTaskExecutionRole"
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "kodekloud/ecs-project1:latest"
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default = 3000

}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "2048"
}