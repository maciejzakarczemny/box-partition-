<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<title>Cuboid Box Partitions</title>
<style>
@import url("https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@300;400;700&family=Playfair+Display:wght@400;700&display=swap");

:root{
  --bg:#0a0a0f;
  --surface:#12121a;
  --surface2:#1a1a26;
  --border:#2a2a40;
  --accent:#6c63ff;
  --accent2:#ff6b6b;
  --accent3:#43e89e;
  --text:#e8e8f0;
  --text-dim:#7878a0;
  --mono:"JetBrains Mono", monospace;
  --serif:"Playfair Display", serif;
}

*{margin:0;padding:0;box-sizing:border-box;}
html,body{height:100%;}

body{
  background:var(--bg);
  color:var(--text);
  font-family:var(--mono);
  display:flex;
  flex-direction:column;
  min-height:100dvh;
  overflow:hidden;
}

body::before{
  content:"";
  position:fixed;
  inset:0;
  background-image:
    linear-gradient(rgba(108,99,255,0.03) 1px,transparent 1px),
    linear-gradient(90deg,rgba(108,99,255,0.03) 1px,transparent 1px);
  background-size:40px 40px;
  pointer-events:none;
  z-index:0;
}

header{
  position:relative;
  z-index:2;
  padding:20px 24px 14px;
  border-bottom:1px solid var(--border);
  flex-shrink:0;
  background:rgba(10,10,15,0.92);
  backdrop-filter:blur(8px);
}

header h1{
  font-family:var(--serif);
  font-size:clamp(1.2rem,2.5vw,2rem);
  font-weight:700;
  letter-spacing:-0.02em;
  color:var(--text);
  margin-bottom:4px;
}

header h1 span{color:var(--accent);}

header p{
  color:var(--text-dim);
  font-size:0.7rem;
  letter-spacing:0.05em;
  text-transform:uppercase;
}

.main-layout{
  position:relative;
  z-index:1;
  display:grid;
  grid-template-columns:300px 1fr;
  flex:1;
  min-height:0;
  overflow:hidden;
}

.sidebar{
  border-right:1px solid var(--border);
  padding:16px 14px;
  display:flex;
  flex-direction:column;
  gap:14px;
  background:var(--surface);
  overflow:hidden;
  min-height:0;
}

.input-group{display:flex;flex-direction:column;gap:6px;}

.input-group label{
  font-size:0.65rem;
  letter-spacing:0.12em;
  text-transform:uppercase;
  color:var(--text-dim);
}

.dim-row{
  display:grid;
  grid-template-columns:1fr 1fr 1fr;
  gap:6px;
}

.dim-input-wrap{
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:3px;
}

.dim-label{
  font-size:0.6rem;
  color:var(--accent);
  letter-spacing:0.1em;
}

input[type="number"]{
  width:100%;
  background:var(--bg);
  border:1px solid var(--border);
  color:var(--text);
  font-family:var(--mono);
  font-size:1.1rem;
  font-weight:700;
  text-align:center;
  padding:8px 4px;
  border-radius:8px;
  outline:none;
  transition:border-color 0.2s, box-shadow 0.2s;
  -moz-appearance:textfield;
}

input[type="number"]::-webkit-outer-spin-button,
input[type="number"]::-webkit-inner-spin-button{
  -webkit-appearance:none;
  margin:0;
}

input[type="number"]:focus{
  border-color:var(--accent);
  box-shadow:0 0 0 2px rgba(108,99,255,0.15);
}

.btn-run{
  background:var(--accent);
  color:white;
  border:none;
  font-family:var(--mono);
  font-size:0.75rem;
  font-weight:700;
  letter-spacing:0.1em;
  text-transform:uppercase;
  padding:12px 16px;
  border-radius:10px;
  cursor:pointer;
  transition:background 0.2s, transform 0.1s, opacity 0.2s;
}

