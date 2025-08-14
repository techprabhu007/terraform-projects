#!/bin/bash

# Ubuntu Web Server Setup Script for EC2 User Data
# Description: Sets up Apache web server on Ubuntu with custom welcome page

# Update package list
apt update -y

# Install Apache2
apt install apache2 -y

# Enable and start Apache2
systemctl enable apache2
systemctl start apache2

# Create custom index.html with modern styling
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform Project - Welcome</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: white;
        }
        .container {
            text-align: center;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            max-width: 600px;
            animation: fadeIn 1s ease-in;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .info {
            font-size: 1.2rem;
            margin: 1rem 0;
            opacity: 0.9;
        }
        .tech-stack {
            margin-top: 2rem;
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .tech-badge {
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.9rem;
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: transform 0.3s ease, background 0.3s ease;
        }
        .tech-badge:hover {
            transform: translateY(-3px);
            background: rgba(255, 255, 255, 0.3);
        }
        .footer {
            margin-top: 2rem;
            font-size: 0.9rem;
            opacity: 0.7;
        }
        .status-info {
            margin-top: 1.5rem;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.1);
            padding: 1rem;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        @media (max-width: 768px) {
            .container {
                margin: 1rem;
                padding: 2rem;
            }
            h1 {
                font-size: 2rem;
            }
            .tech-stack {
                gap: 0.5rem;
            }
            .tech-badge {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Welcome to Terraform Project!</h1>
        <div class="info">
            <p><strong>AWS Infrastructure Successfully Deployed</strong></p>
            <p>Region: ap-south-1 (Asia Pacific - Mumbai)</p>
            <p>Server: Ubuntu with Apache2</p>
        </div>
        <div class="tech-stack">
            <span class="tech-badge">🌍 Terraform</span>
            <span class="tech-badge">☁️ AWS</span>
            <span class="tech-badge">🐧 Ubuntu</span>
            <span class="tech-badge">🔧 Apache2</span>
        </div>
        <div class="status-info">
            <p><strong>Server Status:</strong> ✅ Online</p>
            <p><strong>Service:</strong> Apache2 Running</p>
            <p id="timestamp"></p>
        </div>
        <div class="footer">
            <p>Infrastructure as Code in Action ✨</p>
            <p>Powered by EC2 User Data Script</p>
        </div>
    </div>
    
    <script>
        // Display current timestamp
        document.getElementById('timestamp').innerHTML = 
            '<strong>Deployed:</strong> ' + new Date().toLocaleString();
            
        // Add some interactive effects
        document.querySelectorAll('.tech-badge').forEach(badge => {
            badge.addEventListener('click', function() {
                this.style.transform = 'scale(1.1)';
                setTimeout(() => {
                    this.style.transform = '';
                }, 200);
            });
        });
    </script>
</body>
</html>
EOF

# Set proper permissions
chown www-data:www-data /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Configure UFW firewall if available
if command -v ufw >/dev/null 2>&1; then
    ufw allow 'Apache Full'
fi

# Log completion
echo "$(date): Web server setup completed successfully" >> /var/log/user-data.log