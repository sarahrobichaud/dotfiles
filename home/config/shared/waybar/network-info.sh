#!/usr/bin/env bash

node -e "
const execSync = require('child_process').execSync;

// 1. Check if wg0 interface is active
let isWgUp = false;
try {
  const wgCheck = execSync('ip -br link show dev wg0 2>/dev/null', { encoding: 'utf8' });
  isWgUp = wgCheck.includes('UP');
} catch(e) {}

// 2. Query NAT-PMP for port mapping ONLY if WireGuard is active
let port = '';
if (isWgUp) {
  try {
    const natpmpOut = execSync('timeout 1 natpmpc -g 10.2.0.1 -a 1 0 tcp 60 2>/dev/null', { encoding: 'utf8' });
    const portMatch = natpmpOut.match(/Mapped public port (\d+)/);
    if (portMatch) port = portMatch[1];
  } catch(e) {}
}

const cls = isWgUp ? 'connected' : 'disconnected';
const statusIcon = isWgUp ? '🛡️' : '⚠️';

// Never display public IP or location — the bar is on screen during streams,
// screenshots and screen shares. Status word only.
let text = \`\${statusIcon} \${isWgUp ? 'Protected' : 'Unprotected'}\`;
if (isWgUp && port) text += \`  🔌 \${port}\`;

const tooltipLines = isWgUp
  ? [
      '┌── ⚡ NETWORK & VPN STATUS ──┐',
      '│ Status   : Protected 🛡️',
      \`│ VPN Port : \${port || 'None'}\`,
      '└─────────────────────────────┘',
      '',
      \`• Left-click: Copy Forwarded Port (\${port || 'N/A'})\`,
      '• Right-click: Open Context Menu',
    ]
  : [
      '┌── ⚠️ NETWORK UNPROTECTED ──┐',
      '│ Status   : Unprotected ⚠️',
      '└────────────────────────────┘',
      '',
      '• Right-click: Open Context Menu',
    ];

console.log(JSON.stringify({
  text: text,
  tooltip: tooltipLines.join('\\n'),
  class: cls,
  status_icon: statusIcon,
  port: port || 'N/A'
}));
"