.btn-run:hover{background:#7c74ff;}
.btn-run:active{transform:scale(0.98);}
.btn-run.loading{pointer-events:none;opacity:0.7;}

.stats-box{
  background:var(--bg);
  border:1px solid var(--border);
  border-radius:10px;
  padding:10px 12px;
}

.stats-box .stat{
  display:flex;
  justify-content:space-between;
  align-items:baseline;
  gap:8px;
  padding:5px 0;
  border-bottom:1px solid var(--border);
}

.stats-box .stat:last-child{border-bottom:none;}

.stat-label{
  font-size:0.65rem;
  color:var(--text-dim);
  letter-spacing:0.05em;
  text-transform:uppercase;
}

.stat-value{
  font-size:1rem;
  font-weight:700;
  color:var(--accent3);
  text-align:right;
}

.partition-list{
  flex:1;
  min-height:0;
  overflow-y:auto;
  display:flex;
  flex-direction:column;
  gap:6px;
  padding-right:2px;
  -webkit-overflow-scrolling:touch;
}

.partition-item{
  background:var(--bg);
  border:1px solid var(--border);
  border-radius:8px;
  padding:9px 10px;
  cursor:pointer;
  transition:border-color 0.15s, background 0.15s;
  font-size:0.68rem;
  line-height:1.45;
}

.partition-item:hover{
  border-color:var(--accent);
  background:rgba(108,99,255,0.05);
}

.partition-item.active{
  border-color:var(--accent);
  background:rgba(108,99,255,0.12);
}

.part-index{
  font-size:0.55rem;
  color:var(--text-dim);
  margin-bottom:3px;
  letter-spacing:0.08em;
  text-transform:uppercase;
}

.part-blocks{color:var(--text);word-break:break-word;}
.part-count{color:var(--accent2);font-size:0.6rem;margin-top:2px;}

.main-panel{
  display:flex;
  flex-direction:column;
  min-width:0;
  min-height:0;
  overflow:hidden;
}

.view-header{
  padding:12px 18px;
  border-bottom:1px solid var(--border);
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:12px;
  flex-wrap:wrap;
  flex-shrink:0;
  background:rgba(10,10,15,0.88);
  backdrop-filter:blur(8px);
  z-index:2;
}

.view-title{
  font-family:var(--serif);
  font-size:1rem;
  color:var(--text);
}

.view-subtitle{
  font-size:0.63rem;
  color:var(--text-dim);
  letter-spacing:0.05em;
  text-transform:uppercase;
  margin-top:3px;
  word-break:break-word;
  max-width:100%;
}

.controls-stack{
  display:flex;
  flex-direction:column;
  gap:8px;
  align-items:flex-end;
}

.view-controls{
  display:flex;
  gap:6px;
  flex-wrap:wrap;
  justify-content:flex-end;
}

.btn-small{
  background:var(--surface2);
  border:1px solid var(--border);
  color:var(--text-dim);
  font-family:var(--mono);
  font-size:0.63rem;
  padding:6px 9px;
  border-radius:6px;
  cursor:pointer;
  letter-spacing:0.04em;
  text-transform:uppercase;
  transition:color 0.15s,border-color 0.15s,background 0.15s;
}

.btn-small:hover{
  color:var(--text);
  border-color:var(--accent);
}

.btn-small.active{
  color:var(--accent);
  border-color:var(--accent);
  background:rgba(108,99,255,0.08);
}

.canvas-area{
  flex:1;
  position:relative;
  min-height:260px;
}

#three-canvas{
  width:100% !important;
  height:100% !important;
  display:block;
  touch-action:none;
}

.canvas-hint{
  position:absolute;
  bottom:12px;
  left:50%;
  transform:translateX(-50%);
  font-size:0.58rem;
  color:var(--text-dim);
  letter-spacing:0.08em;
  text-transform:uppercase;
  pointer-events:none;
  background:rgba(10,10,15,0.8);
  padding:5px 12px;
  border-radius:20px;
  border:1px solid var(--border);
  white-space:nowrap;
}

.detail-panel{
  border-top:1px solid var(--border);
  padding:10px 18px;
  background:var(--surface);
  max-height:150px;
  overflow-y:auto;
  flex-shrink:0;
  -webkit-overflow-scrolling:touch;
}

.detail-title{
  font-size:0.6rem;
  color:var(--text-dim);
  letter-spacing:0.1em;
  text-transform:uppercase;
  margin-bottom:8px;
}

