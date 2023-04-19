{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "description": "Keep last ${countNumber} image(s)",
      "rulePriority": 1,
      "selection": {
        "countNumber": ${countNumber},
        "countType": "imageCountMoreThan",
        "tagStatus": "any"
      }
    }
  ]
}
