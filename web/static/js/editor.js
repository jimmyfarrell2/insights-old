(() => {
  let textarea = document.getElementById('insight_body');
  new SimpleMDE({
    element: textarea,
    forceSync: true,
    spellChecker: false,
    status: false,
    renderingConfig: {
      singleLineBreaks: true
    },
    shortcuts: {
      toggleSideBySide: null,
      toggleFullScreen: null,
      cleanBlock: null
    },
    toolbar: [{
      name: 'save',
      action: save,
      className: 'fa fa-save',
      title: 'Save',
    }, {
      name: 'preview',
      action: SimpleMDE.togglePreview,
      className: 'fa fa-eye no-disable',
      title: 'Preview',
    }, '|', {
      name: 'heading-1',
      action: SimpleMDE.toggleHeading1,
      className: 'fa fa-header fa-header-x fa-header-1',
      title: 'Heading 1',
    }, {
      name: 'heading-2',
      action: SimpleMDE.toggleHeading2,
      className: 'fa fa-header fa-header-x fa-header-2',
      title: 'Heading 2',
    }, {
      name: 'heading-3',
      action: SimpleMDE.toggleHeading3,
      className: 'fa fa-header fa-header-x fa-header-3',
      title: 'Heading 3',
    }, '|', {
      name: 'bold',
      action: SimpleMDE.toggleBold,
      className: 'fa fa-bold',
      title: 'Bold',
    }, {
      name: 'italic',
      action: SimpleMDE.toggleItalic,
      className: 'fa fa-italic',
      title: 'Italic',
    }, {
      name: 'strikethrough',
      action: SimpleMDE.toggleStrikethrough,
      className: 'fa fa-strikethrough',
      title: 'Strikethrough',
    }, '|', {
      name: 'quote',
      action: SimpleMDE.toggleBlockquote,
      className: 'fa fa-quote-left',
      title: 'Quote',
    }, {
      name: 'unordered-list',
      action: SimpleMDE.toggleUnorderedList,
      className: 'fa fa-list-ul',
      title: 'Unordered List'
    }, {
      name: 'ordered-list',
      action: SimpleMDE.toggleOrderedList,
      className: 'fa fa-list-ol',
      title: 'Numbered List'
    }, {
      name: 'code',
      action: SimpleMDE.toggleCodeBlock,
      className: 'fa fa-code',
      title: 'Code'
    }, '|', {
      name: 'table',
      action: SimpleMDE.drawTable,
      className: 'fa fa-table',
      title: 'Insert Table'
    }, {
      name: 'image',
      action: SimpleMDE.drawImage,
      className: 'fa fa-picture-o',
      title: 'Insert Image'
    }, {
      name: 'link',
      action: SimpleMDE.drawLink,
      className: 'fa fa-link',
      title: 'Create Link'
    }]
  });

  function save() {
    let $form = $('#insight-form');
    $.ajax({
      url: $form.attr('action'),
      type: 'POST',
      data: $form.serialize(),
      success: result => {
        console.log('success');
      },
      error: err => {
        console.log('error');
      }
    });
  }
})()
