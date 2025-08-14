#!/bin/bash

# Ubuntu Web Server Setup Script for EC2 User Data - Server 2
# Description: Sets up Apache web server with dark cyberpunk theme

# Update package list
apt update -y

# Install Apache2
apt install apache2 -y

# Enable and start Apache2
systemctl enable apache2
systemctl start apache2

# Create custom index.html with dark cyberpunk styling
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Terraform Project - Server 2</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Orbitron', monospace;
            background: #0a0a0a;
            color: #00ff41;
            overflow-x: hidden;
            min-height: 100vh;
            position: relative;
        }
        
        /* Matrix-like background animation */
        .matrix-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, #000000 0%, #001100 50%, #000000 100%);
            z-index: -2;
        }
        
        .matrix-bg::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(circle at 25% 25%, #00ff41 1px, transparent 1px),
                radial-gradient(circle at 75% 75%, #00ff41 1px, transparent 1px);
            background-size: 50px 50px;
            background-position: 0 0, 25px 25px;
            opacity: 0.1;
            animation: matrixMove 20s linear infinite;
        }
        
        @keyframes matrixMove {
            0% { transform: translateY(-50px); }
            100% { transform: translateY(50px); }
        }
        
        .container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }
        
        .terminal-window {
            background: rgba(0, 0, 0, 0.9);
            border: 2px solid #00ff41;
            border-radius: 10px;
            padding: 0;
            max-width: 800px;
            width: 100%;
            box-shadow: 
                0 0 20px #00ff41,
                inset 0 0 20px rgba(0, 255, 65, 0.1);
            animation: terminalGlow 2s ease-in-out infinite alternate;
        }
        
        @keyframes terminalGlow {
            0% { box-shadow: 0 0 20px #00ff41, inset 0 0 20px rgba(0, 255, 65, 0.1); }
            100% { box-shadow: 0 0 30px #00ff41, inset 0 0 30px rgba(0, 255, 65, 0.2); }
        }
        
        .terminal-header {
            background: #00ff41;
            color: #000;
            padding: 0.5rem 1rem;
            font-weight: 700;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 8px 8px 0 0;
        }
        
        .terminal-buttons {
            display: flex;
            gap: 0.5rem;
        }
        
        .terminal-button {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #000;
        }
        
        .terminal-content {
            padding: 2rem;
            background: rgba(0, 0, 0, 0.8);
            border-radius: 0 0 8px 8px;
        }
        
        .glitch-text {
            font-size: 3rem;
            font-weight: 900;
            text-align: center;
            margin-bottom: 1rem;
            position: relative;
            color: #00ff41;
            animation: glitch 2s infinite;
        }
        
        @keyframes glitch {
            0%, 100% { text-shadow: 0 0 10px #00ff41; }
            25% { text-shadow: -2px 0 #ff0040, 2px 0 #00ff41; }
            50% { text-shadow: 2px 0 #ff0040, -2px 0 #00ff41; }
            75% { text-shadow: 0 0 10px #00ff41; }
        }
        
        .server-info {
            background: rgba(0, 255, 65, 0.1);
            border: 1px solid #00ff41;
            border-radius: 8px;
            padding: 1.5rem;
            margin: 1.5rem 0;
            position: relative;
        }
        
        .server-info::before {
            content: '>>> SYSTEM STATUS';
            position: absolute;
            top: -10px;
            left: 10px;
            background: #0a0a0a;
            padding: 0 10px;
            font-size: 0.8rem;
            color: #00ff41;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin: 1rem 0;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid rgba(0, 255, 65, 0.3);
        }
        
        .tech-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }
        
        .tech-card {
            background: rgba(0, 255, 65, 0.1);
            border: 1px solid #00ff41;
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        
        .tech-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(0, 255, 65, 0.1), transparent);
            transition: transform 0.6s;
            transform: rotate(45deg) translate(-100%, -100%);
        }
        
        .tech-card:hover::before {
            transform: rotate(45deg) translate(100%, 100%);
        }
        
        .tech-card:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 10px 25px rgba(0, 255, 65, 0.3);
        }
        
        .tech-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }
        
        .status-bar {
            background: rgba(0, 255, 65, 0.2);
            padding: 1rem;
            border-radius: 8px;
            margin-top: 2rem;
            text-align: center;
            position: relative;
        }
        
        .typing-text {
            border-right: 2px solid #00ff41;
            animation: typing 3s steps(40, end), blink-cursor 0.75s step-end infinite;
            white-space: nowrap;
            overflow: hidden;
        }
        
        @keyframes typing {
            from { width: 0; }
            to { width: 100%; }
        }
        
        @keyframes blink-cursor {
            from, to { border-color: transparent; }
            50% { border-color: #00ff41; }
        }
        
        .footer-text {
            text-align: center;
            margin-top: 2rem;
            opacity: 0.7;
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .glitch-text {
                font-size: 2rem;
            }
            .container {
                padding: 1rem;
            }
            .terminal-content {
                padding: 1rem;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .tech-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <div class="matrix-bg"></div>
    
    <div class="container">
        <div class="terminal-window">
            <div class="terminal-header">
                <span>TERRAFORM_SERVER_02.exe</span>
                <div class="terminal-buttons">
                    <div class="terminal-button"></div>
                    <div class="terminal-button"></div>
                    <div class="terminal-button"></div>
                </div>
            </div>
            
            <div class="terminal-content">
                <h1 class="glitch-text">⚡ SERVER 02 ONLINE</h1>
                
                <div class="server-info">
                    <div class="info-grid">
                        <div class="info-item">
                            <span>STATUS:</span>
                            <span style="color: #00ff41;">✓ OPERATIONAL</span>
                        </div>
                        <div class="info-item">
                            <span>REGION:</span>
                            <span>AP-SOUTH-1</span>
                        </div>
                        <div class="info-item">
                            <span>OS:</span>
                            <span>UBUNTU 22.04</span>
                        </div>
                        <div class="info-item">
                            <span>SERVICE:</span>
                            <span>APACHE2</span>
                        </div>
                        <div class="info-item">
                            <span>UPTIME:</span>
                            <span id="uptime">CALCULATING...</span>
                        </div>
                        <div class="info-item">
                            <span>DEPLOYED:</span>
                            <span id="timestamp">LOADING...</span>
                        </div>
                    </div>
                </div>
                
                <div class="tech-grid">
                    <div class="tech-card">
                        <span class="tech-icon">🔧</span>
                        <div>TERRAFORM</div>
                        <small>IaC Platform</small>
                    </div>
                    <div class="tech-card">
                        <span class="tech-icon">☁️</span>
                        <div>AWS EC2</div>
                        <small>Cloud Compute</small>
                    </div>
                    <div class="tech-card">
                        <span class="tech-icon">🐧</span>
                        <div>UBUNTU</div>
                        <small>Linux OS</small>
                    </div>
                    <div class="tech-card">
                        <span class="tech-icon">🌐</span>
                        <div>APACHE2</div>
                        <small>Web Server</small>
                    </div>
                </div>
                
                <div class="status-bar">
                    <div class="typing-text" id="status-message">
                        Infrastructure as Code deployment successful...
                    </div>
                </div>
                
                <div class="footer-text">
                    <p>CYBERPUNK THEME | POWERED BY EC2 USER DATA</p>
                    <p>Server Instance: Production Ready ⚡</p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Update timestamp
        document.getElementById('timestamp').textContent = new Date().toLocaleString();
        
        // Simulate uptime counter
        let startTime = Date.now();
        function updateUptime() {
            let uptime = Math.floor((Date.now() - startTime) / 1000);
            let hours = Math.floor(uptime / 3600);
            let minutes = Math.floor((uptime % 3600) / 60);
            let seconds = uptime % 60;
            document.getElementById('uptime').textContent = 
                `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }
        setInterval(updateUptime, 1000);
        
        // Typing animation for status message
        const messages = [
            'Infrastructure as Code deployment successful...',
            'All systems operational and secure...',
            'Ready for production workloads...',
            'Terraform automation complete...'
        ];
        
        let messageIndex = 0;
        function rotateMessages() {
            const element = document.getElementById('status-message');
            element.style.width = '0';
            setTimeout(() => {
                element.textContent = messages[messageIndex];
                element.style.width = '100%';
                messageIndex = (messageIndex + 1) % messages.length;
            }, 1000);
        }
        
        setInterval(rotateMessages, 4000);
        
        // Interactive tech cards
        document.querySelectorAll('.tech-card').forEach(card => {
            card.addEventListener('click', function() {
                this.style.transform = 'translateY(-5px) scale(1.1)';
                setTimeout(() => {
                    this.style.transform = '';
                }, 300);
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
echo "$(date): Server 2 web setup completed successfully" >> /var/log/user-data.log