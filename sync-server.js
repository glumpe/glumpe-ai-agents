const http = require('http');
const { spawn } = require('child_process');

const server = http.createServer((req, res) => {
  if (req.method === 'POST' && req.url === '/sync-agent') {
    let body = '';
    
    req.on('data', chunk => {
      body += chunk.toString();
    });
    
    req.on('end', () => {
      const script = spawn('/opt/glumpe-ai-agents/sync-agent.sh');
      
      script.stdin.write(body);
      script.stdin.end();
      
      let output = '';
      script.stdout.on('data', data => {
        output += data;
      });
      
      script.on('close', () => {
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(output);
      });
    });
  } else {
    res.writeHead(404);
    res.end('Not found');
  }
});

server.listen(3456, 'localhost', () => {
  console.log('Sync server running on http://localhost:3456');
});
