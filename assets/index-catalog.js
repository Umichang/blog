(() => {
  const root = document.querySelector('.post-index');
  const controls = document.querySelector('[data-index-catalog-controls]');

  if (!root || !controls) return;

  const search = controls.querySelector('#index-title-search');
  const status = controls.querySelector('#index-search-status');
  const headings = Array.from(root.children)
    .filter((element) => /^H[23]$/.test(element.tagName));

  if (!search || !status || headings.length === 0) return;

  const headingLevel = (heading) => Number(heading.tagName.slice(1));
  const normalize = (value) => value
    .normalize('NFKC')
    .toLocaleLowerCase('ja-JP')
    .replace(/\s+/g, '');
  const wrappers = new Map();

  for (let index = headings.length - 1; index >= 0; index -= 1) {
    const heading = headings[index];
    const level = headingLevel(heading);
    const nextBoundary = headings.slice(index + 1)
      .find((candidate) => headingLevel(candidate) <= level);
    const boundary = wrappers.get(nextBoundary);
    const wrapper = level === 3
      ? document.createElement('details')
      : document.createElement('section');

    if (level === 3) {
      const summary = document.createElement('summary');
      const content = document.createElement('div');

      wrapper.className = 'catalog-section';
      summary.className = 'catalog-section__summary';
      content.className = 'catalog-section__content';
      heading.classList.add('catalog-section__heading');

      heading.before(wrapper);
      summary.append(heading);
      wrapper.append(summary, content);

      let node = wrapper.nextSibling;
      while (node && node !== boundary) {
        const nextNode = node.nextSibling;
        content.append(node);
        node = nextNode;
      }
    } else {
      wrapper.className = 'catalog-group catalog-group--h2';
      if (index === 0) wrapper.classList.add('catalog-group--first');

      heading.before(wrapper);
      wrapper.append(heading);

      let node = wrapper.nextSibling;
      while (node && node !== boundary) {
        const nextNode = node.nextSibling;
        wrapper.append(node);
        node = nextNode;
      }
    }

    wrappers.set(heading, wrapper);
  }

  const sections = Array.from(root.querySelectorAll('.catalog-section'));
  const groups = Array.from(root.querySelectorAll('.catalog-group'));
  const buildSearchData = (value) => {
    const characters = Array.from(value);
    const normalizedCharacters = [];
    const sourceIndexes = [];

    characters.forEach((character, sourceIndex) => {
      Array.from(normalize(character)).forEach((normalizedCharacter) => {
        normalizedCharacters.push(normalizedCharacter);
        sourceIndexes.push(sourceIndex);
      });
    });

    return { characters, normalizedCharacters, sourceIndexes };
  };
  const articles = Array.from(root.querySelectorAll('li'))
    .map((item) => {
      const link = item.querySelector('a');
      if (!link) return null;

      return {
        item,
        link,
        title: link.textContent,
        searchData: buildSearchData(link.textContent),
      };
    })
    .filter(Boolean);
  const findRanges = (article, queryCharacters) => {
    const { normalizedCharacters, sourceIndexes } = article.searchData;
    const ranges = [];

    for (let start = 0; start <= normalizedCharacters.length - queryCharacters.length; start += 1) {
      const matches = queryCharacters.every(
        (character, offset) => normalizedCharacters[start + offset] === character,
      );
      if (!matches) continue;

      ranges.push([sourceIndexes[start], sourceIndexes[start + queryCharacters.length - 1]]);
      start += queryCharacters.length - 1;
    }

    return ranges;
  };
  const resetHighlight = (article) => {
    article.link.replaceChildren(document.createTextNode(article.title));
  };
  const highlight = (article, ranges) => {
    const fragment = document.createDocumentFragment();
    let cursor = 0;

    ranges.forEach(([start, end]) => {
      if (cursor < start) fragment.append(article.searchData.characters.slice(cursor, start).join(''));

      const mark = document.createElement('mark');
      mark.className = 'catalog-search-highlight';
      mark.textContent = article.searchData.characters.slice(start, end + 1).join('');
      fragment.append(mark);
      cursor = end + 1;
    });

    if (cursor < article.searchData.characters.length) {
      fragment.append(article.searchData.characters.slice(cursor).join(''));
    }
    article.link.replaceChildren(fragment);
  };
  const reset = () => {
    articles.forEach((article) => {
      article.item.hidden = false;
      resetHighlight(article);
    });
    sections.forEach((section) => {
      section.hidden = false;
      section.open = false;
    });
    groups.forEach((group) => { group.hidden = false; });
    status.textContent = `全${articles.length}件の記事から検索できます。`;
  };
  const filter = () => {
    const normalizedQuery = normalize(search.value);

    if (!normalizedQuery) {
      reset();
      return;
    }

    const queryCharacters = Array.from(normalizedQuery);
    let matches = 0;

    articles.forEach((article) => {
      const ranges = findRanges(article, queryCharacters);
      const isMatch = ranges.length > 0;

      article.item.hidden = !isMatch;
      if (isMatch) {
        highlight(article, ranges);
        matches += 1;
      } else {
        resetHighlight(article);
      }
    });

    sections.forEach((section) => {
      const hasMatch = Boolean(section.querySelector('li:not([hidden])'));
      section.hidden = !hasMatch;
      section.open = hasMatch;
    });
    groups.forEach((group) => {
      group.hidden = !group.querySelector('li:not([hidden])');
    });
    status.textContent = matches === 0
      ? '一致する記事はありません。'
      : `${matches}件の記事が見つかりました。`;
  };

  controls.hidden = false;
  reset();
  search.addEventListener('input', filter);
})();
