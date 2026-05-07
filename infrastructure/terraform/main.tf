# infrastructure/main.tf — expand what already exists

# Core services to provision:
# - RDS PostgreSQL (db.t3.medium, Multi-AZ for prod)
# - ElastiCache Redis (cache.t3.micro)
# - ECS Fargate for:
#     - customer-web (Next.js)
#     - farmer-app (Next.js)
#     - admin-dashboard (Next.js)
#     - worker (BullMQ background jobs)
#     - meilisearch (search)
# - S3 bucket (product images, farmer docs, packing list PDFs)
# - CloudFront distribution (S3 + API cache)
# - ACM SSL certificates
# - Route53 DNS:
#     farmy.in → customer-web
#     farmer.farmy.in → farmer-app
#     admin.farmy.in → admin-dashboard
# - ECR repositories for each app
# - Secrets Manager for all API keys
# - CloudWatch alarms:
#     - API error rate > 1%
#     - Order processing lag > 5 min
#     - Failed payouts
