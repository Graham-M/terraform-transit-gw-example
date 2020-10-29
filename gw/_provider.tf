provider "aws" {
  region  = "eu-west-2"
  profile = "stage-apptest0"
  alias   = "apptest0"
}

provider "aws" {
  region  = "eu-west-2"
  profile = "stage-apptest1"
  alias   = "apptest1"
}

provider "aws" {
  region  = "eu-west-2"
  profile = "stage-apptest2"
  alias   = "apptest2"
}
