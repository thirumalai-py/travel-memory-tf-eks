# The eks module creates necessary IAM roles for nodes by default.
# You can create additional IAM policies / attach them using aws_iam_role_policy_attachment
# Example: attach AmazonEC2ContainerRegistryReadOnly to nodes (if needed)
resource "aws_iam_role_policy_attachment" "nodes_ecr_read" {
  depends_on = [module.eks]

  count = module.eks.node_groups != null ? 1 : 0

  role       = module.eks.node_groups["default"].iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