.blocks-grid{
  display:flex;
  flex-wrap:wrap;
  gap:6px;
}

.block-chip{
  background:var(--bg);
  border:1px solid var(--border);
  border-radius:4px;
  padding:3px 8px;
  font-size:0.68rem;
  display:flex;
  align-items:center;
  gap:5px;
}

.block-chip .swatch{
  width:8px;
  height:8px;
  border-radius:2px;
  flex-shrink:0;
}

.block-chip .dims{color:var(--text);}
.block-chip .pos{color:var(--text-dim);font-size:0.6rem;}

.empty-state{
  display:flex;
  flex-direction:column;
  align-items:center;
  justify-content:center;
  height:100%;
  gap:12px;
  color:var(--text-dim);
  font-size:0.75rem;
  letter-spacing:0.05em;
  text-transform:uppercase;
  padding:40px;
  text-align:center;
}

.empty-icon{
  font-size:2.5rem;
  opacity:0.3;
}

.progress-bar{
  height:3px;
  background:var(--border);
  border-radius:2px;
  overflow:hidden;
}

.progress-fill{
  height:100%;
  background:linear-gradient(90deg,var(--accent),var(--accent3));
  width:0%;
  transition:width 0.2s linear;
}

.zoom-row{
  display:flex;
  align-items:center;
  gap:8px;
  width:240px;
  max-width:100%;
}

.zoom-label{
  font-size:0.6rem;
  color:var(--text-dim);
  letter-spacing:0.08em;
  text-transform:uppercase;
  white-space:nowrap;
}

.zoom-value{
  font-size:0.65rem;
  color:var(--accent);
  font-weight:700;
  min-width:34px;
  text-align:right;
}

input[type="range"]{
  -webkit-appearance:none;
  appearance:none;
  flex:1;
  width:120px;
  height:4px;
  background:var(--border);
  border-radius:2px;
  outline:none;
  cursor:pointer;
}

input[type="range"]::-webkit-slider-thumb{
  -webkit-appearance:none;
  width:12px;
  height:12px;
  border-radius:50%;
  background:var(--accent);
  border:2px solid var(--bg);
  cursor:pointer;
}

input[type="range"]::-moz-range-thumb{
  width:12px;
  height:12px;
  border-radius:50%;
  background:var(--accent);
  border:2px solid var(--bg);
  cursor:pointer;
}

.warning{
  background:rgba(255,107,107,0.08);
  border:1px solid rgba(255,107,107,0.3);
  border-radius:8px;
  padding:8px 12px;
  font-size:0.68rem;
  color:var(--accent2);
  line-height:1.5;
}

.mobile-nav{
  display:none;
  gap:6px;
  width:100%;
}

.mobile-nav .btn-small{
  flex:1;
}

@media (max-width: 860px){
  body{
    overflow:auto;
    min-height:100svh;
  }

  .main-layout{
    display:flex;
    flex-direction:column;
    overflow:visible;
    min-height:auto;
  }

  .main-panel{
    order:1;
    min-height:auto;
    overflow:visible;
  }

  .sidebar{
    order:2;
    border-right:none;
    border-top:1px solid var(--border);
    overflow:visible;
    min-height:auto;
  }

  .view-header{
    position:sticky;
    top:0;
  }

  .canvas-area{
    height:46svh;
    min-height:320px;
    max-height:520px;
  }

  #three-canvas{
    touch-action:none;
  }

  .detail-panel{
    max-height:180px;
  }

  .partition-list{
    max-height:42svh;
    min-height:180px;
  }

  .mobile-nav{
    display:flex;
  }

  .controls-stack{
    width:100%;
    align-items:stretch;
  }

  .view-controls{
    justify-content:flex-start;
  }

  .zoom-row{
    width:100%;
  }

  header{
    padding:16px 16px 12px;
  }

  .sidebar{
    padding:14px 12px calc(16px + env(safe-area-inset-bottom));
  }

  .view-header{
    padding:10px 12px;
  }

  .detail-panel{
    padding:10px 12px;
  }

  .canvas-hint{
    bottom:8px;
    font-size:0.54rem;
    padding:4px 10px;
  }
}

