<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Simulador de coleta de dados web</title>

<style>
body {
    margin: 0;
    background: #050505;
    color: #00ff88;
    font-family: monospace;
}

/* INTRO TERMINAL */
#terminal {
    padding: 20px;
    font-size: 18px;
}

/* DASHBOARD */
#dashboard {
    display: none;
    padding: 20px;
}

h1 {
    text-align: center;
    margin-bottom: 20px;
    color: #00ffcc;
}

/* CARDS */
.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

.card {
    background: rgba(0,255,100,0.05);
    border: 1px solid rgba(0,255,100,0.2);
    padding: 15px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0,255,100,0.2);
    transition: 0.3s;
}

.card:hover {
    transform: scale(1.03);
    box-shadow: 0 0 20px rgba(0,255,100,0.4);
}

.label {
    color: #00ffaa;
    font-size: 14px;
}

.value {
    font-size: 18px;
    margin-top: 5px;
    color: #ccffcc;
}

/* LOADING */
.loading {
    animation: blink 1s infinite;
}

@keyframes blink {
    50% { opacity: 0.3; }
}
  
#textoinfo {
    display: none;
    margin: 10px auto 20px;
    max-width: 600px;
    padding: 12px;
    border: 1px solid rgba(0,255,100,0.2);
    border-radius: 8px;
    background: rgba(0,255,100,0.05);
    color: red;
    text-align: center;
    font-size: 14px;
} 
  
</style>
</head>

<body>

<div id="terminal"></div>

<div id="dashboard">
    <h1>Simulador de coleta de dados web</h1>
    <div id="textoinfo">
        Nenhum dado é armazenado. As informações são exibidas apenas para demonstração.
    </div>
    
    <div class="grid">

        <div class="card">
            <div class="label">Endereço IP</div>
            <div id="ip" class="value loading">loading...</div>
        </div>

        <div class="card">
            <div class="label">Localização</div>
            <div id="location" class="value loading">loading...</div>
        </div>

        <div class="card">
            <div class="label">Provedor de internet</div>
            <div id="org" class="value loading">loading...</div>
        </div>

        <div class="card">
            <div class="label">Sistema</div>
            <div id="device" class="value loading">loading...</div>
        </div>

        <div class="card">
            <div class="label">Navegador</div>
            <div id="browser" class="value loading">loading...</div>
        </div>

        <div class="card">
            <div class="label">Idioma</div>
            <div id="lang" class="value loading">loading...</div>
        </div>
     
    </div>
</div>

<script>
const textoinfo = document.getElementById('textoinfo');
const terminal = document.getElementById("terminal");

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

function mostrarDashboard() {
    terminal.style.display = "none";
    document.getElementById("dashboard").style.display = "block";
    
    textoinfo.style.display = "block";
    textoinfo.textContent = "Nenhum dado é armazenado. As informações são exibidas apenas para demonstração.";

    
    
    fetch('https://ipinfo.io/json')
    .then(res => res.json())
    .then(data => {
        document.getElementById("ip").textContent = data.ip;
        document.getElementById("location").textContent = `${data.city}, ${data.region}, ${data.country}`;
        document.getElementById("org").textContent = data.org;

        document.getElementById("device").textContent = navigator.platform;
        document.getElementById("browser").textContent = navigator.userAgent;
        document.getElementById("lang").textContent = navigator.language;

        document.querySelectorAll(".value").forEach(e => e.classList.remove("loading"));
      
      
    });
}

setTimeout(() => iniciar(), 500);
</script>

</body>
</html>