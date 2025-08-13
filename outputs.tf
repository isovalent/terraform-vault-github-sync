output "github_svt_path" {
  description = "GitHub SVT Path"
  value = {
    path = "${var.organization}${var.repository != "" ? "/${var.repository}" : ""}${var.environment != "" ? "/${var.environment}" : ""}/${var.github_svt.name}"
    key  = var.github_svt.key
    type = var.type

    created_at = (
      var.type == "variable" ?
      (
        var.repository == "" ?
        github_actions_organization_variable.variable[0].created_at :
        (
          var.environment == "" ?
          github_actions_variable.variable[0].created_at :
          github_actions_environment_variable.variable[0].created_at
        )
        ) : (
        var.repository == "" ?
        github_actions_organization_secret.secret[0].created_at :
        (
          var.environment == "" ?
          github_actions_secret.secret[0].created_at :
          github_actions_environment_secret.secret[0].created_at
        )
      )
    )

    updated_at = (
      var.type == "variable" ?
      (
        var.repository == "" ?
        github_actions_organization_variable.variable[0].updated_at :
        (
          var.environment == "" ?
          github_actions_variable.variable[0].updated_at :
          github_actions_environment_variable.variable[0].updated_at
        )
        ) : (
        var.repository == "" ?
        github_actions_organization_secret.secret[0].updated_at :
        (
          var.environment == "" ?
          github_actions_secret.secret[0].updated_at :
          github_actions_environment_secret.secret[0].updated_at
        )
      )
    )
  }
}
