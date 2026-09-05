// BGSSAI Build Prototype Interactive Script
(function () {
  // Theme management
  const savedTheme = localStorage.getItem('bgssai-theme') || 'light';
  if (savedTheme === 'dark') {
    document.body.classList.add('theme-dark');
  }

  window.toggleTheme = function () {
    const isDark = document.body.classList.toggle('theme-dark');
    localStorage.setItem('bgssai-theme', isDark ? 'dark' : 'light');
    const btn = document.querySelector('.theme-btn');
    if (btn) {
      btn.innerText = isDark ? 'Theme: Dark' : 'Theme: Light';
    }
  };

  // Setup theme button on load
  document.addEventListener('DOMContentLoaded', () => {
    const btn = document.querySelector('.theme-btn');
    if (btn) {
      const isDark = document.body.classList.contains('theme-dark');
      btn.innerText = isDark ? 'Theme: Dark' : 'Theme: Light';
    }

    // Auto highlight active nav links
    const current = location.pathname.split('/').pop();
    document.querySelectorAll('.aw-nav a, .chips-row a, .activity-bar a').forEach((el) => {
      const href = el.getAttribute('href');
      if (href && href.endsWith(current)) {
        el.classList.add('active', 'on');
      }
    });
  });
})();
