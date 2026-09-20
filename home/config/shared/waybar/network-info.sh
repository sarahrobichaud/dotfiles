#!/usr/bin/env bash

node -e "
const execSync = require('child_process').execSync;
const fs = require('fs');

const LAST_KNOWN_FILE = '/tmp/waybar-last-ip.json';

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

// 3. Fetch active public IP & location with fallbacks
let pubIp = '';
let country = '';
let countryCode = '';
let city = '';

// Primary: ip-api.com
try {
  const raw = execSync('curl -s --max-time 1.5 http://ip-api.com/json', { encoding: 'utf8' });
  const data = JSON.parse(raw);
  if (data.query) {
    pubIp = data.query;
    country = data.country || '';
    countryCode = data.countryCode || '';
    city = data.city || '';
  }
} catch(e) {}

// Fallback 1: ipinfo.io
if (!pubIp) {
  try {
    const raw = execSync('curl -s --max-time 1.5 https://ipinfo.io/json', { encoding: 'utf8' });
    const data = JSON.parse(raw);
    if (data.ip) {
      pubIp = data.ip;
      country = data.country || '';
      countryCode = data.country || '';
      city = data.city || '';
    }
  } catch(e) {}
}

// Fallback 2: api.ipify.org
if (!pubIp) {
  try {
    pubIp = execSync('curl -s --max-time 1.5 https://api.ipify.org', { encoding: 'utf8' }).trim();
  } catch(e) {}
}

// Fallback 3: Last known cached IP if network is in momentary transition
if (!pubIp || pubIp === 'Offline') {
  try {
    if (fs.existsSync(LAST_KNOWN_FILE)) {
      const lastData = JSON.parse(fs.readFileSync(LAST_KNOWN_FILE, 'utf8'));
      pubIp = lastData.pubIp || 'Connecting...';
      country = lastData.country || '';
      countryCode = lastData.countryCode || '';
      city = lastData.city || '';
    }
  } catch(e) {}
} else {
  // Save successful response
  try {
    fs.writeFileSync(LAST_KNOWN_FILE, JSON.stringify({ pubIp, country, countryCode, city }));
  } catch(e) {}
}

if (!pubIp) pubIp = 'Connecting...';

const cls = isWgUp ? 'connected' : 'disconnected';
const statusIcon = isWgUp ? '🛡️' : '⚠️';

let text = \`\${statusIcon} \`;
if (countryCode) text += \`\${countryCode} \`;
text += pubIp;
if (isWgUp && port) text += \`  🔌 \${port}\`;

let tooltipLines = [];
if (isWgUp) {
  tooltipLines = [
    '┌── ⚡ NETWORK & VPN STATUS ──┐',
    \`│ Status   : Protected 🛡️\`,
    \`│ Country  : \${country || countryCode || 'N/A'}\`,
    \`│ City     : \${city || 'N/A'}\`,
    \`│ Public IP: \${pubIp}\`,
    \`│ VPN Port : \${port || 'None'}\`,
    '└─────────────────────────────┘',
    '',
    \`• Left-click: Copy Forwarded Port (\${port || 'N/A'})\`,
    '• Right-click: Open Context Menu'
  ];
} else {
  tooltipLines = [
    '┌── ⚠️ NETWORK UNPROTECTED ──┐',
    \`│ Status   : Unprotected ⚠️\`,
    \`│ Country  : \${country || countryCode || 'N/A'}\`,
    \`│ City     : \${city || 'N/A'}\`,
    \`│ Real IP  : \${pubIp}\`,
    '└────────────────────────────┘',
    '',
    '• Right-click: Open Context Menu'
  ];
}

console.log(JSON.stringify({
  text: text,
  tooltip: tooltipLines.join('\\n'),
  class: cls,
  pub_ip: pubIp,
  country: country,
  country_code: countryCode,
  status_icon: statusIcon,
  port: port || 'N/A'
}));
"
