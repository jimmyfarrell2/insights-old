(() => {
  $('.insight-body code').each((index, elem) => {
    let $elem = $(elem);
    let text = $elem.text().replace(/&lt;/g, '<').replace(/&gt;/g, '>');
    $elem.text(text)
  });
  $('.insight-body.hidden').removeClass('hidden');
})();
