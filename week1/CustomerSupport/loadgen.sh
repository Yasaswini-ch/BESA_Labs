#!/bin/bash
TOKEN="eyJraWQiOiJZbFN6M3BCbmNwN3IxNzFsT082VzdUaUlSYTQ5ZUVmTVp0azN0ODNaNkZvPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIwNDI4ZDQ4OC0yMDcxLTcwODktMWNiNy0yZGRiOWUzNDM1ZWUiLCJpc3MiOiJodHRwczovL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tL3VzLWVhc3QtMV9xZTNVUGlLbk0iLCJjbGllbnRfaWQiOiI2aWNqb2J2bHB2cGp2NWI3OW1xNHM5a2RwayIsIm9yaWdpbl9qdGkiOiJlZDg2YTk1Mi00YjA3LTQxODQtYjMxNC05MTkwYjlkYmQwNzMiLCJldmVudF9pZCI6IjU4NjYyM2Q5LWExMzQtNDNkYi1iZDg2LWIwZmRkMzFlNzNjNCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE3ODc0MjE3OTIsImV4cCI6MTc4NzQyNTM5MiwiaWF0IjoxNzg3NDIxNzkyLCJqdGkiOiJiMWMwZmQ0Zi1hNjYyLTQ1YzYtOWFjNS0xZDY5NjBlNTM0ZmMiLCJ1c2VybmFtZSI6IjA0MjhkNDg4LTIwNzEtNzA4OS0xY2I3LTJkZGI5ZTM0MzVlZSJ9.iwW4EXAdi18ta8nwHb2XzkAmIuorxs_txwTKZOnyPR9syN8MyL9RbS9sq39_Ist97RWPSX3gtuH_tY-rlyowcx59nvj7tRknOuDZGVtOQyPpYkuLdEARkxKOjSaX0zm-7xo9hgPjCEwoResoGTJDJiGKVbwaZyuamJ4B3zlYc4i8yOqHB3K6o82G9qvKkjcs93LGEyJDMmS22tz0UTsAcjwvN_aeD2_9728A5mPrLj-Vx7TmA3diDPPr1xT_E-DHu6ajAKKX5lt21Yi0DgcWUryh6E_FMGVKm9t32Ba-D0psyteLpuxBDW4BmLujhjQ9KtBMGGesdWLGIpLsfD51QQ"
GATEWAY_URL="https://customersupport-my-gateway-secure-3ides4tuwc.gateway.bedrock-agentcore.us-east-1.amazonaws.com/customer-support-ab/invocations"

PROMPTS=(
  "What's the price of the Smart Watch?"
  "My headphones are broken, what should I do?"
  "Is PROD-002 still under warranty?"
  "What's the return policy for audio products?"
  "It stopped working. Can I get a refund?"
  "I want to return my USB-C Hub and check its warranty."
)

for i in $(seq 1 30); do
  PROMPT="${PROMPTS[$(( (i - 1) % ${#PROMPTS[@]} ))]}"
  SESSION_ID=$(python3 -c "import uuid; print(str(uuid.uuid4()) + '-' + str(uuid.uuid4())[:8])")
  echo "=== Request $i: $PROMPT ==="
  curl -s \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -H "X-Amzn-Bedrock-AgentCore-Runtime-Session-Id: $SESSION_ID" \
    -d "{\"prompt\": \"$PROMPT\"}" \
    -X POST "$GATEWAY_URL"
  echo ""
  sleep 2
done
