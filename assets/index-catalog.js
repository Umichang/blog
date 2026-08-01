(() => {
  const root = document.querySelector('.post-index');
  const controls = document.querySelector('[data-index-catalog-controls]');

  if (!root || !controls) return;

  const search = controls.querySelector('#index-title-search');
  const status = controls.querySelector('#index-search-status');
  const headings = Array.from(root.children).filter((element) => element.tagName === 'H2');

  if (!search || !status || headings.length === 0) return;

  const normalize = (value) => value
    .normalize('NFKC')
    .toLocaleLowerCase('ja-JP')
    .replace(/\s+/g, '');

  const sections = new Map();

  for (let index = headings.length - 1; index >= 0; index -= 1) {
    const heading = headings[index];
    const nextSection = sections.get(headings[index + 1]);
    const details = document.createElement('details');
    const summary = document.createElement('summary');
    const content = document.createElement('div');

    details.className = 'catalog-section';
    if (index === 0) details.classList.add('catalog-section--first');
    summary.className = 'catalog-section__summary';
    content.className = 'catalog-section__content';
    heading.classList.add('catalog-section__heading');

    heading.before(details);
    summary.append(heading);
    details.append(summary, content);

    let node = details.nextSibling;
    while (node && node !== nextSection) {
      const nextNode = node.nextSibling;
      content.append(node);
      node = nextNode;
    }

    sections.set(heading, details);
  }

  const sectionElements = Array.from(sections.values()).reverse();
  const articles = Array.from(root.querySelectorAll('.catalog-section li'))
    .map((item) => {
      const link = item.querySelector('a');
      return link ? { item, title: normalize(link.textContent) } : null;
    })
    .filter(Boolean);

  const reset = () => {
    articles.forEach(({ item }) => { item.hidden = false; });
    sectionElements.forEach((section, index) => {
      section.hidden = false;
      section.open = index === 0;
    });
    status.textContent = `全${articles.length}件の記事から検索できます。`;
  };

  const filter = () => {
    const query = normalize(search.value);

    if (!query) {
      reset();
      return;
    }

    let matches = 0;
    articles.forEach(({ item, title }) => {
      const isMatch = title.includes(query);
      item.hidden = !isMatch;
      if (isMatch) matches += 1;
    });

    sectionElements.forEach((section) => {
      const hasMatch = Boolean(section.querySelector('li:not([hidden])'));
      section.hidden = !hasMatch;
      section.open = hasMatch;
    });
    status.textContent = matches === 0
      ? '一致する記事はありません。'
      : `${matches}件の記事が見つかりました。`;
  };

  controls.hidden = false;
  reset();
  search.addEventListener('input', filter);
})();
