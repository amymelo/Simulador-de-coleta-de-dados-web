<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Simulador de coleta de dados web</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500&display=swap" rel="stylesheet">

<style>
body {
    margin: 0;
    font-family: monospace;
    background: #05070d;
    color: #d1ffe8;
}

/* Fundo preto */
body::before {
    content: "";
    position: fixed;
    inset: 0;
    background: #000;
    z-index: -1;
}
    
  /* Fundo com glow */  
body.glow::before {
    content: "";
    position: fixed;
    inset: 0;
    background: radial-gradient(circle at bottom, #0b3d1a, transparent 90%);
    z-index: -1;
}

@keyframes glowMove {
    0% { transform: scale(1); opacity: 0.6; }
    100% { transform: scale(1.2); opacity: 1; }
}

/* Texto de carregamento */
#terminal {
    padding: 25px;
    font-family: "Courier New", monospace;
    font-size: 18px;
    color: #00ff00;
    text-shadow: 0 0 6px rgba(0,255,180,0.25);
    white-space: pre-line;
}

/* Dashboard */
#dashboard {
    display: none;
    padding: 25px;
}

h1 {
    text-align: center;
    color: #00ffcc;
    margin-bottom: 25px;
}

/* Texto de aviso */
#textoinfo {
    display: none;
    margin: 10px auto 20px;
    max-width: 700px;
    padding: 12px 16px;
    border-radius: 10px;
    background: rgba(0, 255, 170, 0.05);
    border: 1px solid rgba(0, 255, 170, 0.15);
    color: Red;
    font-size: 13px;
    text-align: center;
    white-space: pre-line;
}

/* GRID */
.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 14px;
}

.card {
    background: rgba(255,255,255,0.03);
    border: 1px solid rgba(0,255,170,0.12);
    border-radius: 10px;
    padding: 14px 16px;
    box-shadow: 0 0 10px rgba(0,255,170,0.05);
    backdrop-filter: blur(8px);

    }

/* hover sutil pra borda brilhante */
.card:hover {
    border-color: rgba(0,255,170,0.35);
    box-shadow: 0 0 14px rgba(0,255,170,0.12);
}

/* LABELS Texto dos tipos de dados */
.label {
    font-size: 12px;
    letter-spacing: 1px;
    color: #00ffaa;
    opacity: 0.8;
}

/* Valores dos dados obtidos */
.value {
    margin-top: 6px;
    font-size: 14px;
    color: #eafff6;
    word-break: break-word;
}

/* LOADING dos dados */
.loading {
    opacity: 0.5;
    animation: pulse 1.5s infinite;
}

@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.4; }
}
</style>
</head>
<body>

<div id="terminal"></div>

<div id="dashboard">
    <h1>Simulador de coleta de dados web</h1>

    <!--Texto de aviso!-->
    <div id="textoinfo">Nenhum dado é armazenado.
        
As informações abaixo são obtidas diretamente do seu dispositivo e podem ser acessadas por diversos sites durante a navegação.
Este painel tem apenas finalidade demonstrativa, para mostrar quais tipos de dados um site pode coletar automaticamente.
    </div>

    <!--Labels dos texto de tipo de dados!-->
    <div class="grid">

        <div class="card"><div class="label">Endereço IP</div><div id="ip" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Localização</div><div id="location" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Provedor de internet</div><div id="org" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Sistema</div><div id="device" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Navegador</div><div id="browser" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Idioma</div><div id="lang" class="value loading">loading...</div></div>

        <div class="card"><div class="label">Resolução da Tela</div><div id="screen" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Fuso horário</div><div id="timezone" class="value loading">loading...</div></div>
        <div class="card"><div class="label">CPU (threads)</div><div id="cpu" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Memória aproximada</div><div id="memory" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Canvas Fingerprint</div><div id="canvas" class="value loading">loading...</div></div>

        <div class="card"><div class="label">WebGL</div><div id="webgl" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Audio Fingerprint</div><div id="audio" class="value loading">loading...</div></div>
        <div class="card"><div class="label">Extras</div><div id="extra" class="value loading">loading...</div></div>

    </div>
</div>

<script>    
const terminal = document.getElementById("terminal");
const textoinfo = document.getElementById("textoinfo");
 
    /* Tela de carregamento */
const mensagens = [
    "Inicializando sistema...",
    "Carregando módulos...",
    "Estabelecendo conexão...",
    "Coletando informações do navegador...",
    "Processando dados...",
    "Finalizando..."
];

