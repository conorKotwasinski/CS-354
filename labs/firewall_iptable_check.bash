#!/bin/bash

score=0

# Check if outbound traffic to 8.8.8.8 is blocked
iptables_output=$(iptables -L OUTPUT)
if echo "${iptables_output}" | grep -q "REJECT.*8\.8\.8\.8"; then
  echo "Block only outbound traffic to 8.8.8.8: PASS"
  ((score++))
else
  echo "Block only outbound traffic to 8.8.8.8: FAIL"
fi

# Check if inbound traffic to port 5555 is allowed from private IP address ranges
iptables_output=$(iptables -L INPUT)
if echo "${iptables_output}" | grep -q "ACCEPT.*tcp.*dpt:5555.*10\.\|172\.\|192\."; then
  echo "Allow inbound traffic to port 5555, but only from private IP address ranges: PASS"
  ((score++))
else
  echo "Allow inbound traffic to port 5555, but only from private IP address ranges: FAIL"
fi

# Check if incoming traffic destined for port 80 is redirected to port 6666
iptables_output=$(iptables -L PREROUTING -t nat)
if echo "${iptables_output}" | grep -q "tcp dpt:http redir ports 6666"; then
  echo "Redirect incoming traffic destined for port 80 to port 6666: PASS"
  ((score++))
else
  echo "Redirect incoming traffic destined for port 80 to port 6666: FAIL"
fi

# Check if port 6666 is blocked from direct access
iptables_output=$(iptables -S | grep -E "(^|\s)-A\s(PREROUTING|INPUT)\s.*\s(--dport|mark\s--mark)\s")
if [ -z "$iptables_output" ]; then
  echo "(Extra credit) Block port 6666 from direct access: FAIL"
else
  echo "(Extra credit) Block port 6666 from direct access: PASS"
  ((score++))
fi

echo "Score: ${score}/3"