@media (max-width: 520px){
  header h1{
    font-size:1.05rem;
  }

  header p{
    font-size:0.58rem;
  }

  .view-title{
    font-size:0.9rem;
  }

  .view-subtitle{
    font-size:0.56rem;
  }

  .btn-small{
    font-size:0.58rem;
    padding:6px 7px;
  }

  .btn-run{
    font-size:0.7rem;
    padding:11px 12px;
  }

  .partition-item{
    font-size:0.64rem;
    padding:8px;
  }

  .canvas-area{
    height:42svh;
    min-height:280px;
  }
}
</style>
</head>
<body>
<header>
  <h1>Cuboid <span>Box Partitions</span></h1>
  <p>Rectangular Cuboid Box Partitions • p(m, n, k)</p>
</header>

<div class="main-layout">
  <div class="sidebar">
    <div class="input-group">
      <label>Cuboid dimensions</label>
      <div class="dim-row">
        <div class="dim-input-wrap"><span class="dim-label">m</span><input type="number" id="inp-m" value="2" min="1" max="4"></div>
        <div class="dim-input-wrap"><span class="dim-label">n</span><input type="number" id="inp-n" value="2" min="1" max="4"></div>
        <div class="dim-input-wrap"><span class="dim-label">k</span><input type="number" id="inp-k" value="2" min="1" max="4"></div>
      </div>
      <div class="warning" id="warning" style="display:none"></div>
    </div>

    <div class="progress-bar" id="progress-bar" style="display:none">
      <div class="progress-fill" id="progress-fill"></div>
    </div>

    <button class="btn-run" id="btn-run" type="button">Find Partitions</button>

    <div class="stats-box" id="stats-box" style="display:none">
      <div class="stat"><span class="stat-label">Cuboid</span><span class="stat-value" id="stat-dims">—</span></div>
      <div class="stat"><span class="stat-label">Partitions</span><span class="stat-value" id="stat-count">—</span></div>
      <div class="stat"><span class="stat-label">Volume</span><span class="stat-value" id="stat-vol">—</span></div>
    </div>

    <div class="partition-list" id="partition-list"></div>
  </div>

  <div class="main-panel">
    <div class="view-header">
      <div>
        <div class="view-title" id="view-title">Select a partition from the list</div>
        <div class="view-subtitle" id="view-subtitle">3D visualization of box arrangements</div>
      </div>

      <div class="controls-stack">
        <div class="mobile-nav">
          <button class="btn-small" id="btn-prev" type="button">Prev</button>
          <button class="btn-small" id="btn-next" type="button">Next</button>
        </div>

        <div class="view-controls">
          <button class="btn-small active" id="btn-solid" type="button">Solid</button>
          <button class="btn-small" id="btn-wire" type="button">Wireframe</button>
          <button class="btn-small" id="btn-xray" type="button">X Ray</button>
        </div>

        <div class="zoom-row">
          <span class="zoom-label">Zoom</span>
          <input type="range" id="zoom-slider" min="10" max="300" value="100">
          <span class="zoom-value" id="zoom-display">100%</span>
        </div>
      </div>
    </div>

    <div class="canvas-area" id="canvas-area">
      <div class="empty-state" id="empty-state">
        <div class="empty-icon">⬛</div>
        <div>Enter dimensions and click<br>"Find Partitions"</div>
      </div>
      <canvas id="three-canvas" style="display:none"></canvas>
      <div class="canvas-hint" id="canvas-hint" style="display:none">Drag to rotate • Pinch page to zoom • Scroll results below</div>
    </div>

    <div class="detail-panel" id="detail-panel" style="display:none">
      <div class="detail-title">Boxes in this arrangement</div>
      <div class="blocks-grid" id="blocks-grid"></div>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
<script>
const COLORS = [
  0x6c63ff, 0xff6b6b, 0x43e89e, 0xffca3a, 0x4ecdc4,
  0xff9f43, 0xa29bfe, 0xfd79a8, 0x55efc4, 0xffeaa7,
  0x74b9ff, 0xe17055, 0x81ecec, 0xdfe6e9, 0xb2bec3
];

let partitions = [];
let activeIdx = -1;
let renderMode = "solid";

