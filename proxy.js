const { createProxyMiddleware } = require('http-proxy-middleware');
const express = require('express');
const app = express();

app.use('/comfyui', createProxyMiddleware({
    target: 'http://localhost:8188',
    changeOrigin: true,
    pathRewrite: { '^/comfyui': '' }
}));

app.listen(3000, () => console.log('Proxy running on port 3000'));
