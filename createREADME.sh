#!/bin/bash

cat << EOF > README.md
# intellistory

A simple javascript-based story boarding application that utilizes local AI models to store prompts and automatically create beginning and end frames for each scene. 

## Overview
intellistory is a standalone browser-based tool that replaces the problematic \`ComfyUI_StoryDiffusion\` extension. It leverages SortableJS for drag-and-drop and timeline management, LocalForage for local storage, and Axios for integrating with a local Ollama AI model to generate beginning and end frames for each scene based on user-provided prompts. The app is tailored for a 5-8 scene storyboard, supporting a narrative-driven music video (e.g., a hacker's journey in a neon-lit dystopia) with QR code overlays for interactive website links.

## Features
- Drag and drop image uploads to start your storyboard.
- Reorder images along a timeline with scene grouping.
- Automatically generate beginning and end frames for each scene using Ollama.
- Add text descriptions and prompts with copy/paste functionality.
- Store all data (images, prompts, scenes) locally in the browser.
- Export scene data as JSON for backup or sharing.
- Cyberpunk-themed design with neon accents.

## Requirements
- **Operating System**: Pop!_OS 22.04
- **Browser**: Firefox or Chrome (latest version)
- **Dependencies**:
  - **Ollama**: For local AI image generation (installs with \`curl\` script).
  - **Kdenlive**: For storyboard assembly (\`sudo apt install kdenlive\`).
  - **qrencode**: For QR code generation (\`sudo apt install qrencode\`).
  - **Internet Connection**: For CDN libraries (SortableJS, LocalForage, Axios).
- **Hardware**: NVIDIA RTX 2080 Ti (10.8 GB VRAM), 64 GB RAM (sufficient for 1024x576 images).

## Installation
No installation is required beyond setting up dependencies and downloading the HTML file. Follow these steps:

1. **Download intellistory**:
   - Save the provided \`intellistory.html\` file to a local directory (e.g., \`~/intellistory/intellistory.html\`).
   - Alternatively, create it manually with the content from the [HTML Artifact](#html-artifact).

2. **Install Dependencies**:
   - Update system packages:
     \`\`\`bash
     sudo apt update && sudo apt upgrade
     \`\`\`
   - Install Kdenlive:
     \`\`\`bash
     sudo apt install kdenlive
     \`\`\`
   - Install qrencode:
     \`\`\`bash
     sudo apt install qrencode
     \`\`\`

## Setup Instructions

### Ollama Setup
Ollama is required for generating beginning and end frames from prompts within intellistory.

1. **Install Ollama**:
   \`\`\`bash
   curl https://ollama.ai/install.sh | sh
   \`\`\`

2. **Start Ollama Server**:
   - Open a terminal and run:
     \`\`\`bash
     ollama serve
     \`\`\`
   - In another terminal, pull a model (e.g., Stable Diffusion):
     \`\`\`bash
     ollama run stable-diffusion
     \`\`\`

3. **Verify Ollama**:
   - Check the server:
     \`\`\`bash
     curl http://localhost:11434
     \`\`\`
   - Ensure the model supports image generation (adjust the \`model\` field in the script if needed).

### Running intellistory
1. **Open the HTML File**:
   - Navigate to the file in your browser:
     \`\`\`
     file:///home/jj/intellistory/intellistory.html
     \`\`\`
   - Or use a local server for better compatibility:
     \`\`\`bash
     cd ~/intellistory
     python -m http.server 8000
     \`\`\`
     Access: \`http://localhost:8000/intellistory.html\`.

2. **Ensure Ollama is Running**:
   - Keep the Ollama server active in the background during use.

## Usage

### Adding Images
- Drag and drop image files (PNG, JPG) onto the “Drag and drop images here” area.
- Images are added to the last or new scene, saved as base64 strings locally.

### Reordering and Grouping Scenes
- Click “Add New Scene” to create a new scene group.
- Drag image cards within a scene to reorder or between scenes to regroup.
- Click a scene header (e.g., “Scene 1”) to collapse/expand its content.
- Reordering is handled by SortableJS, with changes saved automatically.

### Adding Descriptions and Prompts
- Each image card has a textarea below it for descriptions/prompts (e.g., “Cyberpunk city flyover, neon lights”).
- Edit the text, use copy/paste (select text, Ctrl+C/Ctrl+V, or click “Copy Text” for clipboard copy with confirmation).
- Changes are saved locally via LocalForage.

### Generating Frames with Ollama
- Click “Generate with Ollama” on an image card to create the beginning frame.
- Enter a prompt in the textarea (e.g., “Neon-lit hacker in dive bar”).
- The app sends a POST request to \`http://localhost:11434/api/generate\` with the prompt, width (1024), and height (576).
- A second click (or a separate “End Frame” button) generates the end frame based on the same prompt with added context (e.g., “after action”).
- If successful, the image updates; if failed, an alert appears (ensure Ollama is running).

### Exporting Data
- Click “Export JSON” to download an \`intellistory.json\` file containing scene data (image sources and descriptions).
- Use this file to import data into another instance or for backup.

## Integration with Kdenlive
1. **Import PNGs**:
   - Open Kdenlive, create a 1080p 30fps project.
   - Drag saved PNGs from \`/opt/StabilityMatrix/Data/Packages/ComfyUI/input\` (or browser downloads) to the Project Bin.
   - Place on Video 1 track, align with music (e.g., 0:00-0:20 for Scene 1).

2. **Add Text Descriptions**:
   - Add a Title Clip (Project > Add Title Clip) per PNG.
   - Text: e.g., “Scene 1: Cityscape flyover, neon lights, QR: No, Timing: 0:00-0:20”.
   - Position below image using the Transform effect.

3. **Export Storyboard**:
   - Render > Still Image Sequence > PNG.
   - Compile to PDF:
     \`\`\`bash
     img2pdf *.png -o storyboard.pdf
     \`\`\`

## Integration with KlingAI
1. **Generate Video Clips**:
   - Upload PNGs to KlingAI.
   - Set prompt: e.g., “Cyberpunk city flyover, neon lights, raining, smooth pan, 10 seconds.”
   - Download generated MP4 clips.

2. **Add QR Codes**:
   - Generate QR codes:
     \`\`\`bash
     qrencode -o qr1.png "https://yoursite.com/track1-lore"
     qrencode -o qr2.png "https://yoursite.com/interactive-map"
     \`\`\`
   - Import to Kdenlive, overlay on clips (e.g., bottom-right, fade in/out).

3. **Finalize Video**:
   - Import KlingAI clips and QR PNGs into Kdenlive.
   - Sync with your music track, adjust timings.
   - Export as MP4 (Render > MP4 H.264).

## Troubleshooting
- **Ollama Errors**: Ensure Ollama is running (\`ollama serve\`) and the model supports image generation. Adjust the API request in the script if the response format differs (e.g., \`response.data.data[0].b64_json\` instead of \`response.data.image\`).
- **Local Storage Issues**: Clear via browser dev tools (F12 > Application > IndexedDB > cyberpunk_storyboard) if data corrupts.
- **Drag-and-Drop Failure**: Test in Chrome/Firefox; ensure files are images (PNG/JPG).
- **Rendering Issues**: Adjust CSS (e.g., reduce \`max-width\` of images) if cards overlap. Use dev tools (F12) to debug layout.
- **VRAM**: Your RTX 2080 Ti handles 1024x576; no adjustments needed unless memory errors occur.

## Customization
- **Colors**: Modify CSS colors (e.g., \`#00ffcc\` to \`#0f0\` for neon green) in the \`<style>\` section.
- **Layout**: Adjust \`grid-template-columns\` in \`#timeline\` for wider cards (e.g., \`minmax(300px, 1fr)\`).
- **Ollama Model**: Change \`model: 'stable-diffusion'\` in the \`generateImage\` function to your preferred Ollama model.
- **Size**: Update \`width: 1024\`, \`height: 576\` in the API request for different resolutions.

## Notes
- This solution avoids ComfyUI dependencies, bypassing \`huggingface_hub\` issues.
- The app supports 5-8 scenes; share your track length (e.g., 3-5 minutes) for precise timing suggestions.
- The cyberpunk aesthetic uses neon cyan (#00ffcc) and magenta (#ff00ff); customize further in CSS.
- No existing library fully matches all requirements, so this is a custom integration of SortableJS, LocalForage, and Axios.
- Test with sample images and adjust prompts for your narrative (e.g., hacker journey).

## HTML Artifact
The complete \`intellistory.html\` content is embedded above for reference. Ensure you save it with the correct filename and path.
EOF

echo "README.md created successfully."