let renderer = null;
let scene = null;
let camera = null;
let animFrame = null;
let rotGroup = null;

let isDragging = false;
let lastMouse = null;
let scale = 1;

const geoCache = new Map();
const edgeCache = new Map();
const oriCache = new Map();

function isMobileView() {
  return window.matchMedia("(max-width: 860px)").matches;
}

function normBox(a, b, c) {
  return [a, b, c].sort((x, y) => x - y);
}

function normKey(a, b, c) {
  return normBox(a, b, c).join(",");
}

function allBoxTypes(m, n, k) {
  const t = new Map();
  for (let a = 1; a <= m; a++) {
    for (let b = 1; b <= n; b++) {
      for (let c = 1; c <= k; c++) {
        const nb = normBox(a, b, c);
        const key = nb.join(",");
        if (!t.has(key)) t.set(key, nb);
      }
    }
  }
  return [...t.values()].sort((x, y) => {
    const vx = x[0] * x[1] * x[2];
    const vy = y[0] * y[1] * y[2];
    if (vx !== vy) return vx - vy;
    for (let i = 0; i < 3; i++) {
      if (x[i] !== y[i]) return x[i] - y[i];
    }
    return 0;
  });
}

function getOrientations(box) {
  const key = box.join(",");
  if (oriCache.has(key)) return oriCache.get(key);

  const [a, b, c] = box;
  const perms = [
    [a, b, c], [a, c, b],
    [b, a, c], [b, c, a],
    [c, a, b], [c, b, a]
  ];

  const seen = new Set();
  const r = perms.filter(p => {
    const k = p.join(",");
    if (seen.has(k)) return false;
    seen.add(k);
    return true;
  });

  oriCache.set(key, r);
  return r;
}

function boxCount(n) {
  return n === 1 ? "1 box" : `${n} boxes`;
}

function repr(multiset) {
  const c = {};
  multiset.forEach(b => {
    c[b] = (c[b] || 0) + 1;
  });

  return Object.entries(c).map(([b, n]) => {
    const p = b.split(",").map(Number);
    return n > 1 ? `${n}×{${p.join("×")}}` : `{${p.join("×")}}`;
  }).join(", ");
}

function updProg(p) {
  document.getElementById("progress-fill").style.width = `${Math.max(0, Math.min(100, p))}%`;
}

function searchTilings(m, n, k, onProg) {
  const vol = m * n * k;
  const occ = new Uint8Array(vol);
  const boxes = allBoxTypes(m, n, k);
  const results = new Map();
  const cur = [];
  let nodes = 0;

  const idx = (x, y, z) => x * n * k + y * k + z;

  function coords(i) {
    const x = Math.floor(i / (n * k));
    const r = i % (n * k);
    const y = Math.floor(r / k);
    const z = r % k;
    return [x, y, z];
  }

  function firstEmpty() {
    for (let i = 0; i < vol; i++) {
      if (occ[i] === 0) return i;
    }
    return -1;
  }

  function canPlace(x, y, z, box) {
    const [a, b, c] = box;
    if (x + a > m || y + b > n || z + c > k) return false;

    for (let i = x; i < x + a; i++) {
      for (let j = y; j < y + b; j++) {
        for (let l = z; l < z + c; l++) {
          if (occ[idx(i, j, l)]) return false;
        }
      }
    }
    return true;
  }

  function place(x, y, z, box, v) {
    const [a, b, c] = box;
    for (let i = x; i < x + a; i++) {
      for (let j = y; j < y + b; j++) {
        for (let l = z; l < z + c; l++) {
          occ[idx(i, j, l)] = v;
        }
      }
    }
  }

  function bt(bid) {
    nodes++;
    if (nodes % 2000 === 0 && onProg) {
      onProg(Math.min(90, 5 + Math.log10(nodes + 1) * 16));
    }

    const fi = firstEmpty();

    if (fi === -1) {
      const ms = cur.map(e => normKey(...e.box)).sort();
      const msk = ms.join("|");

      if (!results.has(msk)) {
        results.set(msk, {
          multiset: ms,
          placement: cur.map(e => ({
            box: [...e.box],
            pos: [...e.pos]
          }))
        });
        if (onProg) onProg(Math.min(99, 40 + results.size * 0.5));
      }
      return;
    }

    const [x, y, z] = coords(fi);

    for (const box of boxes) {
      for (const o of getOrientations(box)) {
        if (!canPlace(x, y, z, o)) continue;
        place(x, y, z, o, bid);
        cur.push({ box: o, pos: [x, y, z] });
        bt(bid + 1);
        cur.pop();
        place(x, y, z, o, 0);
      }
    }
  }

  bt(1);

  if (onProg) onProg(100);

  return [...results.values()].sort((a, b) => {
    if (a.multiset.length !== b.multiset.length) {
      return a.multiset.length - b.multiset.length;
    }
    return a.multiset.join("|").localeCompare(b.multiset.join("|"));
  });
}

