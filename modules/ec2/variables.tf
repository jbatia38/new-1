variable "ami_id" {
    type = string
    default = null
}

variable "instance_type" {
    type = list(string)
    default = null
}

variable "tags" {
    type = map(string) 
    default = null # using null in this default varianle value, indicates to terraform that the variable is optional
}