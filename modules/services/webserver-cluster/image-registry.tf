# This create an elastic container registry
resource "aws_ecr_repository" "ecr_repo" {
 name                 = var.ecr
 force_delete = var.force_delete
 image_tag_mutability = var.image_tag_mutability

 image_scanning_configuration {
   scan_on_push = var.scan_on_push
 }
}

# Policy
resource "aws_ecr_repository_policy" "policy" {
  count      = var.policy == null ? 0 : 1
  repository = aws_ecr_repository.ecr_repo.name
  policy     = var.policy
}

# Lifecycle policy
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count      = var.lifecycle_policy == null ? 0 : 1
  repository = aws_ecr_repository.ecr_repo.name
  policy     = var.lifecycle_policy
}