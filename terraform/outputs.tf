output "function_url" {
  description = "The Cloud Function's trigger URL for monitoring"
  value       = module.compute.function_url
}

output "pubsub_topic" {
  description = "Pub/Sub created name"
  value       = module.pubsub.topic_name
}