if window.PHANTOMJS or window.location.search.indexOf('cov=true') >= 0
  # Synchronously get Blanket.
  request = new XMLHttpRequest()
  request.open 'GET', '../vendor/bower/blanket/dist/qunit/blanket.js', no
  request.send()

  script = document.createElement 'script'
  script.type = 'text/javascript'
  # There is no event fired when HTML report is added to tests.
  script.text = request.responseText +
    # Add checkbox to toggle uncovered branches/lines.
    """
    (function() {
      var report = blanket.report;
      blanket.report = function() {
        report.apply(blanket, arguments);
        $("#blanket-main .rs:contains('100 %')")
          .parent(":not('.grand-total')").hide();
        $(".bl-success:not(.grand-total) > .rs:nth-child(4)").each(function() {
          var statements = this.innerHTML.split('/');
          if (statements[1] != 0 && statements[0]/statements[1] !== 1) {
            $(this.parentNode).show();
          }
        });
      }
    })();
    """

  script.setAttribute(
    'data-cover-adapter'
    '../node_modules/grunt-blanket-mocha/support/mocha-blanket.js'
  )
  script.setAttribute 'data-cover-flags', 'branchTracking'
  script.setAttribute 'data-cover-never', '[\'templates\']'
  script.setAttribute(
    'data-cover-only'
    '//src/(controllers|ext|lib|models|views)/'
  )

  (document.body || document.head).appendChild script
