# Messaging Proxy Service Infrastructure

This repository contains Terraform configuration files to provision an AWS-based infrastructure for the Messaging Proxy Service (MPS). The design decouples Kafka consumption from message processing by using separate services for reading from Kafka and processing messages, ensuring in-order delivery by key and addressing issues like consumer rebalancing and poison pills.

## Overview

The infrastructure consists of the following key components:

- **VPC & Networking:** Provisioned using the Terraform AWS VPC module.
- **EKS Cluster:** Runs containerized services for MPS, Consumer Service, Kafka Connect, and a CronJob for Kafka Offset Commit.
- **AWS MSK (Kafka) Cluster:** Handles high-throughput messaging.
- **DLQ Topic:** Configured using the Confluent provider for handling failed or poison pill messages.
- **Kubernetes Deployments:**
  - **Messaging Proxy Service (MPS):** Consumes Kafka messages using a lightweight reader thread and processes them with writer threads.
  - **Consumer Service:** Stateless REST service that contains the business logic for processing messages.
  - **Kafka Connect:** Optionally deployed to support sink connectors and DLQ handling.
  - **Offset Commit CronJob:** Periodically commits Kafka offsets for messages processed successfully.

## Architecture

The architecture separates the responsibilities as follows:

- **Reader Thread:** Polls Kafka and writes to a bounded buffer.
- **Writer Threads:** Consume from the buffer to send messages to REST endpoints.
- **Order Iterator:** Ensures that keyed messages are processed in order.
- **Dead Letter Queue (DLQ):** Handles message failures after fixed retries.
- **Consumer Service:** Processes messages using stateless REST endpoints.
- **Offset Commit Thread:** Regularly commits processed offsets back to Kafka.

## Prerequisites

- **Terraform:** v0.14+ (or later)
- **AWS CLI and Credentials:** Configured for your AWS account.
- **Kubernetes CLI (kubectl):** Configured to interact with your EKS cluster.
- **kubectl configuration:** Ensure your kubeconfig points to the correct EKS cluster.
- **Docker images:** Replace placeholder image names (e.g. `your-docker-registry/mps:latest`) with your actual image locations.

## Setup and Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/fayazkhan121/messaging-proxy-service.git
   cd messaging-proxy-service
