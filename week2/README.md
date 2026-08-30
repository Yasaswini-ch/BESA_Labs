# Week 2 — Building Agentic AI Architectures with AWS Serverless

**BeSA Cohort 10 | Week 2 | Event 7**
Workshop: [Building Agentic AI architectures with AWS Serverless](https://catalog.us-east-1.prod.workshops.aws/event/dashboard/en-US/workshop)

## Overview

This workshop covers building **multi-agent systems on AWS** using two different coordination patterns, plus how to layer in human-in-the-loop (HITL) approval and observability. The scenario throughout is a travel booking pipeline with a Planner, Weather, and Flight Booking agent — each running as its own AWS Lambda function with its own personality and toolset.

## What Was Built

- **Agents on Lambda** — Planner, Weather, and Flight Booking agents, each with their own personality and tools
- **Choreography with EventBridge** (Module 1) — loosely coupled agents reacting to events (`DatesFinalized`, `FlightSearchCompleted`, etc.). Easy to scale by adding new rules/targets without touching existing agents
- **Orchestration with Step Functions** (Module 2) — a centralized state machine controlling sequence, branching, retries, and the HITL path
- **Human-in-the-Loop (HITL)** — escalation path via SQS/task tokens where high-risk bookings pause for manual approval before proceeding
- **Observability** — logs correlated by booking ID, tracing across EventBridge, Step Functions, and Lambda, visualized in X-Ray
- **[Bonus] Hotel Recommendation Agent** — an additional agent extending the choreography pattern, see [`bonus-hotel-agent/`](./bonus-hotel-agent)

## Folder Structure

\`\`\`
week2/
├── module2-orchestration/
│   ├── travel-booking-orchestration.json   # Step Functions state machine definition
│   └── high-risk-booking.json              # Sample test event that triggers the HITL path
└── bonus-hotel-agent/
    ├── lambda_function.py                  # Hotel recommendation agent Lambda handler
    ├── hotel-agent.zip                     # Deployment package
    └── README.md
\`\`\`

> Module 1 (choreography) was primarily built and explored through the AWS Console and pre-provisioned Lambda functions/EventBridge rules rather than local source files, so no standalone artifacts exist for it in this repo.

## Key Learnings

- **Serverless agents scale naturally** — Lambda removes infrastructure overhead and provides cost efficiency (pay only for execution time)
- **Choreography = flexibility** — EventBridge fan-out makes it easy to extend systems by adding new agents without touching existing code
- **Orchestration = control** — Step Functions provide strict sequencing, error handling, and auditability for workflows that require guarantees
- **HITL is essential for trust** — not all decisions should be automated; routing to manual review makes systems more reliable and compliant
- **Observability is non-negotiable** — CloudWatch, Logs Insights, and X-Ray give the visibility needed to debug, trace, and optimize distributed systems at scale

## When to Use Which Pattern

**Choreography** is best when:
- Agents are added/removed frequently
- Agents can run independently with minimal coupling
- Event-driven scalability is the priority

**Orchestration** is best when:
- Order of execution matters
- Retries, error handling, or compensation logic are needed
- Compliance requires full audit trails

In real systems, both patterns are often combined — EventBridge for broad distribution, Step Functions for critical orchestrated workflows.

## AWS Services Used

Lambda · EventBridge · Step Functions · SQS · S3 · SNS · CloudWatch (Logs, Logs Insights) · X-Ray