function runComputation() {
  const m = parseInt(document.getElementById("inp-m").value, 10);
  const n = parseInt(document.getElementById("inp-n").value, 10);
  const k = parseInt(document.getElementById("inp-k").value, 10);
  const warn = document.getElementById("warning");

  if (!Number.isInteger(m) || !Number.isInteger(n) || !Number.isInteger(k) || m < 1 || n < 1 || k < 1 || m > 4 || n > 4 || k > 4) {
    warn.textContent = "Dimensions must be integers in the range 1 to 4.";
    warn.style.display = "";
    return;
  }

  warn.style.display = "none";

  const btn = document.getElementById("btn-run");
  btn.classList.add("loading");
  btn.textContent = "Searching...";

  document.getElementById("partition-list").innerHTML = "";
  document.getElementById("stats-box").style.display = "none";
  document.getElementById("detail-panel").style.display = "none";
  document.getElementById("view-title").textContent = "Computing partitions...";
  document.getElementById("view-subtitle").textContent = "This may take a moment";
  document.getElementById("progress-bar").style.display = "";
  updProg(0);

  partitions = [];
  activeIdx = -1;

  setTimeout(() => {
    try {
      partitions = searchTilings(m, n, k, updProg);
      renderSidebar(m, n, k);
      if (isMobileView()) {
        window.scrollTo({ top: 0, behavior: "smooth" });
      }
    } catch (e) {
      warn.textContent = "An error occurred during computation.";
      warn.style.display = "";
      console.error(e);
    } finally {
      btn.classList.remove("loading");
      btn.textContent = "Find Partitions";
      document.getElementById("progress-bar").style.display = "none";
      updProg(0);
    }
  }, 20);
}

function renderSidebar(m, n, k) {
  const list = document.getElementById("partition-list");
  list.innerHTML = "";

  document.getElementById("stats-box").style.display = "";
  document.getElementById("stat-dims").textContent = `${m}×${n}×${k}`;
  document.getElementById("stat-count").textContent = partitions.length;
  document.getElementById("stat-vol").textContent = m * n * k;

  if (!partitions.length) {
    list.innerHTML = '<div style="color:var(--text-dim);font-size:0.7rem;padding:6px">No partitions found.</div>';
    document.getElementById("view-title").textContent = "No partitions found";
    updateNavButtons();
    return;
  }

  partitions.forEach((p, i) => {
    const el = document.createElement("div");
    el.className = "partition-item";
    el.innerHTML = `<div class="part-index">Partition ${i + 1}</div><div class="part-blocks">${repr(p.multiset)}</div><div class="part-count">${boxCount(p.multiset.length)}</div>`;
    el.addEventListener("click", () => selectPartition(i));
    list.appendChild(el);
  });

  selectPartition(0);
}

function updateNavButtons() {
  const prev = document.getElementById("btn-prev");
  const next = document.getElementById("btn-next");
  prev.disabled = activeIdx <= 0;
  next.disabled = activeIdx < 0 || activeIdx >= partitions.length - 1;
}

