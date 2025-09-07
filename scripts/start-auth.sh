#!/bin/bash

# KaziApp Authentication Service Startup Script
# This script delegates to the main auth service startup script

set -e

echo "🔐 Starting KaziApp Authentication Service..."

# Navigate to auth service directory and run the main startup script
cd "$(dirname "$0")/../services/auth-service"
./scripts/start-auth.sh
