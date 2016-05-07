(() => {
  let textarea = document.getElementById('insight_body');
  new SimpleMDE({
    element: textarea,
    hideIcons: ['guide'],
    spellChecker: false,
    status: ['words']
  });
})()