function selectPartition(idx) {
  if (idx < 0 || idx >= partitions.length) return;

  activeIdx = idx;

  const items = document.querySelectorAll(".partition-item");
  items.forEach((el, i) => {
    el.classList.toggle("active", i === idx);
  });

  const activeEl = items[idx];
  if (activeEl) {
    activeEl.scrollIntoView({ block: "nearest", behavior: "smooth" });
  }

  const p = partitions[idx];
  const dims = document.getElementById("stat-dims").textContent.split("×").map(Number);

  document.getElementById("view-title").textContent = `Partition ${idx + 1} of ${partitions.length}`;
  document.getElementById("view-subtitle").textContent = repr(p.multiset);

  render3D(p, dims[0], dims[1], dims[2]);
  renderDetail(p);
  updateNavButtons();
}

function renderDetail(p) {
  document.getElementById("detail-panel").style.display = "";
  const grid = document.getElementById("blocks-grid");
  grid.innerHTML = "";

  p.placement.forEach((block, i) => {
    const color = COLORS[i % COLORS.length];
    const hex = "#" + color.toString(16).padStart(6, "0");
    const div = document.createElement("div");
    div.className = "block-chip";
    div.innerHTML = `<div class="swatch" style="background:${hex}"></div><span class="dims">${block.box.join("×")}</span><span class="pos">@ (${block.pos.join(",")})</span>`;
    grid.appendChild(div);
  });
}

function onZoomSlider(val) {
  scale = Number(val) / 100;
  if (rotGroup) rotGroup.scale.setScalar(scale);
  document.getElementById("zoom-display").textContent = `${val}%`;
}

function syncSlider() {
  const p = Math.round(scale * 100);
  const s = document.getElementById("zoom-slider");
  const d = document.getElementById("zoom-display");
  if (s) s.value = p;
  if (d) d.textContent = `${p}%`;
}

function getBoxGeo(a, b, c, gap) {
  const k = `${a},${b},${c},${gap}`;
  if (!geoCache.has(k)) {
    geoCache.set(k, new THREE.BoxGeometry(a - gap, b - gap, c - gap));
  }
  return geoCache.get(k);
}

function getEdgeGeo(a, b, c, gap) {
  const k = `${a},${b},${c},${gap}`;
  if (!edgeCache.has(k)) {
    edgeCache.set(k, new THREE.EdgesGeometry(getBoxGeo(a, b, c, gap)));
  }
  return edgeCache.get(k);
}

function initRenderer() {
  const canvas = document.getElementById("three-canvas");
  if (renderer) {
    onResize();
    return;
  }

  renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
  renderer.shadowMap.enabled = true;
  renderer.shadowMap.type = THREE.PCFSoftShadowMap;

  canvas.addEventListener("mousedown", e => {
    isDragging = true;
    lastMouse = { x: e.clientX, y: e.clientY };
  });

  window.addEventListener("mouseup", () => {
    isDragging = false;
  });

  window.addEventListener("mousemove", e => {
    if (!isDragging || !rotGroup) return;
    rotGroup.rotation.y += (e.clientX - lastMouse.x) * 0.008;
    rotGroup.rotation.x += (e.clientY - lastMouse.y) * 0.008;
    lastMouse = { x: e.clientX, y: e.clientY };
  });

  canvas.addEventListener("touchstart", e => {
    if (!e.touches.length) return;
    isDragging = true;
    lastMouse = { x: e.touches[0].clientX, y: e.touches[0].clientY };
  }, { passive: true });

  canvas.addEventListener("touchend", () => {
    isDragging = false;
  });

  canvas.addEventListener("touchmove", e => {
    if (!isDragging || !rotGroup || !e.touches.length) return;
    rotGroup.rotation.y += (e.touches[0].clientX - lastMouse.x) * 0.012;
    rotGroup.rotation.x += (e.touches[0].clientY - lastMouse.y) * 0.012;
    lastMouse = { x: e.touches[0].clientX, y: e.touches[0].clientY };
  }, { passive: true });

  window.addEventListener("resize", onResize);
  onResize();
}

function onResize() {
  const area = document.getElementById("canvas-area");
  if (!area || !renderer) return;

  const w = Math.max(1, area.clientWidth);
  const h = Math.max(1, area.clientHeight);

  renderer.setSize(w, h, false);

  if (camera) {
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }
}

