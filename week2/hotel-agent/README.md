# Week 2 — Hotel Recommendation Agent

**BeSA Cohort 10 | Week 2 | Event 7**
Workshop: [Building Agentic AI architectures with AWS Serverless](https://catalog.us-east-1.prod.workshops.aws/event/dashboard/en-US/workshop)

## Overview

This lab implements a **Hotel Recommendation Agent** — one node in a larger multi-agent, event-driven serverless architecture built on AWS Lambda, Amazon EventBridge, S3, and SNS. The agent is triggered by a booking event, recommends hotels for the traveler's destination and budget, and sends a witty, humorous email with its picks.

## Architecture

- **Trigger:** Amazon EventBridge event (`booking finalized`) on a shared `multi-agent-bus`
- **Compute:** AWS Lambda (`merged-multi-agent-workshop-hotel-agent`)
- **Agent framework:** Strands Agents SDK, backed by an Anthropic Claude model
- **Session state:** Shared S3-backed session (`S3SessionManager`), using the same session prefix as the upstream planner agent so context carries across agents
- **Notification:** Amazon SNS (email delivery)
- **Output:** Publishes a `HotelRecommendationsReady` event back onto the shared event bus for downstream agents

## Files

| File | Description |
|---|---|
| `lambda_function.py` | Lambda handler + agent definition, tools (`find_hotels`, `send_email`), and event publishing logic |
| `hotel-agent.zip` | Deployment package (zipped source) used to update the pre-provisioned Lambda function |

## Tools

- **`find_hotels(destination, budget_per_night)`** — looks up hotel options from a small in-memory dataset (Miami, New York, Los Angeles) filtered by budget
- **`send_email(subject, message, user_email)`** — publishes the agent's generated email to an SNS topic

## Deployment

The Lambda function (`merged-multi-agent-workshop-hotel-agent`) is pre-provisioned by the workshop with its IAM role, environment variables (`EVENT_BUS_NAME`, `SNS_TOPIC_ARN`, `SESSION_BUCKET`), and EventBridge trigger already configured. Code updates are pushed with:

\`\`\`bash
zip hotel-agent.zip lambda_function.py
aws lambda update-function-code \
  --function-name merged-multi-agent-workshop-hotel-agent \
  --zip-file fileb://hotel-agent.zip
\`\`\`

## Notes

This lab builds on the multi-agent event-driven pattern introduced earlier in the workshop — the hotel agent is one of several specialized agents reacting to events on a shared EventBridge bus, each contributing part of the overall trip-planning workflow.
