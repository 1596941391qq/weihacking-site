    function toggleTheme(){document.body.classList.add('sw');const h=document.documentElement,n=h.getAttribute('data-theme')==='dark'?'light':'dark';h.setAttribute('data-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀':'☽';localStorage.setItem('theme',n);setTimeout(()=>document.body.classList.remove('sw'),600)}
    function toggleLang(){const h=document.documentElement,n=h.getAttribute('data-lang')==='zh'?'en':'zh';h.setAttribute('data-lang',n);document.getElementById('langToggle').textContent=n==='zh'?'EN':'中文';localStorage.setItem('lang',n);applyLang(n)}
    function applyLang(l){document.querySelectorAll('[data-zh][data-en]').forEach(e=>{const v=e.getAttribute('data-'+l);if(v!==null)e.innerHTML=v})}
    (function(){const t=localStorage.getItem('theme');if(t){document.documentElement.setAttribute('data-theme',t);document.getElementById('themeToggle').textContent=t==='dark'?'☀':'☽'}const l=localStorage.getItem('lang');if(l){document.documentElement.setAttribute('data-lang',l);document.getElementById('langToggle').textContent=l==='zh'?'EN':'中文';applyLang(l)}})();
    // Scroll fade-up
    const obs=new IntersectionObserver(entries=>{entries.forEach(e=>{if(e.isIntersecting){e.target.classList.add('visible');obs.unobserve(e.target)}})},{threshold:.08});
    document.querySelectorAll('section').forEach(s=>obs.observe(s));
