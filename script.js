    function toggleTheme(){document.body.classList.add('sw');const h=document.documentElement,n=h.getAttribute('data-theme')==='dark'?'light':'dark';h.setAttribute('data-theme',n);document.getElementById('themeToggle').textContent=n==='dark'?'☀':'☽';localStorage.setItem('theme',n);setTimeout(()=>document.body.classList.remove('sw'),600)}
    function toggleLang(){const h=document.documentElement,n=h.getAttribute('data-lang')==='zh'?'en':'zh';h.setAttribute('data-lang',n);document.getElementById('langToggle').textContent=n==='zh'?'EN':'中文';localStorage.setItem('lang',n);applyLang(n)}
    function applyLang(l){document.querySelectorAll('[data-zh][data-en]').forEach(e=>{const v=e.getAttribute('data-'+l);if(v!==null)e.innerHTML=v})}
    (function(){const t=localStorage.getItem('theme');if(t){document.documentElement.setAttribute('data-theme',t);document.getElementById('themeToggle').textContent=t==='dark'?'☀':'☽'}const l=localStorage.getItem('lang');if(l){document.documentElement.setAttribute('data-lang',l);document.getElementById('langToggle').textContent=l==='zh'?'EN':'中文';applyLang(l)}})();

    // Scroll fade-up
    const obs=new IntersectionObserver(entries=>{entries.forEach(e=>{if(e.isIntersecting){e.target.classList.add('visible');obs.unobserve(e.target)}})},{threshold:.08});
    document.querySelectorAll('section').forEach(s=>obs.observe(s));

    // Count-up animation for numbers
    function countUp(el,target,duration){
      const start=performance.now();
      const suffix=el.dataset.suffix||'';
      const prefix=el.dataset.prefix||'';
      (function tick(now){
        const p=Math.min((now-start)/duration,1);
        const ease=1-Math.pow(1-p,3);
        const val=Math.round(ease*target);
        el.textContent=prefix+val.toLocaleString()+suffix;
        if(p<1)requestAnimationFrame(tick);
      })(start);
    }
    const countObs=new IntersectionObserver(entries=>{
      entries.forEach(e=>{
        if(!e.isIntersecting)return;
        const el=e.target;
        const raw=el.textContent.replace(/[^0-9.]/g,'');
        const num=parseFloat(raw);
        if(isNaN(num))return;
        const suffix=el.textContent.replace(/[0-9.,]/g,'').trim();
        if(suffix)el.dataset.suffix=suffix;
        countUp(el,Math.round(num),1200);
        countObs.unobserve(el);
      });
    },{threshold:.3});
    document.querySelectorAll('.stat-num,.result-num,.svc-metric,.finding-num').forEach(el=>countObs.observe(el));

    // Staggered card reveal
    const staggerObs=new IntersectionObserver(entries=>{
      entries.forEach(e=>{
        if(!e.isIntersecting)return;
        const cards=e.target.querySelectorAll('.stagger');
        cards.forEach((c,i)=>{c.style.transitionDelay=i*80+'ms';c.classList.add('visible')});
        staggerObs.unobserve(e.target);
      });
    },{threshold:.05});
    document.querySelectorAll('[data-stagger]').forEach(g=>staggerObs.observe(g));
