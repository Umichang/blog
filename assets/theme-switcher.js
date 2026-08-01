(() => {
  const storageKey = 'theme-preference';
  const validThemes = new Set(['light', 'dark', 'system']);
  const root = document.documentElement;
  const picker = document.querySelector('[data-theme-picker]');
  const themeColor = document.querySelector('#theme-color');
  const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');

  if (!picker) return;

  const toggle = picker.querySelector('.theme-picker__toggle');
  const menu = picker.querySelector('.theme-picker__menu');
  const options = Array.from(picker.querySelectorAll('[data-theme-option]'));
  const labels = { light: 'ライト', dark: 'ダーク', system: 'システム' };
  const icons = { light: '☀️', dark: '🌙', system: '🖥️' };
  let preference = validThemes.has(root.dataset.theme) ? root.dataset.theme : 'system';

  const effectiveTheme = () => (preference === 'system'
    ? (mediaQuery.matches ? 'dark' : 'light')
    : preference);

  const updateInterface = () => {
    const effective = effectiveTheme();
    root.dataset.theme = preference;
    toggle.querySelector('span').textContent = icons[preference];
    toggle.setAttribute('aria-label', `表示テーマ: ${labels[preference]}（変更）`);
    toggle.title = `表示テーマ: ${labels[preference]}`;
    themeColor?.setAttribute('content', effective === 'dark' ? '#191817' : '#f3f2f2');
    options.forEach((option) => {
      option.setAttribute('aria-checked', String(option.dataset.themeOption === preference));
    });
  };

  const closeMenu = ({ restoreFocus = false } = {}) => {
    menu.hidden = true;
    toggle.setAttribute('aria-expanded', 'false');
    if (restoreFocus) toggle.focus();
  };

  const openMenu = () => {
    menu.hidden = false;
    toggle.setAttribute('aria-expanded', 'true');
    const selectedOption = options.find((option) => option.dataset.themeOption === preference);
    selectedOption?.focus();
  };

  const setPreference = (nextPreference) => {
    if (!validThemes.has(nextPreference)) return;

    preference = nextPreference;
    try {
      localStorage.setItem(storageKey, preference);
    } catch (_) {
      // 保存領域を使えない環境でも、そのページでは選択を反映する。
    }
    updateInterface();
  };

  toggle.addEventListener('click', () => {
    if (menu.hidden) openMenu();
    else closeMenu();
  });

  options.forEach((option, index) => {
    option.addEventListener('click', () => {
      setPreference(option.dataset.themeOption);
      closeMenu({ restoreFocus: true });
    });
    option.addEventListener('keydown', (event) => {
      if (!['ArrowDown', 'ArrowUp', 'Home', 'End'].includes(event.key)) return;

      event.preventDefault();
      const nextIndex = event.key === 'Home' ? 0
        : event.key === 'End' ? options.length - 1
          : (index + (event.key === 'ArrowDown' ? 1 : -1) + options.length) % options.length;
      options[nextIndex].focus();
    });
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !menu.hidden) closeMenu({ restoreFocus: true });
  });
  document.addEventListener('click', (event) => {
    if (!menu.hidden && !picker.contains(event.target)) closeMenu();
  });
  mediaQuery.addEventListener('change', () => {
    if (preference === 'system') updateInterface();
  });

  updateInterface();
})();