function setRenderMode(mode) {
  renderMode = mode;
  ["solid", "wire", "xray"].forEach(m => {
    document.getElementById(`btn-${m}`).classList.toggle("active", m === mode);
  });

  if (activeIdx >= 0) {
    const dims = document.getElementById("stat-dims").textContent.split("×").map(Number);
    render3D(partitions[activeIdx], dims[0], dims[1], dims[2]);
  }
}

function render3D(partition, m, n, k) {
  document.getElementById("empty-state").style.display = "none";
  const canvas = document.getElementById("three-canvas");
  canvas.style.display = "block";
  document.getElementById("canvas-hint").style.display = "";

  initRenderer();

  if (animFrame) cancelAnimationFrame(animFrame);

  scene = new THREE.Scene();
  scene.background = null;

  camera = new THREE.PerspectiveCamera(45, 1, 0.1, 1000);
  const md = Math.max(m, n, k);
  camera.position.set(md * 2.2, md * 1.8, md * 2.8);
  camera.lookAt(0, 0, 0);

  scene.add(new THREE.AmbientLight(0xffffff, 0.45));

  const sun = new THREE.DirectionalLight(0xffffff, 0.9);
  sun.position.set(10, 14, 8);
  scene.add(sun);

  const fill = new THREE.DirectionalLight(0x8888ff, 0.3);
  fill.position.set(-8, -4, -6);
  scene.add(fill);

  rotGroup = new THREE.Group();
  rotGroup.rotation.x = 0.35;
  rotGroup.rotation.y = -0.4;

  scale = Number(document.getElementById("zoom-slider").value) / 100;
  rotGroup.scale.setScalar(scale);
  scene.add(rotGroup);
  syncSlider();

  const cx = m / 2;
  const cy = n / 2;
  const cz = k / 2;
  const gap = 0.04;

  partition.placement.forEach((block, i) => {
    const [a, b, c] = block.box;
    const [px, py, pz] = block.pos;
    const color = COLORS[i % COLORS.length];

    if (renderMode === "wire") {
      const w = new THREE.LineSegments(
        getEdgeGeo(a, b, c, gap),
        new THREE.LineBasicMaterial({ color })
      );
      w.position.set(px + a / 2 - cx, py + b / 2 - cy, pz + c / 2 - cz);
      rotGroup.add(w);
    } else {
      const mesh = new THREE.Mesh(
        getBoxGeo(a, b, c, gap),
        new THREE.MeshPhongMaterial({
          color,
          transparent: renderMode === "xray",
          opacity: renderMode === "xray" ? 0.35 : 1,
          shininess: 60,
          specular: 0x444466
        })
      );
      mesh.position.set(px + a / 2 - cx, py + b / 2 - cy, pz + c / 2 - cz);
      rotGroup.add(mesh);

      if (renderMode === "xray") {
        const w = new THREE.LineSegments(
          getEdgeGeo(a, b, c, gap),
          new THREE.LineBasicMaterial({ color, transparent: true, opacity: 0.6 })
        );
        w.position.copy(mesh.position);
        rotGroup.add(w);
      }
    }
  });

  const ob = new THREE.LineSegments(
    new THREE.EdgesGeometry(new THREE.BoxGeometry(m, n, k)),
    new THREE.LineBasicMaterial({ color: 0x3a3a55 })
  );
  rotGroup.add(ob);

  onResize();

  function animate() {
    animFrame = requestAnimationFrame(animate);
    renderer.render(scene, camera);
  }

  animate();
}

document.getElementById("btn-run").addEventListener("click", runComputation);
document.getElementById("btn-solid").addEventListener("click", () => setRenderMode("solid"));
document.getElementById("btn-wire").addEventListener("click", () => setRenderMode("wire"));
document.getElementById("btn-xray").addEventListener("click", () => setRenderMode("xray"));
document.getElementById("btn-prev").addEventListener("click", () => selectPartition(activeIdx - 1));
document.getElementById("btn-next").addEventListener("click", () => selectPartition(activeIdx + 1));
document.getElementById("zoom-slider").addEventListener("input", e => onZoomSlider(e.target.value));

["inp-m", "inp-n", "inp-k"].forEach(id => {
  document.getElementById(id).addEventListener("keydown", e => {
    if (e.key === "Enter") runComputation();
  });
});

updateNavButtons();
</script>
</body>
</html>
