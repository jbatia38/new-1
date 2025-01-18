variable "tags" {
type = map(string)
}
variable "region" {
    type = string
}

variable "ou_ids"{
    type = list(string)
}

variable "CentralizedAccountId" {
    type = string
}

variable "RoleName" {
    type = string
}