function digitar(texto, callback) {
    let i = 0;

    function escrever() {
        if (i < texto.length) {
            terminal.innerHTML += texto.charAt(i);
            i++;
            setTimeout(escrever, 30);
        } else {
            terminal.innerHTML += "\n";
            if (callback) setTimeout(callback, 400);
        }
    }
    escrever();
}

function iniciar(index = 0) {
    if (index < mensagens.length) {
        digitar(mensagens[index], () => iniciar(index + 1));
    } else {
        setTimeout(mostrarDashboard, 800);
    }
}

    /* Dashboard das informaçoes */
function mostrarDashboard() {
    terminal.style.display = "none";
    document.getElementById("dashboard").style.display = "block";

    textoinfo.style.display = "block";
    document.body.classList.add("glow"); /* Fundo verde */

    fetch('https://ipinfo.io/json') /* Api ipinfo.io para mostrar os dados */
    .then(res => res.json())
    .then(data => {
        
        /* dados da api ipinfo */
        document.getElementById("ip").textContent = data.ip;
        document.getElementById("location").textContent = `${data.city}, ${data.region}, ${data.country}`;
        document.getElementById("org").textContent = data.org;

        document.getElementById("device").textContent = navigator.platform;
        document.getElementById("browser").textContent = navigator.userAgent;
        document.getElementById("lang").textContent = navigator.language;
        
        /* Dados do Fingerprint */
        const fp = getFingerprint();

        document.getElementById("screen").textContent =
            `${screen.width}x${screen.height}`;

        document.getElementById("timezone").textContent = fp.timezone;
        document.getElementById("cpu").textContent = fp.hardwareConcurrency;
        document.getElementById("memory").textContent = fp.memory;

        document.getElementById("canvas").textContent = canvasFingerprint();

        const webgl = webglFingerprint();
        const extra = extraFingerprint();

        document.getElementById("webgl").textContent =
            `${webgl.vendor} | ${webgl.renderer}`;

        document.getElementById("extra").textContent =
            JSON.stringify(extra, null, 2);

        audioFingerprint()
        .then(audio => {
            document.getElementById("audio").textContent = audio;

            document.querySelectorAll(".value").forEach(e =>
                e.classList.remove("loading")
            );
        });
    });
}

/* =======================
   Funçoes do Fingerprint
======================= */

function getFingerprint() {
    return {
        userAgent: navigator.userAgent,
        language: navigator.language,
        platform: navigator.platform,
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        hardwareConcurrency: navigator.hardwareConcurrency,
        memory: navigator.deviceMemory || "desconhecido"
    };
}

function canvasFingerprint() {
    const canvas = document.createElement("canvas");
    const ctx = canvas.getContext("2d");

    ctx.font = "14px Arial";
    ctx.fillText("fingerprint", 2, 2);

    return canvas.toDataURL().slice(0, 30);
}

function webglFingerprint() {
    try {
        const canvas = document.createElement("canvas");
        const gl = canvas.getContext("webgl");

        if (!gl) return { vendor: "n/a", renderer: "n/a" };

        const debug = gl.getExtension("WEBGL_debug_renderer_info");

        return {
            vendor: debug ? gl.getParameter(debug.UNMASKED_VENDOR_WEBGL) : "unknown",
            renderer: debug ? gl.getParameter(debug.UNMASKED_RENDERER_WEBGL) : "unknown"
        };
    } catch {
        return { vendor: "erro", renderer: "erro" };
    }
}

function extraFingerprint() {
    return {
        devicePixelRatio: window.devicePixelRatio,
        maxTouchPoints: navigator.maxTouchPoints,
        plugins: navigator.plugins.length,
        webdriver: navigator.webdriver
    };
}

async function audioFingerprint() {
    try {
        const AudioContext = window.OfflineAudioContext || window.webkitOfflineAudioContext;

        const ctx = new AudioContext(1, 44100, 44100);
        const osc = ctx.createOscillator();
        const comp = ctx.createDynamicsCompressor();

        osc.connect(comp);
        comp.connect(ctx.destination);

        osc.start(0);
        ctx.startRendering();

        return await new Promise(resolve => {
            ctx.oncomplete = e => {
                const data = e.renderedBuffer.getChannelData(0);
                resolve(data.slice(0, 50).reduce((a, b) => a + Math.abs(b), 0).toFixed(2));
            };
        });
    } catch {
        return "não suportado";
    }
}

setTimeout(() => iniciar(), 500);
</script>

</body>
</html>